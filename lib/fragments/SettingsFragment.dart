import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';

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
            'десь будет выбранное',
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

  void handleButtonTap(String buttonName) {
    switch (buttonName) {
      case 'star':

        break;
      case 'theme':

        break;
      case 'telegram':

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
