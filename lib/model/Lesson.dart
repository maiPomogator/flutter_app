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
    String typeNames = map['types'];
    typeNames = typeNames.replaceAll('[', '');
    typeNames = typeNames.replaceAll(']', '');
    List<String> list = typeNames.split(', ');
    List<LessonType> ls = [];
    for ( int i=0 ; i<list.length; i++){
     ls.add( LessonType.fromString(list[i]));
    }


    List<Group> groups = []; // Создаем пустой список, который будет заполняться объектами Group
    String groupString = map['groups'];
// Преобразуем строку JSON обратно в список объектов Group
    List<Map<String, dynamic>> groupMaps = parseStringToListOfMaps(groupString);
    for (Map<String, dynamic> map in groupMaps) {
      Group group = Group.fromMap(map); // Используем метод fromMap для создания объекта Group из Map
      groups.add(group); // Добавляем созданный объект Group в список
    }

    List<Professor> professors = []; // Создаем пустой список, который будет заполняться объектами Professor

// Преобразуем строку JSON обратно в список объектов Professor
    String professorString = map['professors'];
    List<Map<String, dynamic>> professorMaps = parseStringToListOfMaps(professorString);
    for (Map<String, dynamic> map in professorMaps) {
      Professor professor = Professor.fromMap(map); // Используем метод fromMap для создания объекта Professor из Map
      professors.add(professor); // Добавляем созданный объект Professor в список
    }

    final String roomsString = map['rooms'];
    List<String> rooms = roomsString.split(', ');

    final LessonStatus status = lessonStatusFromString(map['status']);

    return Lesson(
      int.parse(map['id'].toString()),
      map['name'].toString(),
      ls,
      DateTime.parse(map['date']),
      DateTime.parse(map['timeStart']),
      DateTime.parse(map['timeEnd']),
      groups,
      professors,
      rooms,
      status,
    );
  }

  static List<Map<String, dynamic>> parseStringToListOfMaps(String data) {
    // Удаление квадратных скобок
    data = data.replaceAll('[', '').replaceAll(']', '');

    // Разделение строки на объекты Map
    List<String> mapStrings = data.split('},{');

    // Создание списка для хранения объектов Map
    List<Map<String, dynamic>> mapsList = [];

    // Обработка каждого объекта Map в строке
    for (String mapString in mapStrings) {
      // Добавление фигурных скобок в начале и конце каждой строки, чтобы преобразовать ее в объект Map
      mapString = '{$mapString}';

      // Преобразование строки в объект Map и добавление его в список
      Map<String, dynamic> map = parseStringToMap(mapString);
      mapsList.add(map);
    }

    return mapsList;
  }

  static Map<String, dynamic> parseStringToMap(String data) {
    // Удаление ненужных символов
    data = data.replaceAll('{', '').replaceAll('}', '');

    // Разделение строки на пары ключ-значение
    List<String> pairs = data.split(', ');

    // Создание объекта Map и добавление пар ключ-значение
    Map<String, dynamic> map = {};
    for (String pair in pairs) {
      // Разделение каждой пары на ключ и значение
      List<String> keyValue = pair.split(': ');
      String key = keyValue[0].trim();
      dynamic value = keyValue[1].trim();

      // Обработка значений типа строка
      if (value.startsWith('Ð')) {
        value = value.replaceAll('Ð', '');
      }

      // Добавление пары ключ-значение в Map
      map[key] = value;
    }

    return map;
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
}
