// Flutter core
import 'package:flutter/material.dart';

// packages
// dotenv package
import 'package:flutter_dotenv/flutter_dotenv.dart';

// firebase package
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// pages
import 'pages/auth_screen.dart';

// providers
import 'providers/auth_provider.dart';
import 'providers/study_provider.dart';
import 'providers/user_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider<StudyProvider>(
          create: (context) => StudyProvider(
            Provider.of<AuthProvider>(
              context,
              listen: false,
            ), // Passing AuthProvider to StudyProvider
          ),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
      ),
    );
  }
}
