import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile_client/data/GroupDatabaseHelper.dart';
import 'package:flutter_mobile_client/data/JsonBackup.dart';
import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
import 'package:flutter_mobile_client/data/SheduleList.dart';
import 'package:flutter_mobile_client/data/UserPreferences.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../schedule/ScheduleEditor.dart';

class SettingsFragment extends StatefulWidget {
  @override
  _SettingsFragmentState createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  String _selectedTheme = UserPreferences.getTheme() == null
      ? 'Светлая'
      : UserPreferences.getTheme()!;
  late Future<String> mainValue;

  @override
  void initState() {
    mainValue = getMainScheduleName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: mainValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Ошибка при получении данных');
          } else {
            final mainScheduleName = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 46),
                    child: Text(
                      "Настройки",
                      style: AppTextStyle.headerTextStyle(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: buildSettingsItem(
                    'star',
                    'Избранное расписания',
                    mainScheduleName!,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: buildSettingsItem(
                    'theme',
                    'Тема',
                    _selectedTheme,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: buildSettingsItem(
                    'telegram',
                    'Привязать телеграм',
                    UserPreferences.getIsAuth() ? 'Привязано' : 'Не привязано',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: buildSettingsItem(
                    'backup',
                    'Импорт/экспорт данных',
                    'Перенос данных между устройствами',
                  ),
                ),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Future<String> getMainScheduleName() async {
    if (ScheduleList.instance.mainSchedule != null) {
      if (ScheduleList.instance.mainSchedule!['type'] == 'group') {
        final group = await GroupDatabaseHelper.getGroupById(
            ScheduleList.instance.mainSchedule!['schedule_id']);
        return group.name;
      } else {
        final professor = await ProfessorDatabase.getProfessorById(
            ScheduleList.instance.mainSchedule!['schedule_id']);
        return '${professor.lastName} ${professor.firstName} ${professor.middleName}';
      }
    } else {
      return "Нет выбранного";
    }
  }

  Widget buildSettingsItem(
    String imageName,
    String title,
    String subtitle,
  ) {
    return GestureDetector(
      onTap: () => handleButtonTap(imageName),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF21212114),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 16,
            ),
            Image.asset('assets/settings/$imageName.png'),
            Padding(
              padding: EdgeInsets.only(left: 12, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.mainTextStyle(context),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyle.secondTextStyle(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handleButtonTap(String buttonName) async {
    switch (buttonName) {
      case 'star':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleEditor(onUpdate: updateName),
          ),
        );
        break;
      case 'theme':
        showThemeOptions(context);
        break;
      case 'telegram':
        final String botUserName = dotenv.env['BOT_NAME'] ?? '';
        Uri? url;
        String message = 'кал';
        try {
          if (message != null && message != '') {
            url = Uri.parse('https://t.me/$botUserName?start=uuid');
          } else {
            url = Uri.parse('https://t.me/$botUserName');
          }
          launchUrl(
            url,
            mode: LaunchMode.externalNonBrowserApplication,
            webOnlyWindowName: botUserName,
            webViewConfiguration: const WebViewConfiguration(
              headers: <String, String>{
                'User-Agent': 'Telegram',
              },
            ),
          );
          if (kDebugMode) {
            if (message != '') {
              print(
                  '\x1B[32mSending message to $botUserName...\nMessage: $message\x1B[0m\nURL: https://t.me/$botUserName?text=${Uri.encodeFull(message)}');
            } else {
              print('\x1B[32mSending message to $botUserName...\x1B[0m');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('\x1B[31mSending failed!\nError: $e\x1B[0m');
          }
        }
        break;
      case 'backup':
        await showBackupOptions(context);
        break;
      default:
        break;
    }
  }

  Future<void> showThemeOptions(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Выберите тему'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Светлая'),
                onTap: () {
                  UserPreferences.setTheme('Светлая');
                  setState(() {
                    _selectedTheme = 'Светлая';
                    MyApp.updateTheme(context);
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Темная'),
                onTap: () {
                  UserPreferences.setTheme('Темная');
                  setState(() {
                    _selectedTheme = 'Темная';
                    MyApp.updateTheme(context);
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Системная'),
                onTap: () {
                  UserPreferences.setTheme('Системная');
                  setState(() {
                    _selectedTheme = 'Системная';
                    MyApp.updateTheme(context);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showBackupOptions(BuildContext context) async {
    Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      // Разрешение на запись файлов получено
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Выберите опцию резервного копирования:'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      JsonBackup.readJson(context);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Импорт'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      JsonBackup.generateJson(context);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Экспорт'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Разрешение на запись файлов не получено
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text(
                      'Для использования функции резервного копирования необходимо разрешение на запись файлов.'),
                  const Text(
                      'Пожалуйста, предоставьте приложению необходимое разрешение.'),
                  const Text(
                      'В случае непоявления окна запроса, предоставьте разрешение через настройки устройства'),
                ],
              ),
            ),
          );
        },
      );
    }
  }
  void updateName() {
    setState(() {
      mainValue = getMainScheduleName();
    });
  }
}
