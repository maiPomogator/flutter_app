import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  _ScheduleFragmentState({required this.fem}) {
    initializeDateFormatting('ru', null);
  }

  @override
  Widget build(BuildContext context) {

    DateTime currentDate = DateTime.now();
    DateTime monday =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));

    List<DateTime> weekDates =
        List.generate(7, (index) => monday.add(Duration(days: index)));

    const buttonWidth = 30.0;
    double totalSpacing =
        MediaQuery.of(context).size.width - (weekDates.length * buttonWidth);
    double spacing = totalSpacing / (weekDates.length + 2);

    return GestureDetector(
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
        ],
      ),
    );
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
      });
      print("Selected date: $_selectedDate");
    }
  }

  Widget _buildGroupDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // Align the dropdown in the center horizontally
      children: [
        DropdownButton<String>(
          value: _selectedGroup,
          onChanged: (String? selectedGroup) {
            if (selectedGroup != null) {
              _onGroupChanged(selectedGroup);
            }
          },
          items: [
            DropdownMenuItem(
              value: "М3О-435Б-20",
              child: Text("М3О-435Б-20"),
            ),
            DropdownMenuItem(
              value: "М3З-228М-25",
              child: Text("М3З-228М-25"),
            ),
          ],
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black, // Adjust the color as needed
          ),
          isExpanded: false,
          underline: Container(),
          // Remove the underline
          selectedItemBuilder: (BuildContext context) {
            return [
              DropdownMenuItem(
                value: _selectedGroup,
                child: Text(
                  _selectedGroup,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black, // Adjust the color as needed
                  ),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  void _onGroupChanged(String selectedGroup) {
    setState(() {
      _selectedGroup = selectedGroup;
    });
  }

  void _updateSelectedDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
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
