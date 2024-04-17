import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../errors/LoggerService.dart';
import '../model/Lesson.dart';
import '../model/Note.dart';
import 'LessonsDatabase.dart';
import 'NoteDatabase.dart';

class JsonBackup {

  static Future<void> generateJson(BuildContext context) async {

    String? downloadPath = (await getExternalStorageDirectories(type: StorageDirectory.downloads))?.first.path;
    String formattedDate = DateFormat('dd_MM_yy_HH:mm').format(DateTime.now());
    if (downloadPath!=null) {
      String filePath = "$downloadPath/notes_backup_$formattedDate.json";
      try {
        List<Note> allNotes = await NoteDatabase.instance.getNotes();
        List<Map<String, dynamic>> notesJson =
        allNotes.map((note) => note.toMap()).toList();

        Map<String, dynamic> additionalInfo = {
        //  'theme': UserPreferences.getMainType(),
        };

        Map<String, dynamic> jsonData = {
          'notes': notesJson,
          'additionalInfo': additionalInfo,
        };

        String jsonContent = jsonEncode(jsonData);

        File file = File(filePath);

        // Проверка разрешения на запись файлов
        bool permissionStatus = await Permission.storage.isGranted;
        if (!permissionStatus) {
          await Permission.storage.request();
          return;
        }

        await file.writeAsString(jsonContent);
        final snackBar = SnackBar(
          content: Text('Файл сохранен в $downloadPath/notes_backup_$formattedDate.json'),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        LoggerService.logError('Ошибка при сохранении JSON: $e');
      }
    } else {

    }
  }

  static Future<void> readJson(BuildContext context) async {
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
        const snackBar = SnackBar(
          content: Text('Данные успешно добавлены'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      } else {
        return;
      }
    } catch (e) {
      LoggerService.logError('Ошибка при чтении JSON: $e');
      return;
    }
  }
}
