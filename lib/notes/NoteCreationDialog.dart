import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/data/NoteDatabase.dart';
import 'package:flutter_mobile_client/errors/ErrorDialog.dart';
import 'package:flutter_mobile_client/model/Lesson.dart';
import 'package:flutter_mobile_client/model/NoteType.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';

import '../errors/LoggerService.dart';
import '../model/Note.dart';

class NoteCreationDialog extends StatefulWidget {
  final DateTime currentDate;
  final NoteType type;
  final Lesson? id;

  NoteCreationDialog({required this.currentDate, required this.type, this.id});

  @override
  _NoteCreationDialogState createState() => _NoteCreationDialogState();
}

class _NoteCreationDialogState extends State<NoteCreationDialog> {
  Color selectedPriorityColor = Colors.transparent;
  bool _switchValue = true;
  TextEditingController _labelFieldController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Создание заметки', style: AppTextStyle.headerTextStyle(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              height: 52,
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.start,
                controller: _labelFieldController,
                decoration: InputDecoration(
                  labelText: 'Заголовок',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              height: 120,
              child: TextField(
                maxLines: null,
                expands: true,
                controller: _textFieldController,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Введите текст',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Цвет', style: AppTextStyle.mainTextStyle(context)),
              ),
            ),
            Row(
              children: [
                PriorityCircle(
                  icon: Icons.block_outlined,
                  color: Color(0xFFD9D9D9),
                  isSelected: selectedPriorityColor == Colors.transparent,
                  onTap: () {
                    setState(() {
                      selectedPriorityColor = Colors.transparent;
                    });
                  },
                ),
                PriorityCircle(
                  icon: Icons.circle,
                  color: Colors.red,
                  isSelected: selectedPriorityColor == Colors.red,
                  onTap: () {
                    setState(() {
                      selectedPriorityColor = Colors.red;
                    });
                  },
                ),
                PriorityCircle(
                  icon: Icons.circle,
                  color: Colors.green,
                  isSelected: selectedPriorityColor == Colors.green,
                  onTap: () {
                    setState(() {
                      selectedPriorityColor = Colors.green;
                    });
                  },
                ),
                PriorityCircle(
                  icon: Icons.circle,
                  color: Colors.blue,
                  isSelected: selectedPriorityColor == Colors.blue,
                  onTap: () {
                    setState(() {
                      selectedPriorityColor = Colors.blue;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Row(
                children: [
                  Text(
                    'Важная заметка',
                    style: AppTextStyle.mainTextStyle(context),
                  ),
                  const Spacer(),
                  CupertinoSwitch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: onSavePressed,
                child: Container(
                  width: 335,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEF3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Сохранить',
                      style: AppTextStyle.headerTextStyle(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() async {
    LoggerService.logInfo('Кнопка "Сохранить" нажата');
    if (_labelFieldController.text.isNotEmpty &&
        _textFieldController.text.isNotEmpty) {
      Note newNote = Note(
          1,
          // Просто передаем целое число 1
          widget.currentDate,
          _labelFieldController.text,
          _textFieldController.text,
          selectedPriorityColor == Colors.transparent
              ? const Color(0xFFE9EEF3)
              : selectedPriorityColor,
          false,
          _switchValue,
          widget.type==NoteType.DAY?null:widget.id,);
      await NoteDatabase.instance.insertNote(newNote);
      Navigator.of(context).pop();
    } else {
      ErrorDialog.showError(context, 'Проверьте данные',
          'Проверьте заполнение поля Заголовок или основного текста');
    }
  }
}

class PriorityCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  PriorityCircle({
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 4, top: 3),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 40,
        ),
      ),
    );
  }
}
