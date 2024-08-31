import 'package:flutter/material.dart';
import './pages/login_page.dart';

void main() {
  runApp(const StudySync());
}

class StudySync extends StatelessWidget {
  const StudySync({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
