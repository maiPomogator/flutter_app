import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/data/NoteDatabase.dart';
import 'package:flutter_mobile_client/model/NoteType.dart';
import 'package:flutter_mobile_client/notes/NoteEditDialog.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../model/Note.dart';
import '../notes/NoteCreationDialog.dart';
import '../widgets/DayButton.dart';
import 'ScheduleFragment.dart';

class NotesFragment extends StatefulWidget {
  final double fem;

  NotesFragment({required this.fem});

  @override
  _NotesFragmentState createState() => _NotesFragmentState(fem: fem);
}

class _NotesFragmentState extends State<NotesFragment> {
  late double fem;

  _NotesFragmentState({required this.fem}) {
    initializeDateFormatting('ru', null);
  }

  late NoteDatabase noteDatabase;
  NoteType selectedType = NoteType.DAY;
  DateTime _selectedDate = DateTime.now();
  late DateTime currentDate;
  late DateTime monday;
  late List<DateTime> weekDates;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    monday = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    weekDates = List.generate(7, (index) => monday.add(Duration(days: index)));
    noteDatabase = NoteDatabase.instance;
    noteDatabase.initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {

    const buttonWidth = 30.0;
    double totalSpacing =
        MediaQuery.of(context).size.width - (weekDates.length * buttonWidth);
    double spacing = totalSpacing / (weekDates.length + 2);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (DragEndDetails details) {
      double dx = details.primaryVelocity ?? 0;
      double sensitivity = 1.0;

      if (dx > sensitivity) {
        _updateSelectedDate(_selectedDate.subtract(Duration(days: 1)));
      } else if (dx < -sensitivity) {
        _updateSelectedDate(_selectedDate.add(Duration(days: 1)));
      }
    },
    child:Padding(
      padding: const EdgeInsets.fromLTRB(16, 46, 16, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Заметки",
            style: AppTextStyle.headerTextStyle,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = NoteType.DAY;
                    });
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedType == NoteType.DAY
                              ? Color(0xFF143349)
                              : Color(0x00000000),
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'На день',
                        style: TextStyle(
                          color: selectedType == NoteType.DAY
                              ? Color(0xff1D1B20)
                              : Color(0xff3C3C43),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = NoteType.LESSON;
                    });
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedType == NoteType.LESSON
                              ? Color(0xFF143349)
                              : Color(0x00000000),
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'На пару',
                        style: TextStyle(
                          color: selectedType == NoteType.LESSON
                              ? Color(0xff1D1B20)
                              : Color(0xff3C3C43),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 35,
            child: Row(
              children: [
                Text(
                  DateFormat('d MMMM', 'ru').format(currentDate),
                  style: AppTextStyle.secondTextStyle,
                ),
                const Spacer(),
                selectedType == NoteType.LESSON ?
                 Container(width: 24)   :
                IconButton(
                  onPressed: () {
                    onCreatePressed();
                  },
                  icon: ImageIcon(
                    AssetImage('assets/navigation/note_icon.png'),
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_month,
                      color: Color(0xFF2C4A60), size: 24),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < weekDates.length; i++)
                    i == weekDates.length - 1
                        ? ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 30,
                              minHeight: 57,
                            ),
                            child: DayButton(
                              date: weekDates[i],
                              selectedDate: _selectedDate,
                              onDateSelected: _onDateSelected,
                            ),
                          )
                        : Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 30,
                                  minHeight: 57,
                                ),
                                child: DayButton(
                                  date: weekDates[i],
                                  selectedDate: _selectedDate,
                                  onDateSelected: _onDateSelected,
                                ),
                              ),
                              Spacing(width: spacing),
                            ],
                          ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Note>>(
            future: selectedType == NoteType.DAY
                ? noteDatabase.getNotesByDate(_selectedDate)
                : noteDatabase.getNotesWithLessonId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return snapshot.hasData && snapshot.data!.isNotEmpty
                    ? SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return NoteEditDialog(
                                              currentDate: _selectedDate,
                                              note: snapshot.data![index],
                                              onUpdate: updateNotes
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: snapshot.data![index].color,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 18),
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          snapshot.data![index].isImportant
                                              ? Image.asset(
                                                  'assets/notes/important.png',
                                                  color: snapshot.data![index]
                                                              .color ==
                                                          Color(0xFFE9EEF3)
                                                      ? Color(0xFF2C4A60)
                                                      : Colors.white,
                                                )
                                              : Container(),
                                          Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data![index].title,
                                                    style: TextStyle(
                                                        color: snapshot
                                                                    .data![
                                                                        index]
                                                                    .color ==
                                                                Color(
                                                                    0xFFE9EEF3)
                                                            ? Colors.black
                                                            : Colors.white),
                                                  ),
                                                  SizedBox(
                                                    height: 10 * fem,
                                                  ),
                                                  Text(
                                                    snapshot.data![index].text,
                                                    style: TextStyle(
                                                        color: snapshot
                                                                    .data![
                                                                        index]
                                                                    .color ==
                                                                Color(
                                                                    0xFFE9EEF3)
                                                            ? Colors.black
                                                            : Colors.white),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    )));
                          },
                        ),
                      )
                    : noNotes();
              }
            },
          ),
        ],
      ),
    )
    );
  }

  Widget noNotes() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 85, 16, 0),
          child: Image.asset('assets/notes/note_image.png'),
        ),
        Text(
          'Заметок пока нет - можешь их создать',
          style: AppTextStyle.mainTextStyle,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: selectedType == NoteType.DAY
              ? GestureDetector(
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
                        style: AppTextStyle.headerTextStyle,
                      ),
                    ),
                  ))
              : Container(),
        )
      ],
    );
  }

  void onCreatePressed() {
    print('Кнопка "Создать" нажата');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteCreationDialog(
                currentDate: _selectedDate, type: NoteType.DAY,
              )),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            hintColor: Color(0xFF2C4A60),
            backgroundColor: Colors.white,
            textTheme: TextTheme(
              bodyText1: TextStyle(color: Color(0xFF2C4A60)),
              caption: TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        weekDates = List.generate(7, (index) => _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)).add(Duration(days: index)));

      });
      print("Selected date: $_selectedDate");
    }
  }

  void _updateSelectedDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      weekDates = List.generate(7, (index) => _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)).add(Duration(days: index)));

    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      weekDates = List.generate(7, (index) => _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)).add(Duration(days: index)));
    });
  }
  void updateNotes() {
    setState(() {});
  }
}