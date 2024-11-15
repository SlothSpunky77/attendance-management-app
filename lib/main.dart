import 'package:dbms_project/student_page.dart';
import 'package:dbms_project/teacher_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String teacherLogin = "http://10.0.2.2/dbms_project/teacher_login.php";
  final String studentLogin = "http://10.0.2.2/dbms_project/student_login.php";
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final id = usernameController.text;
    final password = passwordController.text;

    if (password[0] == 't') {
      try {
        final response = await http.post(
          Uri.parse(teacherLogin),
          body: {
            'teacher_id': id,
            'password': password,
          },
        );
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          // Ensure the widget is still mounted before navigating
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherPage(
                  teacherID: id,
                ),
              ),
            );
          }
        } else {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Login Failed"),
                content: Text(responseData['message']),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
        print("Error: $e");
      }
    } else {
      try {
        final response = await http.post(
          Uri.parse(studentLogin),
          body: {
            'student_id': id,
            'password': password,
          },
        );
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          // Ensure the widget is still mounted before navigating
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentPage(
                  studentID: id,
                ),
              ),
            );
          }
        } else {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Login Failed"),
                content: Text(responseData['message']),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                            hintText: 'Username...',
                            hintStyle: TextStyle(color: Colors.grey)),
                        controller: usernameController,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            hintText: 'Password...',
                            hintStyle: TextStyle(color: Colors.grey)),
                        controller: passwordController,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: login,
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  child: const Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
