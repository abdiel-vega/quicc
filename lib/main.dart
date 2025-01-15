import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicc/pages/game_selection_page.dart';
import 'pages/home_page.dart';
import 'pages/home_page_view.dart';
import 'pages/history_page.dart';
import 'pages/statistics_page.dart';
import 'pages/settings_page.dart';

void main() {
  runApp(const QuiccApp());
}

class QuiccApp extends StatelessWidget {
  const QuiccApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoSlabTextTheme(),
      ),
      // Define the initial route and set up named routes.
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/homePage': (context) => const HomePageView(),
        '/historyPage': (context) => const HistoryPage(),
        '/statisticsPage': (context) => const StatisticsPage(),
        '/settingsPage': (context) => const SettingsPage(),
        '/gameSelectionPage': (context) => const GameSelectionPage(),
      },
    );
  }
}
