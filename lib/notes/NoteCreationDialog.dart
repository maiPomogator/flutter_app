import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';

class NoteCreationDialog extends StatefulWidget {
  @override
  _NoteCreationDialogState createState() => _NoteCreationDialogState();
}

class _NoteCreationDialogState extends State<NoteCreationDialog> {
  Color selectedPriorityColor = Colors.transparent;
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24),
          // Здесь устанавливаем размер иконки
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Создание заметки', style: AppTextStyle.headerTextStyle),
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
                child: Text('Цвет', style: AppTextStyle.mainTextStyle),
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
                    style: AppTextStyle.mainTextStyle,
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
                        style: AppTextStyle.headerTextStyle,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() {
    print('Кнопка "Сохранить" нажата');
    setState(() {
      // Обработка нажатия кнопки "Сохранить"
    });
    Navigator.of(context).pop();
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
