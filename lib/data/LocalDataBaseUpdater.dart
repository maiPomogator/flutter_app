import 'dart:convert';

import 'package:flutter_mobile_client/model/Group.dart';

import 'ApiProvider.dart';
import 'SheduleList.dart';
import 'package:http/http.dart' as http;

class localDatabaseHelper {
  late ScheduleList _scheduleList;

  localDatabaseHelper._privateConstructor();

  static final localDatabaseHelper _instance = localDatabaseHelper._privateConstructor();

  static localDatabaseHelper get instance => _instance;

  Future<void> populateDatabaseFromServer() async {
    try {
      //List<Group> response = ApiProvider.fetchAllGroups();

    } catch (e) {
      print('Error occurred while populating database: $e');
    }
  }
}

//todo разобраться с логикой, она тут хромает