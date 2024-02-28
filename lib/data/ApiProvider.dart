import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  static String baseUrl = dotenv.env['ADDRESS'] ?? '';
  static Timer? _timer;
  static bool _attempted = false;

  static void fetchAllGroups() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mai/groups'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        _attempted = false;
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
    }
  }

  static void fetchGroupById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mai/groups/{$id}'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        _attempted = false;
      } else {
        throw Exception(
            'Failed to load data groupById: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/groups/{$id}');
      if (_attempted) {
        startFetchingPeriodically(() => fetchGroupById(id));
      } else {
        _attempted = true;
      }
    }
  }

  static void fetchLessonByGroup(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/mai/groups/{$id}/lessons'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        _attempted = false;
      } else {
        throw Exception(
            'Failed to load data fetchLessonByGroup: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e address $baseUrl/mai/groups/{$id}/lessons');
      if (_attempted) {
        startFetchingPeriodically(() => fetchLessonByGroup(id));
      } else {
        _attempted = true;
      }
    }
  }

  static void fetchProfessors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/mai/professors'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
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
        print(jsonDecode(response.body));
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
        print(jsonDecode(response.body));
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
