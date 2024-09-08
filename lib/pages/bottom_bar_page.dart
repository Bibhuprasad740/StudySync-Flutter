import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../controllers/user_controller.dart';
import 'profile_page.dart';
import 'revisions_page.dart';
import 'leaderboard_page.dart';
import 'statictics_page.dart';
import 'studies_page.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  final userController = UserController();

  int _currentIndex = 0;
  final List<Widget> _pages = [
    const StudiesPage(),
    const RevisionsPage(),
    const LeaderboardPage(),
    const StaticticsPage(),
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
        appBar: AppBar(
          title: const Text('StudySync'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                )
              },
              icon: const Icon(Icons.mood),
            ),
            IconButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                )
              },
              icon: const Icon(Icons.person_rounded),
            )
          ],
        ),
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
              text: 'Studies',
            ),
            GButton(
              icon: Icons.receipt_long,
              text: 'Revisions',
            ),
            GButton(
              icon: Icons.stars,
              text: 'Leaderboard',
            ),
            GButton(
              icon: Icons.data_usage_sharp,
              text: 'Statistics',
            ),
          ],
        ),
      ),
    );
  }
}
