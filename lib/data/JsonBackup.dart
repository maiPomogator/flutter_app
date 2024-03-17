import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/data/UserPreferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/Lesson.dart';
import '../model/Note.dart';
import 'LessonsDatabase.dart';
import 'NoteDatabase.dart';

class JsonBackup {
  static Future<void> generateJson() async {
    String filePath = '/storage/emulated/0/Download/notes_backup.json';
    try {
      List<Note> allNotes = await NoteDatabase.instance.getNotes();
      List<Map<String, dynamic>> notesJson =
          allNotes.map((note) => note.toMap()).toList();

      Map<String, dynamic> additionalInfo = {
        'otherValue': UserPreferences.getMainType(),
      };

      Map<String, dynamic> jsonData = {
        'notes': notesJson,
        'additionalInfo': additionalInfo,
      };

      String jsonContent = jsonEncode(jsonData);

      // Получение директории загрузок
      Directory? downloadsDirectory = await getExternalStorageDirectory();
      String downloadsPath = downloadsDirectory!.path;

      File file = File(filePath);

      // Проверка разрешения на запись файлов
      bool permissionStatus = await Permission.storage.isGranted;
      if (!permissionStatus) {
        // Если разрешение не предоставлено, запросите его и верните
        await Permission.storage.request();
        return;
      }

      await file.writeAsString(jsonContent);
    } catch (e) {
      print('Ошибка при сохранении JSON: $e');
    }
  }

  static Future<void> readJson() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        String filePath = result.files.single.path!;

        String fileContent = await File(filePath).readAsString();

        Map<String, dynamic> jsonData = jsonDecode(fileContent);

        List<Map<String, dynamic>> notesJson =
            List<Map<String, dynamic>>.from(jsonData['notes']);

        List<Note> notes = [];

        for (var map in notesJson) {
          Lesson? lesson;
          if (map['lessonId'] != null) {
            lesson = await LessonsDatabase.getLessonById(map['lessonId']);
          }
          notes.add(Note(
            map['id'],
            DateTime.parse(map['targetTimestamp']),
            map['title'],
            map['text'],
            Color(map['color']),
            map['isCompleted'] == 1 ? true : false,
            map['isImportant'] == 1 ? true : false,
            lesson,
          ));
        }
        for (var note in notes) {
          await NoteDatabase.instance.insertNote(note);
        }
        return;
      } else {
        return;
      }
    } catch (e) {
      print('Ошибка при чтении JSON: $e');
      return;
    }
  }
}
