import 'dart:convert';

import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/model/Group.dart';

import 'ApiProvider.dart';
import 'SheduleList.dart';
import 'package:http/http.dart' as http;

class LocalDatabaseHelper {
  late ScheduleList _scheduleList;

  LocalDatabaseHelper._privateConstructor();

  static final LocalDatabaseHelper _instance =
  LocalDatabaseHelper._privateConstructor();

  static LocalDatabaseHelper get instance => _instance;

  Future<void> populateGroupDatabaseFromServerById(int id) async {
    try {
      Group response = await ApiProvider.fetchGroupById(id);
      GroupDatabaseHelper.insertGroup(response);
    } catch (e) {
      print('Error occurred while populating database: $e');
    }
  }
}

//todo разобраться с логикой, она тут хромает
