import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/data/LessonsDatabase.dart';
import 'package:flutter_mobile_client/data/NoteDatabase.dart';
import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
import 'package:flutter_mobile_client/data/SheduleList.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../errors/LoggerService.dart';
import '../model/Group.dart';
import '../model/Lesson.dart';
import '../model/Note.dart';
import '../model/NoteType.dart';
import '../model/Professor.dart';
import '../notes/NoteCreationDialog.dart';
import '../widgets/DayButton.dart';

class ScheduleFragment extends StatefulWidget {
  final double fem;

  ScheduleFragment({required this.fem});

  @override
  _ScheduleFragmentState createState() => _ScheduleFragmentState(fem: fem);
}

class _ScheduleFragmentState extends State<ScheduleFragment> {
  String? _selectedGroup;

  late double fem;
  DateTime _selectedDate = DateTime.now();
  late DateTime currentDate;
  late DateTime monday;
  late List<DateTime> weekDates;
  late List<Map<String, dynamic>> groupList;
  dynamic aboutData;
  bool _isLoading = false;
  late Future<List<Note>> importantNotes;

  _ScheduleFragmentState({required this.fem}) {
    initializeDateFormatting('ru', null);
  }

  @override
  void initState() {
    currentDate = DateTime.now();
    monday = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    weekDates = List.generate(7, (index) => monday.add(Duration(days: index)));
    super.initState();
    initializeDateFormatting('ru', null);
    _initializeSelectedGroup();
    _initializeData();
    importantNotes = NoteDatabase.instance.getImportantNotes();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading =
          true; // Устанавливаем состояние загрузки в true перед загрузкой данных
    });
    try {
      groupList = await ScheduleList.instance.getScheduleList();
    } catch (error) {
      // Обработка ошибки загрузки данных, если необходимо
    } finally {
      setState(() {
        _isLoading =
            false; // Устанавливаем состояние загрузки в false после завершения загрузки
      });
    }
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 46),
            child: _buildGroupDropdown(),
          ),
          SizedBox(
            height: 35,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  DateFormat('d MMMM', 'ru').format(currentDate),
                  style: AppTextStyle.secondTextStyle(context),
                ),
                const Spacer(),
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
                            child: FutureBuilder<List<Note>>(
                              future: importantNotes,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(
                                      'Произошла непредвиденная ошибка');
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return DayButton(
                                    date: weekDates[i],
                                    selectedDate: _selectedDate,
                                    onDateSelected: _onDateSelected,
                                    importantNotes: snapshot.data,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          )
                        : Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 30,
                                  minHeight: 57,
                                ),
                                child: FutureBuilder<List<Note>>(
                                  future: importantNotes,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                          'Произошла непредвиденная ошибка');
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return DayButton(
                                        date: weekDates[i],
                                        selectedDate: _selectedDate,
                                        onDateSelected: _onDateSelected,
                                        importantNotes: snapshot.data,
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                              Spacing(width: spacing),
                            ],
                          ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: FutureBuilder<List<Lesson>>(
              future: LessonsDatabase.getLessonsOnDate(
                  _selectedDate, _selectedGroup),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 57,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE9EEF3),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(99),
                                    bottomRight: Radius.circular(99),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: AppTextStyle.scheduleMain(context),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  '${DateFormat('HH:mm').format(snapshot.data![index].timeStart)} - ${DateFormat('HH:mm').format((snapshot.data![index].timeStart).add(Duration(hours: 1, minutes: 30)))}',
                                ),
                              ),
                              Spacer(),
                              FutureBuilder<List<Note>>(
                                future: NoteDatabase.instance
                                    .getNotesByLesson(snapshot.data![index].id),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    return Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 200,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          color: snapshot.data![0].color,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: Flexible(
                                            child: Text(
                                              snapshot.data![0].title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: snapshot.data![0]
                                                              .color ==
                                                          Color(0xFFE9EEF3)
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                          ),
                                        ));
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 10,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NoteCreationDialog(
                                          currentDate: _selectedDate,
                                          type: NoteType.LESSON,
                                          id: snapshot.data![index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    size: 24,
                                    color: Color(0xFF2C4A60),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xffE9EEF3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 18),
                            padding: EdgeInsets.all(12),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].name,
                                  style: AppTextStyle.scheduleHeader(context),
                                ),
                                Text(
                                  snapshot.data![index].types
                                      .map((type) => type.name)
                                      .join(', '),
                                  style: AppTextStyle.scheduleMain(context),
                                ),
                                Text(
                                  snapshot.data![index].groups
                                      .map((group) => group.name)
                                      .join(', '),
                                  style: AppTextStyle.scheduleSecond(context),
                                ),
                                Text(
                                  snapshot.data![index].professors
                                      .map((professor) =>
                                          '${professor.lastName} ${professor.firstName} ${professor.middleName}')
                                      .join(', '),
                                  style: AppTextStyle.scheduleSecond(context),
                                ),
                                Text(
                                  snapshot.data![index].rooms.join(', '),
                                  style: AppTextStyle.scheduleSecond(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return noPairs();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget noPairs() {
    return Column(children: [
      Center(
        child: Padding(
          padding: EdgeInsets.only(top: 59),
          child: Image.asset('assets/schedule/meditation.png'),
        ),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Сегодня занятий нет - можно и отдохнуть',
            style: AppTextStyle.mainTextStyle(context),
          ),
        ),
      )
    ]);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
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
        weekDates = List.generate(
            7,
            (index) => _selectedDate
                .subtract(Duration(days: _selectedDate.weekday - 1))
                .add(Duration(days: index)));
      });
      LoggerService.logInfo("Selected date: $_selectedDate");
    }
  }

  Widget _buildGroupDropdown() {
    return FutureBuilder<List<DropdownMenuItem<String>>>(
      future: _buildDropdownItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final dropdownItems = snapshot.data ?? [];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _selectedGroup,
                onChanged: (String? selectedGroup) {
                  if (selectedGroup != null) {
                    _onGroupChanged(selectedGroup);
                  }
                },
                items: dropdownItems,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                isExpanded: false,
                underline: Container(),
              ),
            ],
          );
        }
      },
    );
  }

  Future<List<DropdownMenuItem<String>>> _buildDropdownItems() async {
    final dropdownItems = <DropdownMenuItem<String>>[];
    for (final group in groupList) {
      final scheduleId = group['schedule_id'];
      dynamic aboutData;
      if (group['type'] == 'group') {
        aboutData = await GroupDatabaseHelper.getGroupById(scheduleId);
      } else {
        aboutData = await ProfessorDatabase.getProfessorById(scheduleId);
      }
      final dropdownValue = '$scheduleId ${group['type']}';
      final isMain = group['isMain'] == 1;
      dropdownItems.add(
        DropdownMenuItem<String>(
          value: dropdownValue,
          child: Row(
            children: [
              if (isMain) Icon(Icons.star),
              // Добавляем звездочку, если isMain == true
              SizedBox(width: 5),
              // Добавляем небольшой отступ
              group['type'] == 'group'
                  ? Text((aboutData as Group).name)
                  : Text((aboutData as Professor).lastName),
            ],
          ),
        ),
      );
      // Добавляем запись с isMain == true в selected
      /*  if (isMain) {
        mainSelectedValue = dropdownValue;
      }*/
    }
    /* if (mainSelectedValue.isNotEmpty) {
      _onGroupChanged(
          mainSelectedValue); // Устанавливаем запись с isMain == true в выбранные
    }*/
    return dropdownItems;
  }

  void _onGroupChanged(String selectedGroup) {
    setState(() {
      _selectedGroup = selectedGroup;
    });
  }

  void _updateSelectedDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      weekDates = List.generate(
          7,
          (index) => _selectedDate
              .subtract(Duration(days: _selectedDate.weekday - 1))
              .add(Duration(days: index)));
    });
  }

  void _initializeSelectedGroup() {
    final mainGroup = ScheduleList.instance.getMainSchedule();
    if (mainGroup != null) {
      setState(() {
        _selectedGroup = '${mainGroup['schedule_id']} ${mainGroup['type']}';
      });
    }
  }
}

class Spacing extends StatelessWidget {
  final double width;

  Spacing({required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
