import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile_client/FirstChoiceScreen.dart';
import 'package:flutter_mobile_client/MainScreen.dart';
import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/data/LessonsDatabase.dart';
import 'package:flutter_mobile_client/data/NoteDatabase.dart';
import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
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
  runApp(const MyApp());
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
