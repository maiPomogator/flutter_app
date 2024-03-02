import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
import 'package:flutter_mobile_client/data/SheduleList.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../model/Group.dart';
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
  String _selectedGroup = "М3О-435Б-20";
  late double fem;
  DateTime _selectedDate = DateTime.now();
  late DateTime currentDate;
  late DateTime monday;
  late List<DateTime> weekDates;
  late List<Map<String, dynamic>> groupList;
  dynamic aboutData;

  _ScheduleFragmentState({required this.fem}) {
    initializeDateFormatting('ru', null);
  }

  @override
  Future<void> initState() async {
    currentDate = DateTime.now();
    monday = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    weekDates = List.generate(7, (index) => monday.add(Duration(days: index)));
    groupList = await ScheduleList.instance.getScheduleList();
    super.initState();
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
                Text(
                  DateFormat('d MMMM', 'ru').format(currentDate),
                  style: AppTextStyle.secondTextStyle,
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
          _selectedDate.day == DateTime.now().day
              ? Column(
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
                            child: Text('1'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text('10:45 - 12:15'),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoteCreationDialog(
                                          currentDate: _selectedDate,
                                          type: NoteType.DAY, //todo lesson
                                        )),
                              );
                            },
                            child: ImageIcon(
                              AssetImage('assets/navigation/note_icon.png'),
                              size: 24,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Информационная безопасность',
                              style: AppTextStyle.headerTextStyle,
                            ),
                            Text(
                              'Лекция',
                              style: AppTextStyle.mainTextStyle,
                            ),
                            Text(
                              'М3О-435Б-20',
                              style: AppTextStyle.secondTextStyle,
                            ),
                            Text(
                              'Коновалов Кирилл Андреевич',
                              style: AppTextStyle.secondTextStyle,
                            ),
                            Text(
                              '404В',
                              style: AppTextStyle.secondTextStyle,
                            ),
                          ],
                        )),
                  ],
                )
              : noPairs()
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
            style: AppTextStyle.mainTextStyle,
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
      print("Selected date: $_selectedDate");
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
                selectedItemBuilder: (BuildContext context) {
                  return groupList.map<Widget>((group) {
                    final scheduleId = group['schedule_id'];
                    final typeName =
                        group['type'] == 'group' ? group['name'] : '...';
                    return DropdownMenuItem<String>(
                      value: '$scheduleId ${group['type']}',
                      child: Text(
                        typeName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList();
                },
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
      if (group['type'] == 'group') {
        aboutData = await GroupDatabaseHelper.getGroupById(scheduleId);
      } else {
        aboutData = await ProfessorDatabase.getProfessorById(scheduleId);
      }
      dropdownItems.add(
        DropdownMenuItem<String>(
          value: '$scheduleId ${group['type']}',
          child: group['type'] == 'group'
              ? Text((aboutData as Group).name)
              : Text((aboutData as Professor).lastName),
        ),
      );
    }
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
}

class Spacing extends StatelessWidget {
  final double width;

  Spacing({required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
