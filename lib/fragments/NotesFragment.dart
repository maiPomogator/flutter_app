import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class NotesFragment extends StatefulWidget {
  @override
  _NotesFragmentState createState() => _NotesFragmentState();
}

class _NotesFragmentState extends State<NotesFragment> {
  _NotesFragmentState() {
    initializeDateFormatting('ru', null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 46, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Заметки"),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 85, 16, 0),
            child: Image.asset('assets/notes/note_image.png'),
          ),
          Text('Заметок пока нет - можешь их создать'),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: GestureDetector(
                onTap: onCreatePressed,
                child: Container(
                  width: 335,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEF3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Создать',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  void onCreatePressed() {
    print('Кнопка "Создать" нажата');
  }
}
