import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnection() {
  return WebDatabase('pos_next_db');
}

Future<void> performBackup() async {
  throw UnsupportedError("Backup not supported on Web yet");
}

Future<void> performRestore() async {
  throw UnsupportedError("Restore not supported on Web yet");
}
