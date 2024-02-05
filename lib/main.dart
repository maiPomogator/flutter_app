import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile_client/model/Group.dart';
import 'package:flutter_mobile_client/model/GroupType.dart';
import 'data/GroupDatabaseHelper.dart';
import 'data/UserPreferences.dart';
import 'notes/NotesFragment.dart';
import 'fragments/ScheduleFragment.dart';
import 'fragments/SettingsFragment.dart';

Future<void> main() async {
  //debugPaintSizeEnabled = true;
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(const MyApp());
  GroupDatabaseHelper dbHelper = GroupDatabaseHelper();

  Group group1 = Group(
      id: 1,
      name: 'М3О',
      course: 2,
      faculty: 2,
      type: GroupType.BACHELOR,
      isMain: true);
  await dbHelper.insertGroup(group1);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          _buildNavItem('assets/navigation/schedule_icon.png', 'Расписание', 0),
          _buildNavItem('assets/navigation/note_icon.png', 'Заметки', 1),
          _buildNavItem('assets/navigation/settings_icon.png', 'Настройки', 2),
        ],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: const Color(0xFF2C4A60)),
      ),
    );
  }

  Widget _getBody(int index, double fem) {
    switch (index) {
      case 0:
        return ScheduleFragment(
          fem: fem,
        );
      case 1:
        return NotesFragment();
      case 2:
        return SettingsFragment();
      default:
        return Container();
    }
  }

  BottomNavigationBarItem _buildNavItem(String icon, String label, int index) {
    bool isSelected = index == _currentIndex;
    return BottomNavigationBarItem(
      icon: Container(
        width: 64,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C4A60) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF2C4A60),
        ),
      ),
      label: label,
    );
  }
}
