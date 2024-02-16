import 'dart:ui';

import '../model/Lesson.dart';
import '../model/Note.dart';
import 'package:sqflite/sqflite.dart';

import 'LessonsDatabase.dart';

class NoteDatabase {
  late Database _database;

  // Приватный конструктор
  NoteDatabase._privateConstructor();

  // Единственный экземпляр класса NoteDatabase
  static final NoteDatabase _instance = NoteDatabase._privateConstructor();

  // Публичный статический метод, чтобы получить экземпляр класса NoteDatabase
  static NoteDatabase get instance => _instance;

  // Метод инициализации базы данных
  Future<void> initializeDatabase() async {
    final path = '${await getDatabasesPath()}notes_database.db';
    _database = await openDatabase(
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
            isImportant INTEGER,
            lessonId INTEGER
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertNote(Note note) async {
    return await _database.insert('notes', note.toMap(excludeId: true));
  }


  Future<List<Note>> getNotes() async {
    final List<Map<String, dynamic>> maps = await _database.query('notes');
    List<Note> notes = [];
    for (var map in maps) {
      Lesson? lesson;
      if (map['lessonId'] != null) {
        lesson = await LessonsDatabase().getLessonById(map['lessonId']);
      }
      notes.add(Note(
        map['id'],
        DateTime.parse(map['targetTimestamp']),
        map['title'],
        map['text'],
        Color(map['color']),
        map['isCompleted'] == 1 ? true : false,
        map['isImportant'] == 1 ? true : false,
        lesson,
      ));
    }
    return notes;
  }


  Future<int> updateNote(Note note) async {
    return await _database
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    return await _database.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> getNotesWithLessonId() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'notes',
      where: 'lessonId IS NOT NULL',
    );
    return _extractNotesFromMapList(maps);
  }

  Future<List<Note>> getNotesWithoutLessonId() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'notes',
      where: 'lessonId IS NULL',
    );
    return _extractNotesFromMapList(maps);
  }

  Future<List<Note>> _extractNotesFromMapList(List<Map<String, dynamic>> maps) async {
    List<Note> notes = [];
    for (var map in maps) {
      final Lesson? lesson = await _getLessonById(map['lessonId']);
      notes.add(Note(
        map['id'],
        DateTime.parse(map['targetTimestamp']),
        map['title'],
        map['text'],
        Color(map['color']),
        map['isCompleted'] == 1 ? true : false,
        map['isImportant'] == 1 ? true : false,
        lesson,
      ));
    }
    return notes;
  }

  Future<Lesson?> _getLessonById(int? lessonId) async {
    if (lessonId != null) {
      return await LessonsDatabase().getLessonById(lessonId);
    }
    return null;
  }
  Future<List<Note>> getNotesByDate(DateTime date) async {
    final formattedDate = date.toIso8601String().substring(0, 10);
    final List<Map<String, dynamic>> maps = await _database.query(
      'notes',
      where: 'substr(targetTimestamp, 1, 10) = ?',
      whereArgs: [formattedDate],
    );
    return _extractNotesFromMapList(maps);
  }

}
