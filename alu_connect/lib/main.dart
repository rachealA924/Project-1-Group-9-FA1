import 'package:flutter/material.dart';
import 'package:alu_connect/features/home/splash_screen.dart';
import 'package:alu_connect/features/home/home_screen.dart';
import 'package:alu_connect/features/home/messages_screen.dart';
import 'package:alu_connect/features/home/profile_screen.dart';
import 'package:alu_connect/features/home/user_session.dart';
import 'package:alu_connect/features/home/app_router.dart';
import 'features/opportunities/opportunities_feed_screen.dart';
import 'features/community/screens/communities_hub_screen.dart';
import 'features/events/screens/event_discovery.dart';

void main() => runApp(ALUConnectApp());

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect+',
      debugShowCheckedModeBanner: false,
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
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  // FIX 1: jumpTo now has its closing brace
  static void jumpTo(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationState>();
    state?.jumpTo(index);
  } // ← was missing

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;
  final _session = UserSession();

  // FIX 2: initState applies initialIndex so login always lands on Home
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // FIX 3: jumpTo method added to state so static call works
  void jumpTo(int index) => setState(() => _currentIndex = index);

  // FIX 4: HomeScreen is index 0, teammates' screens at 1 and 2
  final List<Widget> _screens = [
    HomeScreen(),                 // 0 - Home
    EventDiscoveryScreen(),       // 1 - Discover
    CommunitiesHubScreen(),       // 2 - People
    OpportunitiesFeedScreen(),    // 3 - Opportunities (see all from home)
    MessagesScreen(),             // 4 - Messages
    ProfileScreen(),              // 5 - Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0F14),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
        ),
        child: ListenableBuilder(
          listenable: _session,
          builder: (_, __) => BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) {
              if (i == 4) _session.markMessagesRead();
              setState(() => _currentIndex = i);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFF5C842),
            unselectedItemColor: const Color(0xFF8A8D99),
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                label: 'Discover',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_rounded),
                label: 'People',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.work_outline_rounded),
                label: 'Opportunities',
              ),
              // Messages with unread badge
              BottomNavigationBarItem(
                icon: Stack(clipBehavior: Clip.none, children: [
                  const Icon(Icons.chat_bubble_outline_rounded),
                  if (_session.unreadMessages > 0)
                    Positioned(
                      top: -4, right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5C842),
                          shape: BoxShape.circle,
                        ),
                        child: Text('${_session.unreadMessages}',
                          style: const TextStyle(
                            color: Color(0xFF0D0F14),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          )),
                      ),
                    ),
                ]),
                label: 'Messages',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}