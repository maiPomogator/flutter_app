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
    return Group(
      id: map['id'],
      name: map['name'],
      course: map['course'],
      faculty: map['faculty'],
      type: GroupType.fromString(map['type']),
    );
  }
}
