import 'package:flutter/material.dart';

class SettingsFragment extends StatefulWidget {
  @override
  _SettingsFragmentState createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  final TextStyle headerTextStyle = const TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      color: Color(0xFF1D1B20));
  final TextStyle mainTextStyle = const TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      color: Color(0xDE000000));
  final TextStyle secondTextStyle = const TextStyle(
      fontSize: 12,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      color: Color(0x99000000));

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
              style: headerTextStyle,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 24),
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
                Image.asset('assets/settings/star.png'),
                Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Избранное расписания',
                          style: mainTextStyle,
                        ),
                        Text(
                          'десь будет выбранное',
                          style: secondTextStyle,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
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
                Image.asset('assets/settings/theme.png'),
                Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Тема',
                          style: mainTextStyle,
                        ),
                        Text(
                          'десь будет выбранное',
                          style: secondTextStyle,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
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
                Image.asset('assets/settings/telegram.png'),
                Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Привязать телеграм',
                          style: mainTextStyle,
                        ),
                        Text(
                          'десь будет выбранное',
                          style: secondTextStyle,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
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
                Image.asset('assets/settings/backup.png'),
                Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Импорт/экспорт данных',
                          style: mainTextStyle,
                        ),
                        Text(
                          'Перенос данных между устройствами',
                          style: secondTextStyle,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
