import 'package:flutter/material.dart';

import 'features/community/init.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AluConnectApp());
}

class AluConnectApp extends StatelessWidget {
  const AluConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect+',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const CommunitiesHubScreen(),
    );
  }
}
