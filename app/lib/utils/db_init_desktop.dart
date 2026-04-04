import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Initialises the FFI-based SQLite engine for Windows/Linux/macOS.
void initDatabaseFactory() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}
