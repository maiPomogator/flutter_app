import 'dart:convert';

import 'ApiProvider.dart';
import 'SheduleList.dart';
import 'package:http/http.dart' as http;

class localDatabaseHelper {
  late ScheduleList _scheduleList;

  localDatabaseHelper._privateConstructor();

  static final localDatabaseHelper _instance = localDatabaseHelper._privateConstructor();

  static localDatabaseHelper get instance => _instance;

  Future<void> initializeDatabase() async {
    await _scheduleList.initializeDatabase();
  }

  Future<int> insertData(String table, Map<String, dynamic> data) async {
    return await _scheduleList.insertList(data['schedule_id'], data['type']);
  }

  Future<List<Map<String, dynamic>>> fetchData(String table) async {
    return await _scheduleList.getScheduleList();
  }

  // Method to populate local database from server
  Future<void> populateDatabaseFromServer() async {
    try {
      final response = await http.get(Uri.parse(ApiProvider.baseUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        for (var item in jsonData) {
          await _scheduleList.insertList(item['id'], item['type']);
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while populating database: $e');
    }
  }
}

//todo разобраться с логикой, она тут хромает