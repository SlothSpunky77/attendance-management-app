import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  final List<String> studentName;
  final List<int> studentIDs;
  final String classID;
  final String courseName;
  final int timeslot;

  const AttendancePage({
    super.key,
    required this.studentName,
    required this.studentIDs,
    required this.classID,
    required this.courseName,
    required this.timeslot,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  int currentIndex = 0;
  Map<int, bool> attendance = {};
  bool showReview = false;
  int courseID = 0;

  final String uploadUrl = "http://10.0.2.2/dbms_project/upload_attendance.php";

  Future<void> getCourseID(String courseName) async {
    String uri =
        "http://10.0.2.2/dbms_project/course_from_name.php?course_name=$courseName";
    try {
      final response = await http.get(Uri.parse(uri));
      setState(() {
        Map<String, dynamic> decode = jsonDecode(response.body);
        if (decode['success']) {
          courseID = int.parse(decode['course_id']);
        } else {
          print('Failed to fetch course ID');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadAttendance(int studentID, bool isPresent) async {
    print(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    try {
      final response = await http.post(
        Uri.parse(uploadUrl),
        body: {
          'student_id': studentID.toString(),
          'class_id': widget.classID,
          'course_id': courseID.toString(),
          'attendance_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'timeslot': widget.timeslot.toString(),
          'status': isPresent ? 'Present' : 'Absent',
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['success']) {
        print(responseData['message']);
      } else {
        print("Error: ${responseData['message']}");
      }
    } catch (e) {
      print("Error uploading data: $e");
    }
  }

  void _markAttendance(bool isPresent) {
    setState(() {
      attendance[widget.studentIDs[currentIndex]] = isPresent;
      currentIndex < widget.studentName.length - 1
          ? currentIndex++
          : showReview = true;
    });
  }

  @override
  void initState() {
    getCourseID(widget.courseName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showReview ? 'Attendance Review' : 'Mark Attendance'),
        automaticallyImplyLeading: false,
      ),
      body: showReview
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.studentName.length,
                    itemBuilder: (context, index) {
                      final studentName = widget.studentName[index];
                      final sID = widget.studentIDs[index];
                      bool isPresent = attendance[sID] ?? false;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return ListTile(
                            leading: Icon(
                              isPresent ? Icons.check_circle : Icons.cancel,
                              color: isPresent ? Colors.green : Colors.red,
                            ),
                            title: Text(studentName),
                            trailing: TextButton(
                              onPressed: () {
                                setState(() {
                                  isPresent = !isPresent;
                                });
                              },
                              child: const Text(
                                "change",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    attendance.forEach((SID, isPresent) {
                      uploadAttendance(SID, isPresent);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "FINISH",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      widget.studentName[currentIndex],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _markAttendance(false),
                          child: Container(
                            color: Colors.red.withOpacity(0.1),
                            child: const Center(
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _markAttendance(true),
                          child: Container(
                            color: Colors.green.withOpacity(0.1),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 100,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
