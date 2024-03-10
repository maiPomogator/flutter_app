import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/Group.dart';
import '../model/GroupType.dart';
import '../model/Lesson.dart';

class ApiProvider {
  static String baseUrl = dotenv.env['ADDRESS'] ?? '';
  static Timer? _timer;
  static bool _attempted = false;

  static Future<List<Group>> fetchAllGroups() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mai/groups'),
        headers: {
          "Accept-Charset": "utf-8",
          "Content-Type": "application/json; charset=utf-8"
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Group> groups = jsonData.map((json) {
          return Group(
            id: json['id'],
            name: json['name'],
            course: json['course'],
            faculty: json['faculty'],
            type: GroupType.fromString(json['type']),
          );
        }).toList();
        _attempted = false;
        return groups;
      } else {
        throw Exception(
            'Failed to load data fetchAllGroups: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/groups');
      if (_attempted) {
        startFetchingPeriodically(fetchAllGroups);
      } else {
        _attempted = true;
      }
      return [];
    }
  }

  static Future<List<Group>> fetchGroupsByCourseAndFac(
      String course, String faculty) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mai/groups?course=$course&faculty=$faculty'),
        headers: {
          "Accept-Charset": "utf-8",
          "Content-Type": "application/json; charset=utf-8"
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Group> groups = jsonData.map((json) {
          return Group(
            id: json['id'],
            name: json['name'],
            course: json['course'],
            faculty: json['faculty'],
            type: GroupType.fromString(json['type']),
          );
        }).toList();
        _attempted = false;
        return groups;
      } else {
        throw Exception(
            'Failed to load data fetchGroupsByCourseAndFac: ${response.statusCode}');
      }
    } catch (e) {
      print(
          'Error occurred: $e address $baseUrl/mai/groups?course=$course&faculty=$faculty');
      if (_attempted) {
        startFetchingPeriodically(fetchAllGroups);
      } else {
        _attempted = true;
      }
      return [];
    }
  }

  static Future<Group> fetchGroupById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mai/groups/$id'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        _attempted = false;
        return Group.fromMap(parsed);
      } else {
        throw Exception(
            'Failed to load data groupById: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/groups/$id');
      if (_attempted) {
        startFetchingPeriodically(() => fetchGroupById(id));
      } else {
        _attempted = true;
      }
      throw Exception('Error occurred while fetching group by id');
    }
  }

  static Future<List<Lesson>> fetchLessonByGroup(int id) async {
    List<Lesson> lessons = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/mai/groups/$id/lessons'));
      if (response.statusCode == 200) {
        final List<dynamic> lessonDataList = jsonDecode(response.body);
        for (final lessonData in lessonDataList) {
          lessons.add(Lesson.fromMap(lessonData));
        }
      } else {
        throw Exception('Failed to load data fetchLessonByGroup: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/groups/$id/lessons');
      if (_attempted) {
        startFetchingPeriodically(() => fetchLessonByGroup(id));
      } else {
        _attempted = true;
      }
    }
    print('length of lessons ${lessons.length}');
    print(lessons.toString());
    return lessons;
  }



  static void fetchProfessors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mai/professors'));
      if (response.statusCode == 200) {
        print(jsonDecode(response
            .body)); //todo здесь на list переделать после запуска сервера
        _attempted = false;
      } else {
        throw Exception(
            'Failed to load data fetchProfessors: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/professors');
      if (_attempted) {
        startFetchingPeriodically(() => fetchProfessors());
      } else {
        _attempted = true;
      }
    }
  }

  static void fetchProfessorById(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/mai/professors/{$id}'));
      if (response.statusCode == 200) {
        print(jsonDecode(response
            .body)); //todo здесь на list переделать после запуска сервера
        _attempted = false;
      } else {
        throw Exception(
            'Failed to load data fetchProfessorById: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/professors/{$id}');
      if (_attempted) {
        startFetchingPeriodically(() => fetchProfessorById(id));
      } else {
        _attempted = true;
      }
    }
  }

  static void fetchLessonByProfessor(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/mai/professors/{$id}/lessons'));
      if (response.statusCode == 200) {
        print(jsonDecode(response
            .body)); //todo здесь на list переделать после запуска сервера
        _attempted = false;
      } else {
        throw Exception(
            'Failed to load data fetchLessonByProfessor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/professors/{$id}/lessons');
      if (_attempted) {
        startFetchingPeriodically(() => fetchLessonByProfessor(id));
      } else {
        _attempted = true;
      }
    }
  }

  static void startFetchingPeriodically(Function() fetchFunction) {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchFunction();
    });
  }

  static void dispose() {
    _timer?.cancel();
  }
}
