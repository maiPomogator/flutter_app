import 'dart:io';

import 'package:flutter/material.dart';
import 'fragments/NotesFragment.dart';
import 'fragments/ScheduleFragment.dart';
import 'fragments/SettingsFragment.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    double baseWidth = 1280;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          _getBody(_currentIndex, fem),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _buildNavItem(Icons.calendar_month, 'Расписание', 0),
          _buildNavItem(Icons.note_alt_outlined, 'Заметки', 1),
          _buildNavItem(Icons.settings, 'Настройки', 2),
        ],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: const Color(0xFF2C4A60)),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getBody(int index, double fem) {
    switch (index) {
      case 0:
        return ScheduleFragment(
          fem: fem,
        );
      case 1:
        return NotesFragment(
          fem: fem,
        );
      case 2:
        return SettingsFragment();
      default:
        return Container();
    }
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    bool isSelected = index == _currentIndex;
    return BottomNavigationBarItem(
      icon: Container(
        width: 64,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C4A60) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF2C4A60),
        ),
      ),
      label: label,
    );
  }

  Future<void> checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      const snackBar = SnackBar(
        content: Text('Нет подключения к интернету'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
