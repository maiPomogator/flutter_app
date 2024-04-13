import 'package:sqflite/sqflite.dart';

class ScheduleList {
  late Database _database;
  Map<String, dynamic>? mainSchedule;

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
            schedule_id integer,
            isMain boolean
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertList(int id, String type, bool isMain) async {
    Map<String, dynamic> data = {
      'schedule_id': id,
      'type': type,
      'isMain': isMain
    };
    return await _database.insert('schedule_list', data);
  }

  Future<List<Map<String, dynamic>>> getScheduleList() async {
    return await _database
        .query('schedule_list', columns: ['schedule_id', 'type', 'isMain']);
  }

  Future<int> deleteList(int id, String type) async {
    return await _database.delete('schedule_list',
        where: 'schedule_id = ? and type=?', whereArgs: [id, type]);
  }

  Future<int> getCount() async {
    final List<Map<String, dynamic>> count =
        await _database.rawQuery('SELECT COUNT(*) FROM schedule_list');
    final int result = Sqflite.firstIntValue(count)!;
    return result;
  }

  Future<Map<String, dynamic>?> getMainScheduleIntoVar() async {
    List<Map<String, dynamic>> results = await _database.query(
      'schedule_list',
      columns: ['schedule_id', 'type', 'isMain'],
      where: 'isMain = ?',
      whereArgs: [1],
      limit: 1,
      orderBy: 'id DESC',
    );

    if (results.isNotEmpty) {
      mainSchedule = results.first;
      return results.first;
    } else {
      return null;
    }
  }
  Future<int> updateIsMainByScheduleId(int scheduleId, String type, bool isMain) async {
    return await _database.update(
      'schedule_list',
      {'isMain': isMain ? 1 : 0},
      where: 'schedule_id = ? and type=?',
      whereArgs: [scheduleId, type],
    );
  }


  Map<String, dynamic>? getMainSchedule() {
    return mainSchedule;
  }
}
