import 'dart:ffi';

import 'package:flutter_mobile_client/model/LessonType.dart';

import '../data/GroupDatabaseHelper.dart';
import 'Group.dart';
import 'LessonStatus.dart';
import 'Professor.dart';

class Lesson {
  final Long id;
  final String name;
  final List<LessonType> types;
  final DateTime day;
  final DateTime timeStart;
  final DateTime timeEnd;
  final Set<Group> groups;
  final Set<Professor> professors;
  final List<String> rooms;
  final LessonStatus status;

  const Lesson(this.id, this.name, this.types, this.day, this.timeStart,
      this.timeEnd, this.groups, this.professors, this.rooms, this.status);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': types.toString(),
      'day': day,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'groups': groups.map((group) => group.id).toList().toString(),
      'professors': professors.map((professors) => professors.id).toList().toString(),
      'rooms': rooms.toString(),
      'status': status,
    };
  }

  static Future<Lesson> fromMap(Map<String, dynamic> map) async {
    return Lesson(
      map['id'],
      map['name'],
      typeFromString(map['type']),
      map['day'],
      map['timeStart'],
      map['timeEnd'],
      await groupsFromString(map['groups']),
      await professorsFromString(map['professors']),
      roomsFromString(map['rooms']),
      map['status'],
    );
  }

  static List<String> roomsFromString(String data) {
    data = data.replaceAll('[', '').replaceAll(']', '');
    List<String> roomsList = data.split(', ').map((String s) => s).toList();
    return roomsList;
  }

  static List<LessonType> typeFromString(String data) {
    data = data.replaceAll('[', '').replaceAll(']', '');
    List<LessonType> roomsList = data.split(', ').map((String s) => s).toList();
    return roomsList;
  }

  static Future<Set<Group>> groupsFromString(String data) async {
    GroupDatabaseHelper databaseHelper = GroupDatabaseHelper();
    data = data.replaceAll('[', '').replaceAll(']', '');
    List<int> groupIds = data.split(', ').map((String s) => int.parse(s)).toList();

    // Создаем список будущих объектов Group
    List<Future<Group>> futureGroups = groupIds.map((id) => databaseHelper.getGroupById(id)).toList();

    // Ожидаем завершения всех асинхронных операций
    List<Group> groupsList = await Future.wait(futureGroups);

    return groupsList.toSet();
  }


  static Future<Set<Group>> professorsFromString(String data) async {
    GroupDatabaseHelper databaseHelper = GroupDatabaseHelper();
    data = data.replaceAll('[', '').replaceAll(']', '');
    List<int> groupIds = data.split(', ').map((String s) => int.parse(s)).toList();

    // Создаем список будущих объектов Group
    List<Future<Group>> futureGroups = groupIds.map((id) => databaseHelper.getGroupById(id)).toList();

    // Ожидаем завершения всех асинхронных операций
    List<Group> groupsList = await Future.wait(futureGroups);

    return groupsList.toSet();
  }

}
