import 'package:flutter/material.dart';
import '../../../models/student_model.dart';
import '../main_widgets/bottom_nav_bar.dart';
import '../main_widgets/profile_card.dart';
import '../main_widgets/student_quick_actions_card.dart';
import '../main_widgets/recent_alerts_card.dart';
import '../main_widgets/status_today_card.dart';
import '../main_widgets/this_month_card.dart';
import '../progress_module/screens/progress_screen.dart';
import '../chat_module/screens/chat_screen.dart';
import '../announcement_module/screens/announcement_screen.dart';
import '../account_module/screens/student_account_screen.dart';
import 'package:tkd/services/api_service.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  //for routing
  static const List<Widget> _screens = [
    _HomeBody(),
    ProgressScreen(),
    ChatScreen(),
    AnnouncementScreen(),
    AccountScreen(),
  ];
  
  //for appbar title
  static const List<String> _titles = [
    'Home',
    'progress',
    'Messages',
    'Announcements',
    'Account',
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
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// Home tab content (extracted as separate widget)
class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  Student? _student;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await ApiService.getStudentProfile();
    if (data != null) {
      setState(() {
        _student = Student.fromJson(data);
        _isLoading = false;
      });
    } else {
      setState(() {
        _student = sampleStudent;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final student = _student!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Welcome! ${student.name.split(' ').first}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ProfileCard(student: student),
          const SizedBox(height: 16),
          StatusTodayCard(checkInTime: student.checkInTime),
          const SizedBox(height: 16),
          const StudentQuickActionsCard(),
          const SizedBox(height: 16),
          ThisMonthCard(student: student),
          const SizedBox(height: 16),
          RecentAlertsCard(alerts: student.alerts),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
