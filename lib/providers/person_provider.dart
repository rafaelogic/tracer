import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:tracer/models/person.dart';
import 'package:tracer/providers/sqlite_provider.dart';

class PersonProvider {
  PersonProvider._privateConstructor();
  static final PersonProvider instance = PersonProvider._privateConstructor();

//ADD TABLE FOR LOGS.
  Future createPersonsTable() async {
    var db = await SqliteProvider.instance.database;

    await db.execute(
        'CREATE TABLE IF NOT EXISTS persons(id INTEGER PRIMARY KEY AUTOINCREMENT, first_name TEXT, last_name TEXT, mobile_number INTEGER, address TEXT)');
  }

  Future<Person> add(Person person) async {
    final db = await SqliteProvider.instance.database;

    await db.insert(
      'persons',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return person;
  }

  Future<List<Person>> persons() async {
    final db = await SqliteProvider.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('persons');

    return List.generate(maps.length, (i) {
      return Person(
          id: maps[i]['id'],
          firstName: maps[i]['first_name'],
          lastName: maps[i]['last_name'],
          mobileNumber: maps[i]['mobile_number'],
          address: maps[i]['address']);
    });
  }

  Future<int?> count() async {
    final db = await SqliteProvider.instance.database;
    var query = await db.rawQuery('SELECT COUNT (*) FROM persons');

    return Sqflite.firstIntValue(query);
  }

  Future<void> update(Person person) async {
    final db = await SqliteProvider.instance.database;

    await db.update(
      'persons',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await SqliteProvider.instance.database;

    await db.delete(
      'persons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Person?> getById(int? id) async {
    if (id != null) {
      final db = await SqliteProvider.instance.database;

      var maps = await db.query('persons', where: 'id = ?', whereArgs: [id]);

      return maps.length > 0 ? Person.fromMap(maps.first) : null;
    }
  }

  Future<Person?> getByName(firstName, lastName) async {
    final db = await SqliteProvider.instance.database;

    var maps = await db.query('persons', where: "first_name = ? AND last_name = ?", whereArgs: [firstName, lastName]);

    return maps.isEmpty ? null : Person.fromMap(maps.first);
  }
}
