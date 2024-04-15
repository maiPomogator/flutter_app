import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/MainScreen.dart';
import 'package:flutter_mobile_client/data/ApiProvider.dart';
import 'package:flutter_mobile_client/errors/LoggerService.dart';
import 'package:flutter_mobile_client/model/Professor.dart';

import 'data/LocalDataBaseUpdater.dart';
import 'data/SheduleList.dart';
import 'errors/ErrorDialog.dart';
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
  int? selectedProfessor;
  TextEditingController _labelFieldController = TextEditingController();
  bool search = false;
  bool searchProf = false;
  final mainNavigationRoute =
      MaterialPageRoute(builder: (context) => MainScreen());

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
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
                                await LocalDatabaseHelper.instance
                                    .populateGroupDatabaseFromServerById(
                                        int.parse(dropdownGroupValue!));
                                ScheduleList.instance.getMainScheduleIntoVar();
                                setState(() {
                                  Navigator.pushReplacement(
                                      context, mainNavigationRoute);
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 40,
                                decoration: BoxDecoration(color: Colors.blue),
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
              TextField(
                maxLines: 1,
                textAlign: TextAlign.start,
                controller: _labelFieldController,
                decoration: InputDecoration(
                  labelText: 'Введите ФИО',
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (_labelFieldController.text.isNotEmpty) {
                    setState(() {
                      searchProf = true;
                    });
                  } else {
                    ErrorDialog.showError(context, 'Проверьте данные',
                        'Проверьте заполнение поля Заголовок или основного текста');
                  }
                },
                child: Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 40,
                    child: Center(
                        child: Text(
                      "Найти преподавателя",
                      style: TextStyle(color: Colors.white),
                    ))),
              ),
              SizedBox(height: 10),
              searchProf
                  ? FutureBuilder<List<Professor>>(
                      future: ApiProvider.fetchProfessors(),
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
                          return Column(children: [
                            FutureBuilder<List<Professor>>(
                              future: searchProfessors(snapshot.data!),
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
                                  List<Professor> professors = snapshot.data!;
                                  return DropdownButton<int>(
                                    value: selectedProfessor,
                                    hint: Text('Выберите преподавателя'),
                                    items: professors
                                        .map<DropdownMenuItem<int>>(
                                            (professor) {
                                      return DropdownMenuItem<int>(
                                        value: professor.id,
                                        child: Text(
                                            '${professor.lastName} ${professor.firstName} ${professor.middleName}'),
                                      );
                                    }).toList(),
                                    onChanged: (int? professorId) {
                                        selectedProfessor = professorId;
                                    },
                                  );
                                }
                              },
                            ),
                            GestureDetector(
                              onTap: () async {
                                int countOfGroups =
                                    await ScheduleList.instance.getCount();
                                ScheduleList.instance.insertList(
                                    int.parse(selectedProfessor.toString()),
                                    'professor',
                                    countOfGroups > 0 ? false : true);
                                await LocalDatabaseHelper.instance
                                    .populateProfessorDatabaseFromServerById(
                                        int.parse(
                                            selectedProfessor.toString()));
                                ScheduleList.instance.getMainScheduleIntoVar();
                                setState(() {
                                  Navigator.pushReplacement(
                                      context, mainNavigationRoute);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.blue),
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    "Выбрать преподавателя",
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
    LoggerService.logInfo(groups.toString());
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
              dropdownGroupValue = value!;
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

  List<String> generateNGrams(String text, int n) {
    List<String> ngrams = [];
    for (int i = 0; i <= text.length - n; i++) {
      ngrams.add(text.substring(i, i + n));
    }
    return ngrams;
  }

  double ngramSimilarity(String text1, String text2, int n) {
    Set<String> ngrams1 = generateNGrams(text1, n).toSet();
    Set<String> ngrams2 = generateNGrams(text2, n).toSet();
    int intersection = ngrams1.intersection(ngrams2).length;
    int union = ngrams1.union(ngrams2).length;
    return intersection / union;
  }

  Future<List<Professor>> searchProfessors(List<Professor> professors) async {
    String professorName = _labelFieldController.text.toLowerCase();
    List<Map<String, dynamic>> matches = [];

    for (int i = 0; i < professors.length; i++) {
      String profFullName =
          '${professors[i].lastName} ${professors[i].firstName} ${professors[i].middleName}'
              .toLowerCase();
      double similarity = ngramSimilarity(professorName, profFullName, 2);
      int distance = ((1 - similarity) * 10000).toInt();
      matches.add({'professor': professors[i], 'distance': distance});
    }

    matches.sort((a, b) => a['distance'].compareTo(b['distance']));

    List<Professor> bestMatches = [];
    for (int i = 0; i < matches.length && i < 5; i++) {
      bestMatches.add(matches[i]['professor']);
    }

    return bestMatches;
  }

  Future<void> checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      const snackBar = SnackBar(
        content: Text('Нет подключения к интернету'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
