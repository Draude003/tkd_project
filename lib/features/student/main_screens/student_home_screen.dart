import 'package:flutter/material.dart';
import '../../../models/student_model.dart';
import '../main_widgets/student_bottom_nav_bar.dart';
import '../main_widgets/profile_card.dart';
import '../main_widgets/student_quick_actions_card.dart';
import '../main_widgets/recent_alerts_card.dart';
import '../main_widgets/status_today_card.dart';
import '../main_widgets/this_month_card.dart';
import '../progress_module/screens/progress_screen.dart';
import '../chat_module/screens/chat_screen.dart';
import '../announcement_module/screens/student_announcement_screen.dart';
import '../account_module/screens/student_account_screen.dart';
import 'package:tkd/services/api_service.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;
  int _unreadCount = 0;
  final GlobalKey<_HomeBodyState> _homeKey = GlobalKey<_HomeBodyState>();
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      _HomeBody(key: _homeKey),
      const ProgressScreen(),
      const ChatScreen(),
      const StudentAnnouncementScreen(),
      const AccountScreen(),
    ];
    _loadUnreadCount();
  }

  void _onNavTap(int index) {
    if (index == 0 && _currentIndex != 0) {
      _homeKey.currentState?.reload();
    }
    setState(() => _currentIndex = index);
    if (index == 3) {
      ApiService.markAnnouncementsRead().then((_) {
        setState(() => _unreadCount = 0);
      });
    }
  }

  Future<void> _loadUnreadCount() async {
    final count = await ApiService.getUnreadAnnouncementCount();
    if (mounted) setState(() => _unreadCount = count);
  }

  static const List<String> _titles = [
    'Home',
    'Progress',
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
      body: _screens.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        unreadCount: _unreadCount,
      ),
    );
  }
}

// ── Home Tab ──
class _HomeBody extends StatefulWidget {
  const _HomeBody({super.key});

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

  void reload() => _loadProfile();

  Future<void> _loadProfile() async {
    if (mounted) setState(() => _isLoading = true);
    final data = await ApiService.getStudentProfile();
    if (mounted) {
      setState(() {
        _student = data != null ? Student.fromJson(data) : null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_student == null) {
      return const Center(child: Text('Failed to load profile.'));
    }

    final student = _student!;

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
            StatusTodayCard(
              checkInTime: student.checkInTime,
              loginType: student.loginType,
            ),
            const SizedBox(height: 16),
            const StudentQuickActionsCard(),
            const SizedBox(height: 16),
            ThisMonthCard(student: student),
            const SizedBox(height: 16),
            RecentAlertsCard(alerts: student.alerts),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}