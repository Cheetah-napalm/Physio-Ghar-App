import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_providers.dart';
import 'dashboard_page.dart';
import 'schedule_page.dart';
import 'patient_list_page.dart';
import 'account_page.dart';

class TherapistRootScreen extends ConsumerStatefulWidget {
  const TherapistRootScreen({super.key});

  @override
  ConsumerState<TherapistRootScreen> createState() => _TherapistRootScreenState();
}

class _TherapistRootScreenState extends ConsumerState<TherapistRootScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(therapistProvider);
    final isNepali = appState.isNepali;

    final List<Widget> screens = [
      const TherapistDashboardScreen(),
      const ScheduleAvailabilityScreen(),
      const PatientListPage(),
      const AccountPage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBF8),
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEF1EE), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2F5D50),
          unselectedItemColor: const Color(0xFF8FA8A0),
          selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: isNepali ? 'ड्यासबोर्ड' : 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today),
              label: isNepali ? 'तालिका' : 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              activeIcon: const Icon(Icons.people),
              label: isNepali ? 'बिरामीहरू' : 'Patients',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: isNepali ? 'खाता' : 'Account',
            ),
          ],
        ),
      ),
    );
  }
}