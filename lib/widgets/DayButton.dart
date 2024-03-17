import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/Note.dart';

class DayButton extends StatefulWidget {
  final DateTime date;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<Note>? importantNotes;

  DayButton({
    required this.date,
    required this.selectedDate,
    required this.onDateSelected,
    required this.importantNotes
  });

  @override
  _DayButtonState createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {

  @override
  Widget build(BuildContext context) {
    bool haveImportant = false;
    bool isSelected = widget.selectedDate.weekday == widget.date.weekday;
    bool isToday = DateTime.now().day == widget.date.day;
    if(widget.importantNotes!=null){
      for(int i=0;i<widget.importantNotes!.length;i++){
        if (widget.importantNotes![i].targetTimestamp.year == widget.date.year &&
            widget.importantNotes![i].targetTimestamp.month == widget.date.month &&
            widget.importantNotes![i].targetTimestamp.day == widget.date.day) {
          haveImportant = true;
        }
      }
    }

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
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xff333333),
              ),
            ),
            Text(
              DateFormat.d().format(widget.date),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xff333333),
              ),
            ),
            haveImportant? Container(width: 5,height: 5,decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(99),
            ),
            ): Container(width: 5,height: 5,),
          ],
        ),
      ),
    );
  }
}
