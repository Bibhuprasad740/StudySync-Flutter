// Flutter core
import 'package:flutter/material.dart';

// packages
// dotenv package
import 'package:flutter_dotenv/flutter_dotenv.dart';

// firebase package
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// pages
import 'pages/auth_screen.dart';

void main() async {
  // firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // dotenv load
  await dotenv.load();

  runApp(const StudySync());
}

class StudySync extends StatelessWidget {
  const StudySync({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}
