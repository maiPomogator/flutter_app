import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile_client/FirstChoiceScreen.dart';
import 'package:flutter_mobile_client/MainScreen.dart';
import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/data/LessonsDatabase.dart';
import 'package:flutter_mobile_client/data/NoteDatabase.dart';
import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
import 'data/LocalDataBaseUpdater.dart';
import 'data/SheduleList.dart';
import 'data/UserPreferences.dart';

Future<void> main() async {
  //debugPaintSizeEnabled = true;
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  await NoteDatabase.instance.initializeDatabase();
  await ScheduleList.instance.initializeDatabase();
  await ProfessorDatabase.initDatabase();
  await GroupDatabaseHelper.initDatabase();
  await LessonsDatabase.initDatabase();
  LocalDatabaseHelper.instance.populateAllLessonDatabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void updateTheme(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.updateTheme();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData _themeData;

  @override
  void initState() {
    super.initState();
    _themeData = _getThemeData(UserPreferences.getTheme());
  }

  void updateTheme() {
    setState(() {
      _themeData = _getThemeData(UserPreferences.getTheme());
    });
  }

  ThemeData _getThemeData(String? themeName) {
    switch (themeName) {
      case 'Темная':
        return ThemeData.dark();
      case 'Светлая':
        return ThemeData.light();
      default:
      // Системная тема
        return ThemeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _themeData,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: ScheduleList.instance.getCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print('Ошибка: ${snapshot.error}');
          return Text('Ошибка: ${snapshot.error}');
        } else {
          if (_currentIndex == 0 && snapshot.data! > 0) {
            return MainScreen();
          } else {
            return FirstChoiceScreen();
          }
        }
      },
    );
  }
}
