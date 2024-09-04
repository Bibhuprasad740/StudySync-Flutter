import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../controllers/user_controller.dart';
import 'home_page.dart';
import 'leaderboard_page.dart';
import 'profile_page.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  final userController = UserController();

  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('All Studies Page')),
    const LeaderboardPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    userController.ping();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: _pages[_currentIndex],
        bottomNavigationBar: GNav(
          gap: 8,
          backgroundColor: Colors.black,
          color: Colors.grey.shade700,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.all(10),
          tabMargin: const EdgeInsets.only(
            left: 5,
            right: 5,
            top: 20,
            bottom: 5,
          ),
          onTabChange: (value) => {
            setState(() {
              _currentIndex = value;
            })
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.receipt_long,
              text: 'Studies',
            ),
            GButton(
              icon: Icons.stars,
              text: 'Leaderboard',
              iconColor: Colors.amber,
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
