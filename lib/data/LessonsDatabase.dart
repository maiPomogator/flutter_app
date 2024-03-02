import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/Lesson.dart';

class LessonsDatabase {
  Database? _database;

  Future<void> _openDatabase() async {
    if (_database != null) return;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'lessons.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE lessons(
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT,
            day TEXT,
            timeStart TEXT,
            timeEnd TEXT,
            groups TEXT,
            professors TEXT,
            rooms TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertLesson(Lesson lesson) async {
    await _openDatabase();
    await _database!.insert(
      'lessons',
      lesson.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Lesson>> getLessons() async {
    await _openDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query('lessons');
    List<Lesson> lessons = [];
    for (var map in maps) {
      lessons.add(await Lesson.fromMap(map));
    }

    return lessons;
  }

  Future<void> deleteLesson(int id) async {
    await _openDatabase();
    await _database!.delete(
      'lessons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Lesson?> getLessonById(int id) async {
    await _openDatabase();
    List<Map<String, dynamic>> maps = await _database!.query(
      'lessons',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Lesson.fromMap(maps.first);
  }
}
