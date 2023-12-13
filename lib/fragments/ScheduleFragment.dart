import 'package:flutter/material.dart';
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
    // Calculate total spacing needed
    double totalSpacing =
        MediaQuery.of(context).size.width - (weekDates.length * buttonWidth);

    // Calculate the space between buttons
    double spacing = totalSpacing / (weekDates.length - 1);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGroupDropdown(),
        SizedBox(
          height: 35,
          child: Row(
            children: [
              Text(
                DateFormat('d MMMM', 'ru').format(currentDate),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
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
          width: MediaQuery.of(context).size.width, // Full width of the screen
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
      ],
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: DropdownButton<String>(
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
        isExpanded: true,
        underline: Container(
          height: 2,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  void _onGroupChanged(String selectedGroup) {
    setState(() {
      _selectedGroup = selectedGroup;
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
