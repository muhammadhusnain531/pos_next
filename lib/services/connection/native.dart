// import 'dart:io';
// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'package:file_picker/file_picker.dart';

import 'package:drift/drift.dart';
// import 'package:drift/native.dart'; // This might be safe? No, native.dart uses dart:io internally usually.
// Actually drift/native.dart might be fine if not used.

QueryExecutor openConnection() {
  throw UnimplementedError();
  // return LazyDatabase(() async {
  //   final dbFolder = await getApplicationDocumentsDirectory();
  //   final file = File(p.join(dbFolder.path, 'pos_next.sqlite'));
  //   return NativeDatabase.createInBackground(file);
  // });
}

Future<void> performBackup() async {
  throw UnimplementedError();
}

Future<void> performRestore() async {
  throw UnimplementedError();
}
