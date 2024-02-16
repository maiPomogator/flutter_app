import 'dart:async';
import 'package:flutter_mobile_client/model/LessonType.dart';
import 'package:flutter_mobile_client/model/Professor.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

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
  /*Lesson getLessonByDay(DateTime date){
    List<LessonType> lessonType = [LessonType.LECTURE];
    var uuid = Uuid();
    String randomUuid = uuid.v4();
    Professor professor = Professor(1, 'Коновалов', 'Кирилл', 'Андреевич',uuid , false);

    return Lesson(1, 'Информационная безопасность', lessonType, day, timeStart, timeEnd, groups, professor, rooms, status)
  }*/
}



