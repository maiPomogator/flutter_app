import 'dart:ui';

import '../model/Lesson.dart';
import '../model/Note.dart';
import 'package:sqflite/sqflite.dart';

import 'LessonsDatabase.dart';

class NoteDatabase {
  late Database _database;

  Future<Database> openNoteDatabase() async {
    final path = '${await getDatabasesPath()}notes_database.db';
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            targetTimestamp TEXT,
            title TEXT,
            text TEXT,
            color INTEGER,
            isCompleted INTEGER,
            lessonId INTEGER
          )
          ''',
        );
      },
      version: 1,
    );
  }



  Future<void> initializeDatabase() async {
    _database = await openNoteDatabase();
  }

  Future<int> insertNote(Note note) async {
    await openNoteDatabase();
    return await _database.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    LessonsDatabase database = LessonsDatabase();
    await openNoteDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('notes');
    return List.generate(maps.length, (i) {
      return Note(
         maps[i]['id'],
         DateTime.parse(maps[i]['targetTimestamp']),
         maps[i]['title'],
         maps[i]['text'],
         Color(maps[i]['color']),
         maps[i]['isCompleted'] == 1,
         database.getLessonById(maps[i]['lessonId']) as Lesson?,
      );
    });
  }

  Future<int> updateNote(Note note) async {
    await openNoteDatabase();
    return await _database.update('notes', note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    await openNoteDatabase();
    return await _database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}