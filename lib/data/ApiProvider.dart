import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile_client/data/SheduleList.dart';
import 'package:flutter_mobile_client/model/Professor.dart';
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
      );
      String source = Utf8Decoder().convert(response.bodyBytes);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(source);
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
      );

      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        print(source);

        final List<dynamic> jsonData = jsonDecode(source);
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
        print('Failed to load data fetchGroupsByCourseAndFac: ${response.statusCode}');
        if (_attempted) {
          startFetchingPeriodically(fetchAllGroups);
        } else {
          _attempted = true;
        }
        return [];
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/groups?course=$course&faculty=$faculty');
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
      String source = Utf8Decoder().convert(response.bodyBytes);
      if (response.statusCode == 200) {
        final parsed = jsonDecode(source);
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
      final startDate = SeasonDates.getStartDate();
      final endDate = SeasonDates.getEndDate();

      final response = await http.get(Uri.parse(
          '$baseUrl/mai/groups/$id/lessons?startDate=$startDate&endDate=$endDate'));
      String source = Utf8Decoder().convert(response.bodyBytes);
      if (response.statusCode == 200) {
        final List<dynamic> lessonDataList = jsonDecode(source);
        for (final lessonData in lessonDataList) {
          lessons.add(Lesson.fromMap(lessonData));
        }
      } else {
        throw Exception(
            'Failed to load data fetchLessonByGroup: ${response.statusCode}');
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

  static Future<List<Lesson>> fetchAllSchedule() async {
    List<Lesson> lessons = [];
    final startDate = SeasonDates.getStartDate();
    final endDate = SeasonDates.getEndDate();
    try {
      final scheduleList = await ScheduleList.instance.getScheduleList();
      for (int i = 0; i < scheduleList.length; i++) {
        if (scheduleList[i]['type'] == 'group') {
          print('$baseUrl/mai/groups/${scheduleList[i]['schedule_id']}/lessons?startDate=$startDate&endDate=$endDate');

          final response = await http.get(Uri.parse(
              '$baseUrl/mai/groups/${scheduleList[i]['schedule_id']}/lessons?startDate=$startDate&endDate=$endDate'));
          String source = Utf8Decoder().convert(response.bodyBytes);
          if (response.statusCode == 200) {
            final List<dynamic> lessonDataList = jsonDecode(source);
            for (final lessonData in lessonDataList) {
              lessons.add(Lesson.fromMap(lessonData));
            }
          } else {
            throw Exception(
                'Failed to load data fetchLessonByGroup: ${response.statusCode}');
          }
        } else {
          print('$baseUrl/mai/professors/${scheduleList[i]['schedule_id']}/lessons?startDate=$startDate&endDate=$endDate');

          final response = await http.get(Uri.parse(
              '$baseUrl/mai/professors/${scheduleList[i]['schedule_id']}/lessons?startDate=$startDate&endDate=$endDate'));
          String source = Utf8Decoder().convert(response.bodyBytes);
          if (response.statusCode == 200) {
            final List<dynamic> lessonDataList = jsonDecode(source);
            for (final lessonData in lessonDataList) {
              lessons.add(Lesson.fromMap(lessonData));
            }
          } else {
            throw Exception(
                'Failed to load data fetchLessonByGroup: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      print(
          'Error occurred in fetchAllSchedule: $e address $baseUrl/mai/groups/lessons');
      if (_attempted) {
        startFetchingPeriodically(() => fetchAllSchedule());
      } else {
        _attempted = true;
      }
    }
    print('length of lessons ${lessons.length}');
    print(lessons.toString());
    return lessons;
  }

  static Future<List<Professor>> fetchProfessors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mai/professors'));
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        print(jsonDecode(source));
        final List<dynamic> jsonData = jsonDecode(source);
        final List<Professor> professors = jsonData.map((json) {
          return Professor(
            json['id'],
            json['lastName'],
            json['firstName'],
            json['middleName'],
            json['siteId'],
          );
        }).toList();
        _attempted = false;
        return professors;
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

  static Future<Professor> fetchProfessorById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mai/professors/$id'));
      String source = Utf8Decoder().convert(response.bodyBytes);
      if (response.statusCode == 200) {
        final parsed = jsonDecode(source);
        _attempted = false;
        return Professor.fromMap(parsed);
      } else {
        throw Exception(
            'Failed to load data groupById: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/professors/{$id}');
      if (_attempted) {
        startFetchingPeriodically(() => fetchProfessorById(id));
      } else {
        _attempted = true;
      }
      throw Exception('Error occurred while fetching group by id');
    }
  }

  static Future<List<Lesson>> fetchLessonByProfessor(int id) async {
    List<Lesson> lessons = [];
    final startDate = SeasonDates.getStartDate();
    final endDate = SeasonDates.getEndDate();
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/mai/professors/$id/lessons?startDate=$startDate&endDate=$endDate'));
      if (response.statusCode == 200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        final List<dynamic> lessonDataList = jsonDecode(source);
        for (final lessonData in lessonDataList) {
          lessons.add(Lesson.fromMap(lessonData));
        }
      } else {
        throw Exception(
            'Failed to load data fetchLessonByGroup: ${response.statusCode}');
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

  static void startFetchingPeriodically(Function() fetchFunction) {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchFunction();
    });
  }

  static void dispose() {
    _timer?.cancel();
  }
}

class SeasonDates {
  static String getSeason() {
    final now = DateTime.now();
    if (now.month >= 9 || now.month <= 1) {
      return 'fall_winter';
    } else {
      return 'spring_summer';
    }
  }

  static String getStartDate() {
    final season = getSeason();
    if (season == 'fall_winter') {
      return '${DateTime.now().year}-09-01';
    } else {
      return '${DateTime.now().year}-02-01';
    }
  }

  static String getEndDate() {
    final season = getSeason();
    if (season == 'fall_winter') {
      return '${DateTime.now().year + 1}-01-26';
    } else {
      return '${DateTime.now().year}-06-30';
    }
  }
}
