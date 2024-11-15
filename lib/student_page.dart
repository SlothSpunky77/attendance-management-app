import 'package:dbms_project/models/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentPage extends StatefulWidget {
  final String studentID;
  const StudentPage({super.key, required this.studentID});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<Map<String, dynamic>> attendanceRecords = [];
  List<String> courses = [];
  int courseID = 1;
  int percentage = -1;

  @override
  void initState() {
    super.initState();
    getCourses();
    fetchAttendanceData(widget.studentID, courseID);
    getAttendancePercentage(widget.studentID, courseID);
  }

  Future<void> fetchAttendanceData(String studentID, int courseID) async {
    // Fetch attendance records
    String url1 = 'http://10.0.2.2/dbms_project/get_attendance_record.php';
    try {
      final response1 = await http.post(
        Uri.parse(url1),
        body: {
          'student_id': studentID,
          'course_id': courseID.toString(),
        },
      );
      List decode1 = json.decode(response1.body);

      setState(() {
        attendanceRecords = decode1.map((record) {
          return {
            'class_id': record['class_id'],
            'attendance_date': record['attendance_date'],
            'timeslot': record['timeslot'],
            'status': record['status']
          };
        }).toList();
        getAttendancePercentage(widget.studentID, courseID);
      });
    } catch (e) {
      print("Error fetching attendance records: $e");
    }
  }

  Future<void> getAttendancePercentage(String studentID, int courseID) async {
    String url2 = 'http://10.0.2.2/dbms_project/attendance_percentage.php';
    try {
      final response2 = await http.post(
        Uri.parse(url2),
        body: {
          'student_id': studentID,
          'course_id': courseID.toString(),
        },
      );

      List<dynamic> decode2 = json.decode(response2.body);

      setState(() {
        percentage = double.parse(decode2[0]['attendance_percentage']).round();
        print(percentage);
      });
    } catch (e) {
      print("Error fetching attendance percentage: $e");
    }
  }

  Future<void> getCourses() async {
    String uri = "http://10.0.2.2/dbms_project/get_courses.php";
    try {
      final response = await http.get(
        Uri.parse(uri),
      );
      setState(() {
        Map<String, dynamic> decode = jsonDecode(response.body);
        if (decode['success']) {
          courses = List<String>.from(decode['courses']);
        } else {
          print('Failed to fetch courses');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  String timeslotConversion(int timeslot) {
    switch (timeslot) {
      case 1:
        return '8:00-9:15';
      case 2:
        return '9:15-10:30';
      case 3:
        return '10:30-11:45';
      case 4:
        return '11:45-1:00';
      case 5:
        return '2:00-3:15';
      case 6:
        return '3:15-4:30';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Attendance Record'),
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
              Text("Attendance (%): $percentage%"),
              const SizedBox(
                height: 10,
              ),
              attendanceRecords.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Table(
                          border: TableBorder.all(
                            borderRadius: BorderRadius.circular(10),
                            width: 2,
                            color: Colors.black,
                          ),
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Class ID',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Date',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Timeslot',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Status',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            ...attendanceRecords.map(
                              (record) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(record['class_id'],
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(record['attendance_date'],
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        timeslotConversion(
                                            int.parse(record['timeslot'])),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(record['status'],
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
          if (courses.isEmpty)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Container(
              padding: const EdgeInsets.only(top: 0, left: 115),
              child: CustomDropdown(
                options: courses,
                onChanged: (value) {
                  int i = 1;
                  for (String courseName in courses) {
                    if (courseName == value) {
                      courseID = i;
                      break;
                    } else {
                      i++;
                    }
                  }
                  setState(() {
                    fetchAttendanceData(widget.studentID, courseID);
                  });
                },
                width: 150,
              ),
            ),
        ],
      ),
    );
  }
}
