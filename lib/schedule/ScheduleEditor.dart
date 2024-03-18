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
  late Future<Map<String, dynamic>> mainScheduleName;
  late Future<List<Map<String, dynamic>>> favoriteScheduleNames;
  bool onEditing = false;
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
        title: Row(children: [
          Spacer(),
          Text(
            'Избранное расписание',
            style: AppTextStyle.headerTextStyle(context),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: !onEditing
                ? IconButton(
                    icon: Icon(Icons.edit),
                    iconSize: 16,
                    onPressed: () {
                      setState(() {
                        onEditing = true;
                      });
                    },
                  )
                : Container(),
          ),
        ]),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
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
                      const SizedBox(
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
            const SizedBox(
              height: 16,
            ),
            Text(
              'Основное расписание',
              style: AppTextStyle.headerTextStyle(context),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
                future: favoriteScheduleNames,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Ошибка при получении данных');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    List<Map<String, dynamic>> schedules = snapshot.data ?? [];

                    return FutureBuilder<Map<String, dynamic>>(
                      future: mainScheduleName,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Ошибка при получении данных');
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return Container(
                              height: 30,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF21212114),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(children: [
                                Text(
                                  snapshot.data!['name'] ?? 'Нет выбранного',
                                  style: AppTextStyle.mainTextStyle(context),
                                ),
                                Spacer(),
                                onEditing
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            ScheduleList.instance.deleteList(
                                                snapshot.data!['id'],
                                                snapshot.data!['type']);
                                            if (schedules.isNotEmpty) {
                                              ScheduleList.instance
                                                  .updateIsMainByScheduleId(
                                                schedules[1]['schedule_id'],
                                                true,
                                              );
                                            }
                                            mainScheduleName =
                                                getMainScheduleName();
                                            favoriteScheduleNames =
                                                getScheduleList();
                                          });
                                        },
                                        icon: Icon(Icons.close),
                                        iconSize: 24,
                                      )
                                    : Container(),
                              ]));
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Избранное расписание',
                style: AppTextStyle.headerTextStyle(context),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
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
                          height: 30,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF21212114),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Row(children: [
                            Text(
                              snapshot.data![index]['name'],
                              style: AppTextStyle.mainTextStyle(context),
                            ),
                            Spacer(),
                            onEditing
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        ScheduleList.instance.deleteList(
                                            snapshot.data![index]['id'],
                                            snapshot.data![index]['type']);
                                        mainScheduleName =
                                            getMainScheduleName();
                                        favoriteScheduleNames =
                                            getScheduleList();
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                    iconSize: 24,
                                  )
                                : Container(),
                          ]),
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
                onTap: onEditing
                    ? () {
                        setState(() {
                          onEditing = false;
                        });
                      }
                    : onFindTapped,
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEF3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      onEditing ? 'Сохранить изменения' : 'Найти расписание',
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

  Future<Map<String, dynamic>> getMainScheduleName() async {
    Map<String, dynamic> mainMap;
    if (ScheduleList.instance.mainSchedule != null) {
      if (ScheduleList.instance.mainSchedule!['type'] == 'group') {
        final group = await GroupDatabaseHelper.getGroupById(
            ScheduleList.instance.mainSchedule!['schedule_id']);
        mainMap = {
          'name': group.name,
          'id': ScheduleList.instance.mainSchedule!['schedule_id'],
          'type': 'group'
        };
        return mainMap;
      } else {
        final professor = await ProfessorDatabase.getProfessorById(
            ScheduleList.instance.mainSchedule!['schedule_id']);
        mainMap = {
          'name':
              '${professor.lastName} ${professor.firstName} ${professor.middleName}',
          'id': ScheduleList.instance.mainSchedule!['schedule_id'],
          'type': 'professor'
        };
        return mainMap;
      }
    } else {
      return mainMap = ({'name': "Нет выбранного"});
    }
  }

  Future<List<Map<String, dynamic>>> getScheduleList() async {
    List<Map<String, dynamic>> scheduleList = [];
    List<Map<String, dynamic>> notMain =
        await ScheduleList.instance.getScheduleList();

    for (int i = 0; i < notMain.length; i++) {
      if (notMain[i]['isMain'] != 1) {
        scheduleList.add({
          'schedule_id': notMain[i]['schedule_id'],
          'type': notMain[i]['type']
        });
      }
    }
    List<Map<String, dynamic>> scheduleString = [];
    for (int i = 0; i < scheduleList.length; i++) {
      if (scheduleList[i]['type'] == 'group') {
        Group group = await GroupDatabaseHelper.getGroupById(
            scheduleList[i]['schedule_id']);
        scheduleString.add({
          'name': group.name,
          'id': scheduleList[i]['schedule_id'],
          'type': scheduleList[i]['type']
        });
      } else {
        Professor professor = await ProfessorDatabase.getProfessorById(
            scheduleList[i]['schedule_id']);

        scheduleString.add({
          'name':
              '${professor.middleName} ${professor.firstName} ${professor.lastName}',
          'id': scheduleList[i]['schedule_id'],
          'type': scheduleList[i]['type']
        });
      }
    }
    return scheduleString;
  }

  void onFindTapped() {
    Navigator.pushReplacement(context, mainNavigationRoute);
  }
}
