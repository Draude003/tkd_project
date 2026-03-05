import 'package:flutter/material.dart';
import 'package:tkd/features/account/screens/parent_account_screen.dart';
import '../../../models/parent_model.dart';
import '../widgets/child_card.dart';
import '../../chat/screens/chat_screen.dart';
import '../../alert/screens/alert_screen.dart';
import '../../childprofile/screens/child_profile_screen.dart';
import '../../../models/child_profile_model.dart';
import '../widgets/parent_quick_actions.dart';
import '../widgets/parent_recent_alerts.dart';
import '../widgets/parent_bottom_nav_bar.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  static const List<Widget> _screens = [
    _HomeBody(),
    ChatScreen(),
    AlertScreen(),
    ParentAccountScreen(),
  ];

  static const List<String> _titles = [
    'Parent Portal',
    'Messages',
    'Alerts',
    'Account',
  ];

  bool get _showBackButton => _currentIndex != 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => setState(() => _currentIndex = 0),
              )
            : null,
        automaticallyImplyLeading: false,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: ParentBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ── Home Tab ──────────────────────────────────────────────────────────────────
class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final parent = sampleParent;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Good morning, ${parent.name}',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
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
                // ── Navigate to ChildProfileScreen ──
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChildProfileScreen(child: sampleChildProfile),
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
    );
  }
}

