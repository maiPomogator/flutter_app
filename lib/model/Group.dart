import 'package:flutter_mobile_client/errors/LoggerService.dart';
import 'package:flutter_mobile_client/model/GroupType.dart';

class Group {
  final int id;
  final String name;
  final int course;
  final int faculty;
  final GroupType type;

  Group({
    required this.id,
    required this.name,
    required this.course,
    required this.faculty,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'faculty': faculty,
      'type': type.toString(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    GroupType? type;
    try {
      type = GroupType.fromString(map['type']);

      Group group = Group(
        id: int.parse(map['id'].toString()),
        name: map['name'],
        course: int.parse(map['course'].toString()),
        faculty: int.parse(map['faculty'].toString()),
        type: type,
      );

      return group;
    } catch (e) {
      LoggerService.logError('Ошибка при парсинге типа группы: $e');
      throw Exception('Ошибка при создании группы из карты: $e');
    }
  }




}
