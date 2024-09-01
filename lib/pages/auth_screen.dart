import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../controllers/auth_controller.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _storage = const FlutterSecureStorage();
  final _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authValue = await _authController.getAuth();

    print(authValue);
    try {
      // Check if 'auth' key exists in secure storage
      String? authToken = await _storage.read(key: 'auth');

      if (authToken != null) {
        // If 'auth' token exists, navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // If 'auth' token does not exist, navigate to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      // Handle any errors (e.g., secure storage errors)
      print('Error checking auth token: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
