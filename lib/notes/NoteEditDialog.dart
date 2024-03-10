import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/data/NoteDatabase.dart';
import 'package:flutter_mobile_client/errors/ErrorDialog.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';

import '../model/Note.dart';

class NoteEditDialog extends StatefulWidget {
  final Note note;
  final DateTime currentDate;
  final Function() onUpdate;

  NoteEditDialog({required this.currentDate, required this.note, required this.onUpdate,});

  @override
  _NoteEditDialogState createState() => _NoteEditDialogState();
}

class _NoteEditDialogState extends State<NoteEditDialog> {
  Color selectedPriorityColor = Colors.transparent;
  bool _switchValue = true;
  TextEditingController _labelFieldController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Инициализация переменных при первом создании виджета
    _labelFieldController.text = widget.note.title;
    _textFieldController.text = widget.note.text;
    if (widget.note.color == Color(0xFFE9EEF3)) {
      selectedPriorityColor = Colors.transparent;
    } else {
      selectedPriorityColor = widget.note.color;
    }
    _switchValue = widget.note.isImportant;
  }
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
        title:
            Text('Редактирование заметки', style: AppTextStyle.headerTextStyle(context)),
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
                  isSelected: selectedPriorityColor == Color(0xfff44336),
                  onTap: () {
                    setState(() {
                      selectedPriorityColor = Color(0xfff44336);
                    });
                  },
                ),
                PriorityCircle(
                  icon: Icons.circle,
                  color: Colors.green,
                  isSelected: selectedPriorityColor == Color(0xff4caf50),
                  onTap: () {
                    setState(() {
                      selectedPriorityColor = Color(0xff4caf50);
                    });
                  },
                ),
                PriorityCircle(
                  icon: Icons.circle,
                  color: Colors.blue,
                  isSelected: selectedPriorityColor == Color(0xff2196f3),
                  onTap: () {
                    setState(() {
                      selectedPriorityColor = Color(0xff2196f3);
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
                child: Row(children: [
                  GestureDetector(
                    onTap: onSavePressed,
                    child: Container(
                      width: 165,
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
                  Spacer(),
                  GestureDetector(
                    onTap: onDeletePressed,
                    child: Container(
                      width: 165,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EEF3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Удалить',
                          style: AppTextStyle.headerTextStyle(context),
                        ),
                      ),
                    ),
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  void onSavePressed() async {
    print('Кнопка "Сохранить" нажата');
    await NoteDatabase.instance.deleteNote(widget.note.id);
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
          null);
      await NoteDatabase.instance.insertNote(newNote);
      Navigator.of(context).pop();
      widget.onUpdate();
    } else {
      ErrorDialog.showError(context, 'Проверьте данные',
          'Проверьте заполнение поля Заголовок или основного текста');
    }
  }

  void onDeletePressed() async {
    await NoteDatabase.instance.deleteNote(widget.note.id);
    Navigator.of(context).pop();
    widget.onUpdate();
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
