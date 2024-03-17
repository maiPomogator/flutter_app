import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/FirstChoiceScreen.dart';
import 'package:flutter_mobile_client/data/ProfessorDatabase.dart';
import 'package:flutter_mobile_client/data/SheduleList.dart';
import 'package:flutter_mobile_client/model/Professor.dart';
import 'package:flutter_mobile_client/styles/AppTextStyle.dart';

import '../data/GroupDatabaseHelper.dart';
import '../model/Group.dart';

class ScheduleEditor extends StatefulWidget {
  ScheduleEditor();

  @override
  _ScheduleEditorState createState() => _ScheduleEditorState();
}

class _ScheduleEditorState extends State<ScheduleEditor> {
  late Future<String> mainScheduleName;
  late Future<List<String>> favoriteScheduleNames;
  final mainNavigationRoute =
      MaterialPageRoute(builder: (context) => FirstChoiceScreen());

  @override
  void initState() {
    super.initState();
    mainScheduleName = getMainScheduleName();
    favoriteScheduleNames = getScheduleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Избранное расписание',
          style: AppTextStyle.headerTextStyle(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 352,
              height: 92,
              decoration: BoxDecoration(
                color: Color(0xff2C4A60),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Image.asset(
                      'assets/notes/important.png',
                      color: Colors.white,
                      width: 33,
                      height: 33,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Настрой рапсисание',
                        style: AppTextStyle.settingsMain(context),
                      ),
                      Text(
                        'Основное будет отображено в меню,\nизбранное - в быстром доступе поиска',
                        style: AppTextStyle.settingsSecond(context),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Основное расписание',
              style: AppTextStyle.headerTextStyle(context),
            ),
            FutureBuilder<String>(
              future: mainScheduleName,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Ошибка при получении данных');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFF21212114),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Text(
                        snapshot.data ?? 'Нет выбранного',
                        style: AppTextStyle.mainTextStyle(context),
                      ));
                } else {
                  return Container();
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Избранное расписание',
                style: AppTextStyle.headerTextStyle(context),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: favoriteScheduleNames,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Ошибка при получении данных');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF21212114),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Text(
                            snapshot.data![index],
                            style: AppTextStyle.mainTextStyle(context),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
              child: GestureDetector(
                onTap: onFindTapped,
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEF3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Найти расписание',
                      style: AppTextStyle.scheduleHeader(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

  Future<List<String>> getScheduleList() async {
    List<Map<String, dynamic>> scheduleList = [];
    List<Map<String, dynamic>> notMain =
        await ScheduleList.instance.getScheduleList();

    for (int i = 0; i < notMain.length; i++) {
      if (notMain[i]['isMain'] != 1) {
        scheduleList.add(notMain[i]);
      }
    }
    List<String> scheduleString = [];
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i]['type'] == 'group') {
        Group group = await GroupDatabaseHelper.getGroupById(
            scheduleList[i]['schedule_id']);
        scheduleString.add(group.name);
      } else {
        Professor professor = await ProfessorDatabase.getProfessorById(
            scheduleList[i]['schedule_id']);
        scheduleString.add(
            '${professor.middleName} ${professor.firstName} ${professor.lastName}');
      }
    }
    return scheduleString;
  }

  void onFindTapped() {
    Navigator.pushReplacement(context, mainNavigationRoute);
  }
}
