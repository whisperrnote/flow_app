import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const WhisperrFlowApp());
}

class WhisperrFlowApp extends StatelessWidget {
  const WhisperrFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhisperrFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LandingScreen(),
    );
  }
}
