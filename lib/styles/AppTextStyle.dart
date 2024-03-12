import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle headerTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      color: Theme.of(context).brightness == Brightness.light
          ? Color(0xFF1D1B20) // Светлая тема
          : Colors.white, // Темная тема
    );
  }

  static TextStyle mainTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      color: Theme.of(context).brightness == Brightness.light
          ? Color(0xDE000000) // Светлая тема
          : Colors.white, // Темная тема
    );
  }

  static TextStyle secondTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      color: Theme.of(context).brightness == Brightness.light
          ? Color(0x99000000) // Светлая тема
          : Colors.white, // Темная тема
    );
  }
  static TextStyle scheduleHeader(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      color:Color(0xFF1D1B20)
    );
  }
  static TextStyle scheduleMain(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      color: Color(0xDE000000)
    );
  }
  static TextStyle scheduleSecond(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      color: Color(0x99000000)
    );
  }
}
