import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';

class SqliteProvider {
  SqliteProvider._privateConstructor();
  static final SqliteProvider instance = SqliteProvider._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'tracer_snces.db');

    return await openDatabase(path, version: 1);
  }

  Future countTable() async {
    var client = await database;

    var res = await client.rawQuery("""
    SELECT count(*) as count FROM sqlite_master
    WHERE type = 'table'
    AND name != 'android_metadata'
    AND name != 'sqlite_sequence';
    """);

    return res[0]['count'];
  }
}
