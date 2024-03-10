import 'dart:convert';

import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
import 'package:flutter_mobile_client/model/LessonType.dart';
import 'package:intl/intl.dart';

import '../data/GroupDatabaseHelper.dart';
import 'Group.dart';
import 'GroupType.dart';
import 'LessonStatus.dart';
import 'Professor.dart';

class Lesson {
  final int id;
  final String name;
  final List<LessonType> types;
  final DateTime date;
  final DateTime timeStart;
  final DateTime timeEnd;
  final List<Group> groups;
  final List<Professor> professors;
  final List<String> rooms;
  final LessonStatus status;

  const Lesson(this.id, this.name, this.types, this.date, this.timeStart,
      this.timeEnd, this.groups, this.professors, this.rooms, this.status);

  Map<String, dynamic> toMap() {
    return {
      'id': int.parse(id.toString()),
      'name': name.toString(),
      'types': types.map((type) => type.name).toList().toString(),
      'date': date.toIso8601String(),
      'timeStart': timeStart.toIso8601String(),
      'timeEnd': timeEnd.toIso8601String(),
      'groups': groups.map((group) => group.toMap()).toList().toString(),
      'professors':
          professors.map((professor) => professor.toMap()).toList().toString(),
      'rooms': rooms.toString(),
      'status': status.toString(),
    };
  }

 static Lesson fromLocalMap(Map<String, dynamic> map) {
    final List<String> typeNames = json.decode(map['types']).cast<String>();

    final List<LessonType> lessonTypes =
        typeNames.map((typeName) => LessonType.fromString(typeName)).toList(); //todo убрать квадратные скобки

    final List<Map<String, dynamic>> groupMaps =
        json.decode(map['groups']).cast<Map<String, dynamic>>();

    final List<Group> groups =
        groupMaps.map((groupMap) => Group.fromMap(groupMap)).toList();

    final List<Map<String, dynamic>> professorMaps =
        json.decode(map['professors']).cast<Map<String, dynamic>>();

    final List<Professor> professors = professorMaps
        .map((professorMap) => Professor.fromMap(professorMap))
        .toList();

    final List<String> rooms =
        map['rooms'].substring(1, map['rooms'].length - 1).split(', ');

    final LessonStatus status = lessonStatusFromString(map['status']);

    return Lesson(
      int.parse(map['id'].toString()),
      map['name'].toString(),
      lessonTypes,
      DateTime.parse(map['date']),
      DateTime.parse(map['timeStart']),
      DateTime.parse(map['timeEnd']),
      groups,
      professors,
      rooms,
      status,
    );
  }

  String statusToString(LessonStatus status) {
    switch (status) {
      case LessonStatus.CREATED:
        return 'CREATED';
      case LessonStatus.SAVED:
        return 'SAVED';
      case LessonStatus.CANCELLED:
        return 'CANCELLED';
      default:
        throw ArgumentError("Unknown LessonStatus: $status");
    }
  }

  String typesToString(List<LessonType> types) {
    return types.map((type) => type.toString()).join(', ');
  }

  static List<LessonType> typesFromString(List<dynamic> data) {
    List<LessonType> lessonTypes = [];
    for (var typeName in data) {
      switch (typeName) {
        case "Лекция":
          lessonTypes.add(LessonType.LECTURE);
          break;
        case "Практическое занятие":
          lessonTypes.add(LessonType.PRACTICE);
          break;
        case "Лабораторная работа":
          lessonTypes.add(LessonType.LABORATORY);
          break;
        case "Консультация":
          lessonTypes.add(LessonType.CONSULTATION);
          break;
        case "Зачёт":
          lessonTypes.add(LessonType.CREDIT);
          break;
        case "Экзамен":
          lessonTypes.add(LessonType.EXAM);
          break;
        default:
          break;
      }
    }
    return lessonTypes;
  }

  static List<Group> groupsFromList(List<dynamic> groupsData) {
    List<Group> groupsList = [];
    for (var groupData in groupsData) {
      groupsList.add(Group(
        id: groupData['id'],
        name: groupData['name'],
        course: groupData['course'],
        faculty: groupData['faculty'],
        type: GroupType.fromString(groupData['type']),
      ));
    }
    return groupsList;
  }

  static List<Professor> professorsFromList(List<dynamic> professorsData) {
    List<Professor> professorsList = [];
    for (var professorData in professorsData) {
      professorsList.add(Professor(
        professorData['id'],
        professorData['lastName'],
        professorData['firstName'],
        professorData['middleName'],
        professorData['siteId'],
      ));
    }
    return professorsList;
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    List<LessonType> types = [];
    for (var type in map['types']) {
      types.add(LessonType.fromString(type));
    }

    List<Group> groups = [];
    for (var group in map['groups']) {
      groups.add(Group.fromMap(group));
    }

    List<Professor> professors = [];
    for (var professor in map['professors']) {
      professors.add(Professor.fromMap(professor));
    }

    LessonStatus status;
    switch (map['status']) {
      case 'CREATED':
        status = LessonStatus.CREATED;
        break;
      case 'SAVED':
        status = LessonStatus.SAVED;
        break;
      case 'CANCELLED':
        status = LessonStatus.CANCELLED;
        break;
      default:
        status = LessonStatus.SAVED;
        break;
    }
    String startTimeString = map['timeStart'];
    String dateString = "2024-03-10";
    String combinedStartDateTimeString = "$dateString $startTimeString";

    String endTimeString = map['timeStart'];
    String combinedEndDateTimeString = "$dateString $endTimeString";

    return Lesson(
      map['id'],
      map['name'],
      types,
      DateTime.parse(map['date']),
      DateTime.parse(combinedStartDateTimeString),
      DateTime.parse(combinedEndDateTimeString),
      groups,
      professors,
      List<String>.from(map['rooms']),
      status,
    );
  }

  static LessonStatus statusFromString(String status) {
    switch (status) {
      case "CREATED":
        return LessonStatus.CREATED;
      case "SAVED":
        return LessonStatus.SAVED;
      case "CANCELLED":
        return LessonStatus.CANCELLED;
      default:
        throw ArgumentError("Unknown LessonStatus: $status");
    }
  }

  static List<String> roomsFromString(String data) {
    data = data.replaceAll('[', '').replaceAll(']', '');
    List<String> roomsList = data.split(', ').map((String s) => s).toList();
    return roomsList;
  }

  static List<LessonType> typeFromString(String data) {
    data = data.replaceAll('[', '').replaceAll(']', '');
    List<String> typeNames = data.split(', ');
    List<LessonType> lessonTypes = [];
    for (var typeName in typeNames) {
      switch (typeName) {
        case "Лекция":
          lessonTypes.add(LessonType.LECTURE);
          break;
        case "Практическое занятие":
          lessonTypes.add(LessonType.PRACTICE);
          break;
        case "Лабораторная работа":
          lessonTypes.add(LessonType.LABORATORY);
          break;
        case "Консультация":
          lessonTypes.add(LessonType.CONSULTATION);
          break;
        case "Зачёт":
          lessonTypes.add(LessonType.CREDIT);
          break;
        case "Экзамен":
          lessonTypes.add(LessonType.EXAM);
          break;
        default:
          break;
      }
    }
    return lessonTypes;
  }

  static Future<Set<Group>> groupsFromString(String data) async {
    data = data.replaceAll('[', '').replaceAll(']', '');
    List<int> groupIds =
        data.split(', ').map((String s) => int.parse(s)).toList();

    List<Future<Group>> futureGroups =
        groupIds.map((id) => GroupDatabaseHelper.getGroupById(id)).toList();

    List<Group> groupsList = await Future.wait(futureGroups);

    return groupsList.toSet();
  }

  static Future<Set<Professor>> professorsFromString(String data) async {
    data = data.replaceAll('[', '').replaceAll(']', '');
    List<int> groupIds =
        data.split(', ').map((String s) => int.parse(s)).toList();

    List<Future<Professor>> futureGroups =
        groupIds.map((id) => ProfessorDatabase.getProfessorById(id)).toList();

    List<Professor> groupsList = await Future.wait(futureGroups);

    return groupsList.toSet();
  }

  static DateTime parseTime(String timeString) {
    final format = DateFormat('HH:mm:ss');
    return format.parse(timeString);
  }
}
