import 'dart:async';
import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/Lesson.dart';

class LessonsDatabase {
  static Database? _database;
  static const String tableName = 'lessons';

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'lessons.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY,
        name TEXT,
        types TEXT,
        date TEXT,
        timeStart TEXT,
        timeEnd TEXT,
        groups TEXT,
        professors TEXT,
        rooms TEXT,
        status TEXT
      )
    ''');
  }

  static Future<void> insertLesson(Lesson lesson) async {
    final Database db = await database;
    Map<String, dynamic> lessons = lesson.toMap();
    await db.insert(
      tableName,
      lessons,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Lesson>> getLessons() async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Lesson> lessons = [];
    for (var map in maps) {
      lessons.add(Lesson.fromMap(map));
    }

    return lessons;
  }

  static Future<void> deleteLesson(int id) async {
    final Database db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<Lesson?> getLessonById(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Lesson.fromLocalMap(maps.first);
  }

  static Future<List<Lesson>> getLessonsOnDate(
      DateTime date, String? selectedSchedule) async {
    final Database db = await database;
    String dateString = date.toIso8601String().substring(0, 10);

    List<String> parts = selectedSchedule!.split(" ");
    String idString = parts[0];
    int id = int.parse(idString);
    String type = parts[1];
    List<Map<String, dynamic>> maps = [];
    if (type == 'group') {
      String groupName = (await GroupDatabaseHelper.getGroupById(id)).name;
      maps = await db.query(
        tableName,
        where: 'date LIKE ? AND groups like ?',
        whereArgs: ['$dateString%', '%$groupName%'],
      );
    } else {
      String profName =
          '${(await ProfessorDatabase.getProfessorById(id)).lastName}';
      maps = await db.query(
        tableName,
        where: 'date LIKE ? AND professors like ?',
        whereArgs: ['$dateString%', '%$profName%'],
      );
    }

    List<Lesson> lessons = [];
    for (var map in maps) {
      lessons.add(Lesson.fromLocalMap(map));
    }

    lessons.sort((a, b) => a.timeStart.compareTo(b.timeStart));

    return lessons;
  }

  static Future<void> updateLesson(Lesson lesson) async {
    final Database db = await database;
    await db.update(
      tableName,
      lesson.toMap(),
      where: 'id = ?',
      whereArgs: [lesson.id],
    );
  }
}
