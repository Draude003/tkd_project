import 'package:flutter/material.dart';
import 'package:tkd/features/student/account_module/screens/parent_account_screen.dart';
import '../../../models/parent_model.dart';
import '../main_widgets/child_card.dart';
import '../../student/chat_module/screens/chat_screen.dart';
import '../announcement_module/screens/parent_announcement_screen.dart';
import '../childprofile_module/screens/child_profile_screen.dart';
import '../main_widgets/parent_quick_actions.dart';
import '../main_widgets/parent_recent_alerts.dart';
import '../main_widgets/parent_bottom_nav_bar.dart';
import '../../../services/api_service.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int _currentIndex = 0;
  int _unreadCount = 0;

   @override
  void initState() {
    super.initState();
    _loadUnreadCount(); // <-- dagdag
  }

  Future<void> _loadUnreadCount() async {
    final count = await ApiService.getUnreadAnnouncementCount();
    if (mounted) setState(() => _unreadCount = count);
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    if (index == 2) {
      ApiService.markAnnouncementsRead().then((_) {
        setState(() => _unreadCount = 0);
      });
    }
  }

  static const List<String> _titles = [
    'Parent Portal',
    'Messages',
    'Announcements',
    'Account',
  ];

  bool get _showBackButton => _currentIndex != 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _showBackButton
            ? IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                onPressed: () => setState(() => _currentIndex = 0),
              )
            : null,
        automaticallyImplyLeading: false,
        title: Text(_titles[_currentIndex], style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeBody(),
          ChatScreen(),
          ParentAnnouncementScreen(),
          ParentAccountScreen(),
        ],
      ),
      bottomNavigationBar: ParentBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        unreadCount: _unreadCount,
      ),
    );
  }
}

// ── Home Tab ──
class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  ParentUser? _parent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await ApiService.getParentProfile();
    if (mounted) {
      setState(() {
        _parent = data != null ? ParentUser.fromJson(data) : null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_parent == null) {
      return const Center(child: Text('Failed to load profile'));
    }

    final parent = _parent!;

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
              'Good morning, ${parent.name}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // My Children
            Row(
              children: [
                Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
                const SizedBox(width: 8),
                const Text(
                  'My Children',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...parent.children.map(
              (child) => ChildCard(
                child: child,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChildProfileScreen(childId: child.id),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            const ParentQuickActionsCard(),
            const SizedBox(height: 16),
            ParentRecentAlerts(alerts: parent.alerts),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}