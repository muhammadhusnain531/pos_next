import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'mysql_api_executor.dart';

QueryExecutor openConnection() {
  const bool useRemoteMySql = true; // Set to false to fallback to browser-local storage (IndexedDB)
  
  if (useRemoteMySql) {
    // Automatically resolves to api.php hosted in the same directory as the web app
    final apiUrl = Uri.base.resolve('api.php').toString();
    return MySqlApiExecutor(apiUrl);
  }
  
  return WebDatabase('pos_next_db');
}

Future<void> performBackup() async {
  throw UnsupportedError("Backup not supported on Web yet");
}

Future<void> performRestore() async {
  throw UnsupportedError("Restore not supported on Web yet");
}
