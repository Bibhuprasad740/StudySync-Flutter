import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../errors/api_response.dart';
import '../utils/utils.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _authController = AuthController();

  void logoutUser(BuildContext context) async {
    ApiResponse response = await _authController.logout();

    if (response.statusCode == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      showSnackBar(context, response.message);
    }
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
