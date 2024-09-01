import 'dart:convert';

import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _authController = AuthController();

  void logoutUser(BuildContext context) async {
    await _authController.logout();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => logoutUser(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
