import 'package:flutter/material.dart';
import 'package:tkd/features/classes/screens/class_attendance_screen.dart';
import '../../../models/instructor_model.dart';
import '../widgets/instructor_bottom_nav_bar.dart';
import '../widgets/todays_classes_card.dart';
import '../widgets/instructor_quick_actions_card.dart';
import '../widgets/instructor_alerts_card.dart';
import '../widgets/class_stats_card.dart';

class InstructorHomeScreen extends StatefulWidget {
  const InstructorHomeScreen({super.key});

  @override
  State<InstructorHomeScreen> createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  static const List<Widget> _screens = [
    _HomeBody(),
    ClassAttendanceScreen(),
    _PlaceholderScreen(label: 'Students'),
    _PlaceholderScreen(label: 'Reports'),
    _PlaceholderScreen(label: 'Settings'),
  ];

  static const List<String> _titles = [
    'Instructor Dashboard',
    'Class Management',
    'Students',
    'Reports',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: InstructorBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final instructor = sampleInstructor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Header
          Text(
            'Welcome ${instructor.name}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 20),

          TodaysClassesCard(classes: instructor.todaysClasses),
          const SizedBox(height: 20),

          const InstructorQuickActionsCard(),
          const SizedBox(height: 20),

          InstructorAlertsCard(alerts: instructor.alerts),
          const SizedBox(height: 20),

          ClassStatsCard(
            presentCount: instructor.presentCount,
            absentCount: instructor.absentCount,
            lateCount: instructor.lateCount,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label coming soon!', style: const TextStyle(fontSize: 16)),
    );
  }
}
