<?php
// Enable CORS to allow the Flutter client (possibly running on localhost or a different port) to access the API.
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json; charset=utf-8");

// Handle preflight OPTIONS requests immediately
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Load database configuration
if (!file_exists('config.php')) {
    echo json_encode(['error' => 'Database configuration file config.php is missing. Please create it from the template.']);
    exit;
}
require_once 'config.php';

// Retrieve the POST payload
$rawInput = file_get_contents('php://input');
$input = json_decode($rawInput, true);

if (!$input || !isset($input['action']) || !isset($input['sql'])) {
    echo json_encode(['error' => 'Invalid Request payload. Action and SQL query are required.']);
    exit;
}

$action = $input['action'];
$sql = $input['sql'];
$args = isset($input['args']) ? $input['args'] : [];

// 1. Intercept SQLite PRAGMAs and SQLite system tables
if (stripos($sql, 'PRAGMA user_version') !== false) {
    if (stripos($sql, '=') !== false) {
        // e.g., PRAGMA user_version = 5
        echo json_encode(['success' => true]);
        exit;
    } else {
        // e.g., PRAGMA user_version
        // We return the database schema version 5. This tells Drift the DB is up to date, skipping local SQLite migrations.
        echo json_encode(['rows' => [['user_version' => 5]]]);
        exit;
    }
}

if (stripos($sql, 'PRAGMA foreign_keys') !== false) {
    echo json_encode(['success' => true]);
    exit;
}

if (stripos($sql, 'sqlite_master') !== false || stripos($sql, 'sqlite_schema') !== false) {
    echo json_encode(['rows' => []]);
    exit;
}

if (stripos($sql, 'integrity_check') !== false) {
    echo json_encode(['rows' => [['integrity_check' => 'ok']]]);
    exit;
}

// 2. Adapt SQLite SQL syntax to MySQL syntax
$sql = adaptSqliteToMySql($sql);

try {
    // Establish PDO connection to MySQL
    $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";port=" . DB_PORT . ";charset=utf8mb4";
    $pdo = new PDO($dsn, DB_USER, DB_PASS, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false, // Ensure MySQL returns native datatypes (ints/floats) instead of strings
    ]);

    // Force MySQL to treat double quotes as identifier quotes (matching SQLite/PostgreSQL)
    $pdo->exec("SET SQL_MODE='ANSI_QUOTES'");

    // Handle batch execution (for transaction steps or multiple queries)
    if ($action === 'batch') {
        if (!isset($input['batch'])) {
            echo json_encode(['error' => 'Missing batch parameters.']);
            exit;
        }
        $batch = $input['batch'];
        $statements = $batch['statements'];
        $arguments = $batch['arguments'];

        $pdo->beginTransaction();
        try {
            $prepared = [];
            foreach ($statements as $index => $sqlQuery) {
                $sqlQuery = adaptSqliteToMySql($sqlQuery);
                $prepared[$index] = $pdo->prepare($sqlQuery);
            }

            foreach ($arguments as $argSet) {
                $stmtIndex = $argSet['statementIndex'];
                $statementArgs = $argSet['arguments'];
                $formattedArgs = array_map('formatArgValue', $statementArgs);
                $prepared[$stmtIndex]->execute($formattedArgs);
            }

            $pdo->commit();
            echo json_encode(['success' => true]);
            exit;
        } catch (Exception $e) {
            $pdo->rollBack();
            echo json_encode(['error' => 'Batch execution failed: ' . $e->getMessage()]);
            exit;
        }
    }

    // Prepare and execute standard query
    $stmt = $pdo->prepare($sql);

    // Format arguments (convert DateTime ISO strings and booleans to MySQL compatible formats)
    $formattedArgs = array_map('formatArgValue', $args);

    $stmt->execute($formattedArgs);

    // Format results based on the requested action
    $result = [];
    if ($action === 'select') {
        $rows = $stmt->fetchAll();
        // Convert any MySQL datetime strings or integers to ISO-8601 strings if they need to be read by Drift as DateTimes
        $result['rows'] = array_map('formatRowResult', $rows);
    } elseif ($action === 'insert') {
        $result['insertId'] = (int)$pdo->lastInsertId();
    } elseif ($action === 'update' || $action === 'delete') {
        $result['affectedRows'] = $stmt->rowCount();
    } else {
        // Custom or ping actions
        $result['success'] = true;
    }

    echo json_encode($result);

} catch (PDOException $e) {
    echo json_encode([
        'error' => $e->getMessage(),
        'sql' => $sql,
        'args' => $args
    ]);
}

/**
 * Clean up and convert SQLite-specific syntax to MySQL compatible SQL.
 */
function adaptSqliteToMySql($sql) {
    // Remove SQLite "ESCAPE '\'" clause from LIKE queries (MySQL supports backslash escapes by default)
    $sql = preg_replace('/\s+ESCAPE\s+[\'"]\\\\[\'"]/i', '', $sql);

    // SQLite "INSERT OR REPLACE INTO" -> MySQL "REPLACE INTO"
    $sql = preg_replace('/INSERT\s+OR\s+REPLACE\s+INTO/i', 'REPLACE INTO', $sql);

    // SQLite "INSERT OR IGNORE INTO" -> MySQL "INSERT IGNORE INTO"
    $sql = preg_replace('/INSERT\s+OR\s+IGNORE\s+INTO/i', 'INSERT IGNORE INTO', $sql);

    return $sql;
}

/**
 * Format query arguments to MySQL datatypes.
 */
function formatArgValue($value) {
    if ($value === null) {
        return null;
    }

    // Convert booleans to TINYINT 1/0
    if (is_bool($value)) {
        return $value ? 1 : 0;
    }

    // Convert Dart DateTime ISO strings (e.g. 2026-07-08T18:05:23.000) to MySQL datetime format (YYYY-MM-DD HH:MM:SS)
    if (is_string($value) && preg_match('/^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}/', $value)) {
        return date('Y-m-d H:i:s', strtotime($value));
    }

    return $value;
}

function formatRowResult($row) {
    foreach ($row as $key => $value) {
        if ($value === null) {
            continue;
        }

        // Convert standard MySQL datetime strings (YYYY-MM-DD HH:MM:SS) to Unix timestamp integers (seconds since epoch) so Drift's DateTime reader parses them successfully
        if (is_string($value) && preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/', $value)) {
            $row[$key] = strtotime($value);
        }
    }
    return $row;
}
?>
