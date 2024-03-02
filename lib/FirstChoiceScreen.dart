import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/MainScreen.dart';
import 'package:flutter_mobile_client/data/ApiProvider.dart';

import 'data/LocalDataBaseUpdater.dart';
import 'data/SheduleList.dart';
import 'model/Group.dart';

class FirstChoiceScreen extends StatefulWidget {
  @override
  _FirstChoiceScreenState createState() => _FirstChoiceScreenState();
}

class _FirstChoiceScreenState extends State<FirstChoiceScreen> {
  int _selectedIndex = 0;
  String? dropdownCourseValue;
  String? dropdownFacultyValue;
  String? dropdownGroupValue;
  bool search = false;
  final mainNavigationRoute =
      MaterialPageRoute(builder: (context) => MainScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedIndex == 0) ...[
              Text(
                'Выберите курс',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: dropdownCourseValue,
                hint: Text('Выберите что-нибудь'),
                items: ['1', '2', '3', '4', '5', '6'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownCourseValue = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Выберите факультет',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              DropdownButton<int>(
                value: dropdownFacultyValue != null
                    ? int.tryParse(dropdownFacultyValue!)
                    : null,
                hint: Text('Выберите что-нибудь'),
                items: [
                  'Институт 1',
                  'Институт 2',
                  'Институт 3',
                  'Институт 4',
                  'Институт 5',
                  'Институт 6',
                  'Институт 7',
                  'Институт 8',
                  'Институт 9',
                  'Институт 10',
                  'Институт 11',
                  'Институт 12',
                  'Институт 14'
                ].map((String value) {
                  int number = int.parse(value.split(' ')[1]);
                  return DropdownMenuItem<int>(
                    value: number,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    dropdownFacultyValue = value.toString();
                  });
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    search = true;
                  });
                },
                child: Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    width: 120,
                    height: 40,
                    child: Center(
                        child: Text(
                      "Найти группу",
                      style: TextStyle(color: Colors.white),
                    ))),
              ),
              SizedBox(height: 10),
              search
                  ? FutureBuilder<List<Group>>(
                      future: ApiProvider.fetchGroupsByCourseAndFac(
                          dropdownCourseValue!, dropdownFacultyValue!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Ошибка: ${snapshot.error}'),
                          );
                        } else {
                          final List<Group> groups = snapshot.data ?? [];
                          return Column(children: [
                            _buildDropdown(groups),
                            GestureDetector(
                              onTap: () async {
                                int countOfGroups =
                                    await ScheduleList.instance.getCount();
                                ScheduleList.instance.insertList(
                                    int.parse(dropdownGroupValue!),
                                    'group',
                                    countOfGroups > 0 ? false : true);
                                LocalDatabaseHelper.instance.populateGroupDatabaseFromServerById( int.parse(dropdownGroupValue!));
                                setState(() {
                                  Navigator.pushReplacement(
                                      context, mainNavigationRoute);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.blue),
                                width: 120,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    "Выбрать группу",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }
                      },
                    )
                  : Container(),
            ],
            if (_selectedIndex == 1) ...[
              Text(
                'Нет данных для преподавателя',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Студент',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Преподаватель',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildDropdown(List<Group>? groups) {
    print(groups);
    if (groups != null && groups.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Выберите группу',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: dropdownGroupValue,
            hint: Text('Выберите группу'),
            items: groups.map<DropdownMenuItem<String>>((group) {
              return DropdownMenuItem<String>(
                value: group.id.toString(),
                child: Text(group.name),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                dropdownGroupValue = value!;
              });
            },
          ),
        ],
      );
    } else {
      return Center(
        child: Text('Нет доступных групп'),
      );
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
