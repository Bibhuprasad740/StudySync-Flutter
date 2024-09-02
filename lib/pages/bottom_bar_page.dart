import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'home_page.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    const Center(child: Text('Search Page')),
    const Center(child: Text('Add Page')),
    const Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.add,
            text: 'Add',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}
