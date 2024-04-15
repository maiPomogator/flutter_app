import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/data/LessonsDatabase.dart';
import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
import 'package:flutter_mobile_client/errors/LoggerService.dart';
import 'package:flutter_mobile_client/model/Group.dart';
import 'package:flutter_mobile_client/model/Professor.dart';

import '../model/Lesson.dart';
import 'ApiProvider.dart';

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
      LoggerService.logError('Error occurred while populateGroupDatabaseFromServerById: $e');
    }
  }

  Future<void> populateLessonDatabaseFromServerByGroup(Group group) async {
    try {
      List<Lesson> lessons = await ApiProvider.fetchLessonByGroup(group.id);
      for (Lesson lesson in lessons) {
        await LessonsDatabase.insertLesson(lesson);
      }
    } catch (e, stackTrace) {
      LoggerService.logError('Error occurred while populating lesson database from server: $e');
      LoggerService.logError('Stack trace: $stackTrace');
    }
  }

  Future<void> populateAllLessonDatabase() async {
    try {
      List<Lesson> lessons = await ApiProvider.fetchAllSchedule();
      for (Lesson lesson in lessons) {
        await LessonsDatabase.insertLesson(lesson);
      }
    } catch (e, stackTrace) {
      LoggerService.logError('Error occurred while populating lesson database from server: $e');
      LoggerService.logError('Stack trace: $stackTrace');
    }
  }

  Future<void> populateProfessorDatabaseFromServerById(int id) async {
    try {
      Professor response = await ApiProvider.fetchProfessorById(id);
      populateLessonDatabaseFromServerByProfessor(response);
      ProfessorDatabase.insertProfessor(response);
    } catch (e) {
      LoggerService.logError('Error occurred while populateProfessorDatabaseFromServerById: $e');
    }
  }

  Future<void> populateLessonDatabaseFromServerByProfessor(
      Professor professor) async {
    try {
      List<Lesson> lessons =
          await ApiProvider.fetchLessonByProfessor(professor.id);
      for (Lesson lesson in lessons) {
        await LessonsDatabase.insertLesson(lesson);
      }
    } catch (e, stackTrace) {
      LoggerService.logError(
          'Error occurred while populateLessonDatabaseFromServerByProfessor: $e');
      LoggerService.logError('Stack trace: $stackTrace');
    }
  }
}
