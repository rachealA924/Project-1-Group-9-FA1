import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:alu_connect/features/home/splash_screen.dart';
import 'package:alu_connect/features/home/messages_screen.dart';
import 'package:alu_connect/features/home/profile_screen.dart';
import 'features/opportunities/opportunities_feed_screen.dart';
import 'features/community/screens/communities_hub_screen.dart';
import 'features/events/screens/event_discovery.dart';

void main() {
  runApp(ALUConnectApp());
}

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});
=======
import 'features/opportunities/opportunities_feed_screen.dart';
import 'features/community/init.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AluConnectApp());
}

class AluConnectApp extends StatelessWidget {
  const AluConnectApp({super.key});
>>>>>>> b3da45c2b1175c37879cf347d81f3230ee78d122

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect+',
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
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
=======
      theme: buildAppTheme(),
      home: const MainNavigation(),
>>>>>>> b3da45c2b1175c37879cf347d81f3230ee78d122
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
<<<<<<< HEAD
    const EventDiscoveryScreen(), 
    const MessagesScreen(),
    const ProfileScreen(),
=======
>>>>>>> b3da45c2b1175c37879cf347d81f3230ee78d122
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0F14),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFF5C842),
          unselectedItemColor: const Color(0xFF8A8D99),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined), label: 'Discover'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_rounded), label: 'People'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// Temporary placeholder until teammates' screens are merged in
class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded,
                color: const Color(0xFFF5C842).withOpacity(0.4), size: 48),
            const SizedBox(height: 12),
            Text('$label screen\ncoming from teammates',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF8A8D99), fontSize: 13, height: 1.5)),
          ],
        ),
=======
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFFE94560),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Opportunities'),
        ],
>>>>>>> b3da45c2b1175c37879cf347d81f3230ee78d122
      ),
    );
  }
}