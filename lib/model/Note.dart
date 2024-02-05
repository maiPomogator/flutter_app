import 'dart:ffi';
import 'dart:ui';

import 'package:flutter_mobile_client/model/Lesson.dart';

class Note {
  final Long id;
  final DateTime targetTimestamp;
  final String title;
  final String text;
  final Color color;
  final bool isCompleted;
  final Lesson? lesson;

  const Note(this.id, this.targetTimestamp, this.title, this.text, this.color,
      this.isCompleted, this.lesson);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'targetTimestamp': targetTimestamp.toIso8601String(),
      'title': title,
      'text': text,
      'color': color,
      'isCompleted': isCompleted ? 1 : 0,
      'lessonId': lesson?.id,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      map['id'],
      DateTime.parse(map['targetTimestamp']),
      map['title'],
      map['text'],
      map['color'],
      map['isCompleted'] == 1,
      Lesson(id: map['lessonId']),
    );
  }
}
