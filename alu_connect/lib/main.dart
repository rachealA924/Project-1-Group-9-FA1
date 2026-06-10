import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'features/opportunities/opportunities_feed_screen.dart';
import 'features/community/init.dart';
import 'features/events/init.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AluConnectApp());
}

class AluConnectApp extends StatelessWidget {
  const AluConnectApp({super.key});
=======
import 'package:alu_connect/features/home/splash_screen.dart';

void main() {
  runApp(const ALUConnectApp());
}

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});
>>>>>>> Home

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect+',
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      theme: buildAppTheme(),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CommunitiesHubScreen(),
    const OpportunitiesFeedScreen(),
    const EventDiscoveryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFFE94560),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Opportunities'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
        ],
      ),
=======
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF5C842),
          surface: Color(0xFF141720),
          background: Color(0xFF0D0F14),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFF5C842),
        ),
      ),
      home: SplashScreen(),
>>>>>>> Home
    );
  }
}