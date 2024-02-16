import '../model/Group.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/Professor.dart';

class ProfessorDatabase {
  static Database? _database;
  static const String tableName = 'professors';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'professor_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY,
        lastName TEXT,
        firstName TEXT,
        middleName TEXT,
        siteId TEXT,
        isMain BOOLEAN
      )
    ''');
  }

  Future<void> insertProfessor(Professor professor) async {
    final Database db = await database;
    await db.insert(tableName, professor.toMap());
  }

  Future<List<Professor>> getAllProfessors() async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Professor.fromMap(maps[i]);
    });
  }

  Future<Professor> getProfessorById(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Professor.fromMap(maps.first);
  }
}
