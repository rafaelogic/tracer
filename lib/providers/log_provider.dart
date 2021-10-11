import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:tracer/models/log.dart';
import 'package:tracer/providers/sqlite_provider.dart';

class LogProvider {
  LogProvider._privateConstructor();
  static final LogProvider instance = LogProvider._privateConstructor();

  Future createLogsTable() async {
    var db = await SqliteProvider.instance.database;

    await db.execute(
        'CREATE TABLE IF NOT EXISTS logs(id INTEGER PRIMARY KEY AUTOINCREMENT, person_id INTEGER NOT NULL, date STRING NOT NULL)');
  }

  Future<Log> add(Log log) async {
    final db = await SqliteProvider.instance.database;

    await db.insert(
      'logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return log;
  }

  Future<List<Log>> logs() async {
    final db = await SqliteProvider.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('logs');

    return List.generate(maps.length, (i) {
      return Log(id: maps[i]['id'], personId: maps[i]['person_id'], date: maps[i]['date']);
    });
  }

  Future<int?> count() async {
    final db = await SqliteProvider.instance.database;
    var query = await db.rawQuery('SELECT COUNT (*) FROM logs');

    return Sqflite.firstIntValue(query);
  }

  Future<void> update(Log log) async {
    final db = await SqliteProvider.instance.database;

    await db.update(
      'logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await SqliteProvider.instance.database;

    await db.delete(
      'logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Log?> getById(int? id) async {
    if (id != null) {
      final db = await SqliteProvider.instance.database;

      var maps = await db.query('logs', where: 'id = ?', whereArgs: [id]);

      return maps.length > 0 ? Log.fromMap(maps.first) : null;
    }
  }

  Future<List<Log>> getAllLogsByPerson(int? personId) async {
    final db = await SqliteProvider.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('logs', where: 'person_id = ?', whereArgs: [personId]);

    return List.generate(maps.length, (i) {
      return Log(id: maps[i]['id'], personId: maps[i]['person_id'], date: maps[i]['date']);
    });
  }
}
