// day_button.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayButton extends StatefulWidget {
  final DateTime date;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  DayButton({
    required this.date,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  _DayButtonState createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.selectedDate.weekday == widget.date.weekday;
    bool isToday = DateTime.now().weekday == widget.date.weekday;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 30,
      decoration: BoxDecoration(
        border: isToday
            ? Border.all(color: const Color(0xFF2C4A60))
            : Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(99),
        color: isSelected ? const Color(0xFF2C4A60) : Colors.white,
      ),
      child: TextButton(
        onPressed: () => widget.onDateSelected(widget.date),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size(0, 0),
        ),
        child: Column(
          children: [
            Text(
              DateFormat.E('ru').format(widget.date),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(
              DateFormat.d().format(widget.date),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
