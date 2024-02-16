import 'dart:ui';

import 'package:flutter_mobile_client/data/LessonsDatabase.dart';
import 'package:flutter_mobile_client/model/Lesson.dart';
import 'package:intl/intl.dart';

class Note {
  final int id;
  final DateTime targetTimestamp;
  final String title;
  final String text;
  final Color color;
  final bool isCompleted;
  final bool isImportant;
  final Lesson? lesson;

  const Note(this.id, this.targetTimestamp, this.title, this.text, this.color,
      this.isCompleted, this.isImportant, this.lesson);

  Map<String, dynamic> toMap({bool excludeId = false}) {
    final map = <String, dynamic>{
      'targetTimestamp': DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(targetTimestamp),
      'title': title,
      'text': text,
      'color': color.value,
      'isCompleted': isCompleted ? 1 : 0,
      'isImportant': isImportant ? 1 : 0,
      'lessonId': lesson?.id,
    };
    if (!excludeId) {
      map['id'] = id;
    }
    return map;
  }


  Future<Note> fromMap(Map<String, dynamic> map) async {
    LessonsDatabase ls = LessonsDatabase();
    return Note(
      map['id'],
      DateTime.parse(map['targetTimestamp']),
      map['title'],
      map['text'],
      Color(map['color']),
      map['isCompleted'] == 1 ? true : false,
      map['isImportant'] == 1 ? true : false,
      map.containsKey('lessonId') && map['lessonId'] != null
          ? await ls.getLessonById(map['lessonId'])
          : null,
    );
  }
}
