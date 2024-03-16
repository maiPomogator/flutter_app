import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/data/LessonsDatabase.dart';
import 'package:flutter_mobile_client/model/Group.dart';

import '../model/Lesson.dart';
import 'ApiProvider.dart';
import 'package:http/http.dart' as http;

class LocalDatabaseHelper {

  LocalDatabaseHelper._privateConstructor();

  static final LocalDatabaseHelper _instance =
      LocalDatabaseHelper._privateConstructor();

  static LocalDatabaseHelper get instance => _instance;

  Future<void> populateGroupDatabaseFromServerById(int id) async {
    try {
      Group response = await ApiProvider.fetchGroupById(id);
      populateLessonDatabaseFromServerByGroup(response);
      GroupDatabaseHelper.insertGroup(response);
    } catch (e) {
      print('Error occurred while populateGroupDatabaseFromServerById: $e');
    }
  }

  Future<void> populateLessonDatabaseFromServerByGroup(Group group) async {
    try {
      List<Lesson> lessons = await ApiProvider.fetchLessonByGroup(group.id);
      for (Lesson lesson in lessons) {
        await LessonsDatabase.insertLesson(lesson);
      }
    } catch (e, stackTrace) {
      print('Error occurred while populating lesson database from server: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> populateAllLessonDatabase() async {
    try {
      List<Lesson> lessons = await ApiProvider.fetchAllSchedule();
      for (Lesson lesson in lessons) {
        await LessonsDatabase.insertLesson(lesson);
      }
    } catch (e, stackTrace) {
      print('Error occurred while populating lesson database from server: $e');
      print('Stack trace: $stackTrace');
    }
  }


}

//todo разобраться с логикой, она тут хромает
