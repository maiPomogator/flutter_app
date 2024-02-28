import 'package:sqflite/sqflite.dart';

class ScheduleList {
  late Database _database;

  ScheduleList._privateConstructor();

  static final ScheduleList _instance = ScheduleList._privateConstructor();

  static ScheduleList get instance => _instance;

  Future<void> initializeDatabase() async {
    final path = '${await getDatabasesPath()}schedule_list.db';
    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE schedule_list(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            schedule_id integer
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertList(int id, String type) async {
    Map<String, dynamic> data = {
      'schedule_id': id,
      'type': type,
    };
    return await _database.insert('schedule_list', data);
  }


  Future<List<Map<String, dynamic>>> getScheduleList() async {
    return await _database.query('schedule_list', columns: ['schedule_id', 'type']);
  }

  Future<int> deleteNote(int id, String type) async {
    return await _database.delete('schedule_list', where: 'schedule_id = ? and type=?', whereArgs: [id, type]);
  }
}
