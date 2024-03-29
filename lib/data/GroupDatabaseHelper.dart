import '../model/Group.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GroupDatabaseHelper {
  static Database? _database;
  static const String tableName = 'groups';

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'group_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY,
        name TEXT,
        course INTEGER,
        faculty INTEGER,
        type TEXT
      )
    ''');
  }

  static Future<void> insertGroup(Group group) async {
    final Database db = await database;
    await db.insert(tableName, group.toMap());
  }

  static Future<List<Group>> getAllGroups() async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Group.fromMap(maps[i]);
    });
  }

  static Future<Group> getGroupById(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Group.fromMap(maps.first);
  }
}
