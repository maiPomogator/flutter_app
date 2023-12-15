import 'dart:ffi';

import 'package:flutter_mobile_client/model/LessonType.dart';

import 'Group.dart';
import 'LessonStatus.dart';
import 'Professor.dart';

class Lesson{
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



  const Lesson(this.id, this.name, this.types, this.day, this.timeStart, this.timeEnd,
      this.groups, this.professors, this.rooms, this.status);
}