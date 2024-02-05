import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile_client/data/UserPreferences.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsFragment extends StatefulWidget {
  @override
  _SettingsFragmentState createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 46),
            child: Text(
              "Настройки",
              style: AppTextStyle.headerTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 24),
          child: buildSettingsItem(
            'star',
            'Избранное расписания',
            'десь будет выбранное',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: buildSettingsItem(
            'theme',
            'Тема',
            'десь будет выбранное',
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

  Future<void> handleButtonTap(String buttonName) async {
    switch (buttonName) {
      case 'star':
        break;
      case 'theme':
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
            if (message != null && message != '') {
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
        break;
      default:
        break;
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
                    style: AppTextStyle.mainTextStyle,
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyle.secondTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
