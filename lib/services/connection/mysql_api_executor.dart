import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

class MySqlApiExecutor extends QueryExecutor {
  final String apiUrl;

  MySqlApiExecutor(this.apiUrl);

  @override
  SqlDialect get dialect => SqlDialect.sqlite;

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'ping',
          'sql': 'SELECT 1;',
          'args': [],
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['error'] == null;
      }
    } catch (e) {
      print('MySQL connection verification failed: $e');
    }
    return true; // Return true to allow trying queries anyway
  }

  @override
  Future<List<Map<String, dynamic>>> runSelect(
      String statement, List<dynamic> args) async {
    final response = await _post('select', statement, args);
    final rows = response['rows'] as List<dynamic>;
    return rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }

  @override
  Future<int> runInsert(String statement, List<dynamic> args) async {
    final response = await _post('insert', statement, args);
    return response['insertId'] as int;
  }

  @override
  Future<int> runUpdate(String statement, List<dynamic> args) async {
    final response = await _post('update', statement, args);
    return response['affectedRows'] as int;
  }

  @override
  Future<int> runDelete(String statement, List<dynamic> args) async {
    final response = await _post('delete', statement, args);
    return response['affectedRows'] as int;
  }

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {
    await _post('custom', statement, args ?? []);
  }

  @override
  Future<void> runBatched(BatchedStatements statements) async {
    final argsJson = statements.arguments.map((arg) => {
      'statementIndex': arg.statementIndex,
      'arguments': arg.arguments.map((val) {
        if (val is DateTime) return val.toIso8601String();
        if (val is bool) return val ? 1 : 0;
        return val;
      }).toList(),
    }).toList();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'batch',
          'sql': '',
          'args': [],
          'batch': {
            'statements': statements.statements,
            'arguments': argsJson,
          }
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'MySQL API batch returned status code ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw Exception('MySQL Database Batch Error: ${data['error']}');
      }
    } catch (e) {
      print('MySQL API Batch Request Failed: $e');
      rethrow;
    }
  }

  @override
  QueryExecutor beginExclusive() => this;

  @override
  TransactionExecutor beginTransaction() {
    return MySqlApiTransactionExecutor(this);
  }

  Future<dynamic> _post(String action, String sql, List<dynamic> args) async {
    // Serialize arguments to JSON-safe values
    final serializedArgs = args.map((arg) {
      if (arg is DateTime) {
        return arg.toIso8601String();
      }
      if (arg is bool) {
        return arg ? 1 : 0;
      }
      return arg;
    }).toList();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': action,
          'sql': sql,
          'args': serializedArgs,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'MySQL API returned status code ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw Exception('MySQL Database Error: ${data['error']}');
      }
      return data;
    } catch (e) {
      print('MySQL API Request Failed: $e. SQL: $sql, Args: $args');
      rethrow;
    }
  }
}

class MySqlApiTransactionExecutor extends TransactionExecutor {
  final MySqlApiExecutor parent;

  MySqlApiTransactionExecutor(this.parent);

  @override
  SqlDialect get dialect => SqlDialect.sqlite;

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async => true;

  @override
  Future<List<Map<String, dynamic>>> runSelect(
          String statement, List<dynamic> args) =>
      parent.runSelect(statement, args);

  @override
  Future<int> runInsert(String statement, List<dynamic> args) =>
      parent.runInsert(statement, args);

  @override
  Future<int> runUpdate(String statement, List<dynamic> args) =>
      parent.runUpdate(statement, args);

  @override
  Future<int> runDelete(String statement, List<dynamic> args) =>
      parent.runDelete(statement, args);

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) =>
      parent.runCustom(statement, args);

  @override
  Future<void> runBatched(BatchedStatements statements) =>
      parent.runBatched(statements);

  @override
  QueryExecutor beginExclusive() => this;

  @override
  TransactionExecutor beginTransaction() => this;

  @override
  bool get supportsNestedTransactions => false;

  @override
  Future<void> send() async {
    // Commit transaction - mocked for stateless HTTP
  }

  @override
  Future<void> rollback() async {
    // Rollback transaction - mocked for stateless HTTP
  }
}
