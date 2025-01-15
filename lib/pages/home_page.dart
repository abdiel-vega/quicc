import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'home_page_view.dart';
import 'history_page.dart';
import 'statistics_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageView(),
    const HistoryPage(),
    const StatisticsPage(),
    const SettingsPage(),
  ];

  final List<String> _titles = [
    'Home',
    'History',
    'Statistics',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color to match the rest of the layout
      backgroundColor: const Color(0xFF84DCC6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // Height of the AppBar
        child: Material(
          elevation: 4.0, // Drop shadow elevation
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20.0), // Rounds the bottom corners
          ),
          color: const Color(0xFFFF686B), // AppBar background color
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
            child: AppBar(
              elevation: 0, // Remove default shadow to avoid duplication
              backgroundColor: const Color(0xFFFF686B),
              centerTitle:
                  true, // Centers the title vertically and horizontally
              title: Text(
                _titles[_currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFFF686B),
        unselectedItemColor: const Color(0xFFFFA69E),
        borderRadius: 20.0,
        boxShadow: [
          BoxShadow(
              color: Color.fromARGB(87, 0, 0, 0),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(2, 4)),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            selectedColor: Colors.white, // White icon for better visibility
          ),
          CrystalNavigationBarItem(
            icon: Icons.history,
            selectedColor: Colors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.leaderboard,
            selectedColor: Colors.white,
          ),
          CrystalNavigationBarItem(
            icon: Icons.settings,
            selectedColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
