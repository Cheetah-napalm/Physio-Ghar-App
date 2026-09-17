import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/therapist_root_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PhysioGharApp(),
    ),
  );
}

class PhysioGharApp extends StatelessWidget {
  const PhysioGharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhysioGhar Therapist Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const TherapistRootScreen(),
    );
  }
}