import 'dart:convert';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../errors/api_response.dart';
import '../utils/utils.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final _authController = AuthController();
    final authValue = await _authController.getAuth();

    if (authValue == null) {
      // Handle case where authValue is null (e.g., navigate to login page)
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    final userData = jsonDecode(authValue);

    setState(() {
      user = userData;
    });
  }

  void _logout(BuildContext context) async {
    // Show a confirmation dialog before logging out
    bool confirmLogout = await showLogoutConfirmationDialog(context);

    if (confirmLogout) {
      ApiResponse response = await AuthController().logout();

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        showSnackBar(context, response.message);
      }
    }
  }

  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if cancel
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: user == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueAccent,
                        child:
                            Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${user!['email']}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text('Token:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            SelectableText(user!['token'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700])),
                            const SizedBox(height: 8),
                            const Text('Expires In:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            Text(user!['expiresIn'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _logout(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
