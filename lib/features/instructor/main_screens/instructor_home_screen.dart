import 'package:flutter/material.dart';
import 'package:tkd/features/instructor/announcement_module/screens/instructor_Announce_screen.dart';
import 'package:tkd/features/instructor/reports_module/screens/reports_screen.dart';
import 'package:tkd/features/instructor/account_settings_module/screens/instructor_account_screen.dart';
import 'package:tkd/features/instructor/main_screens/instructor_students_screen.dart';
import '../../../models/instructor_model.dart';
import '../main_widgets/instructor_bottom_nav_bar.dart';
import '../main_widgets/todays_classes_card.dart';
import '../main_widgets/instructor_quick_actions_card.dart';
import '../main_widgets/instructor_alerts_card.dart';
import '../main_widgets/class_stats_card.dart';
import 'package:tkd/services/api_service.dart';
import 'package:tkd/services/auth_services.dart';

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
    InstructorAnnounceScreen(),
    InstructorStudentsScreen(),
    ReportsScreen(),
  ];

  static const List<String> _titles = [
    'Instructor Dashboard',
    'Announcements',
    'Class Management',
    'Students',
    'Reports',
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
            icon: const Icon(Icons.account_circle_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InstructorAccountScreen(),
                ),
              );
            },
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

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  List<InstructorClass> _todaysClasses = [];
  String _name = 'Coach';
  bool _isLoading = true;
  int _presentCount = 0;
  int _absentCount = 0;
  int _lateCount = 0;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    final classes = await ApiService.getMyClasses();
    final name = await AuthService.getName();
    final firstName = (name ?? 'Coach').split(' ').first;

    final mapped = classes.map((cls) {
      final schedules = cls['schedules'] as List;
      final schedule = schedules.isNotEmpty ? schedules[0] : null;

      String color = 'teal';
      final level = (cls['level'] ?? '').toString().toLowerCase();
      if (level.contains('white')) color = 'orange';
      if (level.contains('red') || level.contains('black')) color = 'red';

      return InstructorClass(
        id: cls['id'] ?? 0,
        time: schedule != null
            ? '${schedule['start_time'] ?? 'TBD'} – ${schedule['end_time'] ?? ''}'
            : 'TBD',
        title: cls['class_name'] ?? 'Unknown Class',
        description: cls['level'] ?? '',
        bgColor: color,
        dayOfWeek: schedule != null ? schedule['day_of_week'] ?? '' : '',
      );
    }).toList();

    final stats = await ApiService.getAttendanceStats();

    setState(() {
      _todaysClasses = mapped;
      _name = firstName;
      _presentCount = stats['present'] ?? 0;
      _absentCount = stats['absent'] ?? 0;
      _lateCount = stats['late'] ?? 0;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadClasses,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Welcome! $_name',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 20),
            TodaysClassesCard(classes: _todaysClasses),
            const SizedBox(height: 20),
            InstructorQuickActionsCard(classes: _todaysClasses),
            const SizedBox(height: 20),
            InstructorAlertsCard(alerts: const []),
            const SizedBox(height: 20),
            ClassStatsCard(
              presentCount: _presentCount,
              absentCount: _absentCount,
              lateCount: _lateCount,
            ),
            const SizedBox(height: 16),
          ],
        ),
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