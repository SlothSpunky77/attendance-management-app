import 'dart:convert';

import 'package:dbms_project/attendance.dart';
import 'package:dbms_project/models/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherPage extends StatefulWidget {
  final String teacherID;
  const TeacherPage({super.key, required this.teacherID});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  List<String> classroomData = [];
  List<String> studentNames = [];
  List<int> studentIDs = [];
  List<String> courses = [];

  Future<void> getClassRecord() async {
    String uri = "http://10.0.2.2/dbms_project/get_classID.php";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        List decode = jsonDecode(response.body);
        classroomData =
            decode.map((item) => item['class_id'] as String).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStudentsRecord(String cid) async {
    String uri = "http://10.0.2.2/dbms_project/get_students.php?class_id=$cid";
    try {
      var response = await http.get(Uri.parse(uri));
      List decode = jsonDecode(response.body);
      setState(() {
        studentNames = decode.map((student) {
          String firstName = student['first_name'];
          String lastName = student['last_name'];
          return '$firstName $lastName';
        }).toList();
      });
      setState(() {
        studentIDs = decode.map((id) => int.parse(id['student_id'])).toList();
      }); //do you need two setStates here?
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCourses(String teacherID) async {
    String uri =
        "http://10.0.2.2/dbms_project/fetch_courses_for_teacher.php?teacher_id=$teacherID";
    try {
      var response = await http.get(Uri.parse(uri));
      setState(() {
        Map<String, dynamic> decode = jsonDecode(response.body);
        if (decode['success']) {
          courses = List<String>.from(decode['courses']);
          courseName = courses[0];
        } else {
          print('Failed to fetch courses');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getClassRecord();
    getStudentsRecord(
        '1A'); //because this is the default classroom displayed, but its not clean code
    getCourses(widget.teacherID);
  }

  String selectedClass = "1A";
  int timeslot = 1;
  String courseName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendace Allotment:'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              const Text("Choose Course:"),
              const SizedBox(
                height: 20,
              ),
              const Text("Choose Section:"),
              const SizedBox(
                height: 20,
              ),
              const Text("Choose Timeslot:"),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AttendancePage(
                                studentName: studentNames,
                                studentIDs: studentIDs,
                                classID: selectedClass,
                                timeslot: timeslot,
                                courseName: courseName,
                              )),
                    );
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  child: const Text('PROCEED'),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 78, left: 120),
            child: CustomDropdown(
              options: const [
                '8:00-9:15',
                '9:15-10:30',
                '10:30-11:45',
                '11:45-1:00',
                '2:00-3:15',
                '3:15-4:30'
              ],
              onChanged: (value) {
                switch (value) {
                  case '8:00-9:15':
                    timeslot = 1;
                    break;
                  case '9:15-10:30':
                    timeslot = 2;
                    break;
                  case '10:30-11:45':
                    timeslot = 3;
                    break;
                  case '11:45-1:00':
                    timeslot = 4;
                    break;
                  case '2:00-3:15':
                    timeslot = 5;
                    break;
                  case '3:15-4:30':
                    timeslot = 6;
                    break;
                }
              },
              width: 140,
            ),
          ),
          if (classroomData.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Container(
              padding: const EdgeInsets.only(top: 39, left: 120),
              child: CustomDropdown(
                options: classroomData,
                onChanged: (value) {
                  // setState(() {
                  //   selectedClass = value;
                  // });
                  selectedClass = value;

                  getStudentsRecord(selectedClass);
                },
                width: 100,
              ),
            ),
          if (courses.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Container(
              padding: const EdgeInsets.only(top: 0, left: 120),
              child: CustomDropdown(
                options: courses,
                onChanged: (value) {
                  courseName = value;
                },
                width: 140,
              ),
            ),
        ],
      ),
    );
  }
}
