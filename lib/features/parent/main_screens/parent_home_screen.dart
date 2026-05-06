import 'package:flutter/material.dart';
import 'package:tkd/features/parent/account_module/screens/parent_account_screen.dart';
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
    _loadUnreadCount();
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
                icon: const Icon(Icons.chevron_left,
                    color: Colors.white, size: 28),
                onPressed: () => setState(() => _currentIndex = 0),
              )
            : null,
        automaticallyImplyLeading: false,
        title: Text(_titles[_currentIndex],
            style: const TextStyle(color: Colors.white)),
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
              'Good morning, ${parent.name.split(' ').first}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 20),

            // My Children Header
            Row(
              children: [
                Container(
                    width: 4, height: 18, color: const Color(0xFF1C1C1E)),
                const SizedBox(width: 8),
                const Text(
                  'My Children',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${parent.children.length} child${parent.children.length != 1 ? 'ren' : ''}',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Children Cards
            if (parent.children.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.child_care, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No children found',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            else if (parent.children.length == 1)
              ChildCard(
                child: parent.children.first,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChildProfileScreen(
                        childId: parent.children.first.id),
                  ),
                ),
              )
            else
              _ChildrenPageView(
                children: parent.children,
                onTap: (child) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChildProfileScreen(childId: child.id),
                  ),
                ),
              ),

            const SizedBox(height: 20),
            const ParentQuickActionsCard(),
            const SizedBox(height: 20),
            ParentRecentAlerts(alerts: parent.alerts),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Children PageView ──
class _ChildrenPageView extends StatefulWidget {
  final List<ChildInfo> children;
  final void Function(ChildInfo) onTap;

  const _ChildrenPageView({required this.children, required this.onTap});

  @override
  State<_ChildrenPageView> createState() => _ChildrenPageViewState();
}

class _ChildrenPageViewState extends State<_ChildrenPageView> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 205,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.children.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChildCard(
                child: widget.children[i],
                onTap: () => widget.onTap(widget.children[i]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.children.length, (i) {
            final isActive = i == _current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF1C1C1E)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}