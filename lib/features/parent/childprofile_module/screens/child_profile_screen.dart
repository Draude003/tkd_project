import 'package:flutter/material.dart';
import '../../../../models/child_profile_model.dart';
import '../../../../services/api_service.dart';
import '../widgets/child_profile_info_card.dart';
import '../widgets/child_profile_stat_card.dart';
import '../widgets/child_profile_skill_bar.dart';
import '../widgets/atendance_tab.dart';
import '../widgets/billing_tab.dart';
import '../widgets/compitition_tab.dart';
import '../widgets/certificates_tab.dart';
import '../widgets/notes_tab.dart';

class ChildProfileScreen extends StatefulWidget {
  final int childId;

  const ChildProfileScreen({super.key, required this.childId});

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ChildProfileModel? _child;
  bool _isLoading = true;

  static const _tabs = [
    'Overview', 'Attendance', 'Billing',
    'Competition', 'Certificates', 'Notes',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadChild();
  }

  Future<void> _loadChild() async {
    final data = await ApiService.getChildProfile(widget.childId);
    if (mounted) {
      setState(() {
        _child = data != null ? ChildProfileModel.fromJson(data) : null;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_child == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load child profile')),
      );
    }

    final s = _child!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Child Profile',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
                        ),
                        child: const Center(
                          child: Text('🥋', style: TextStyle(fontSize: 36)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        s.name,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111111)),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: ChildProfileInfoCard(label: 'AGE', value: s.age)),
                          const SizedBox(width: 10),
                          Expanded(child: ChildProfileInfoCard(label: 'BELT', value: s.belt)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ChildProfileInfoCard(label: 'INSTRUCTOR', value: s.instructor, fullWidth: true),
                      const SizedBox(height: 10),
                      ChildProfileInfoCard(label: 'CLASS SCHEDULE', value: s.classSchedule, fullWidth: true),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black45,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.black, width: 2.5),
                ),
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _OverviewTab(child: s),
            const AttendanceTab(),
            const BillingTab(),
            const ParentCompetitionTab(),
            const CertificatesTab(),
            const NotesTab(),
          ],
        ),
      ),
    );
  }
}

// ── Overview Tab ──
class _OverviewTab extends StatelessWidget {
  final ChildProfileModel child;
  const _OverviewTab({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(title: 'Performance Overview'),
          const SizedBox(height: 12),
          Row(
            children: [
              ChildProfileStatCard(
                value: '${child.attendancePercentage.toInt()}%',
                label: 'Attendance',
                icon: Icons.calendar_today_rounded,
              ),
              const SizedBox(width: 10),
              ChildProfileStatCard(
                value: '${child.monthsTraining}',
                label: 'Months',
                icon: Icons.bar_chart_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ChildProfileStatCard(
                value: '${child.classesPerWeek}',
                label: 'Classes/Week',
                icon: Icons.fitness_center_rounded,
              ),
              const SizedBox(width: 10),
              ChildProfileStatCard(
                value: '${child.awardsCount}',
                label: 'Awards',
                icon: Icons.emoji_events_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Training Information'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              children: [
                _TrainingRow(label: 'Member Since', value: child.memberSince),
                _TrainingRow(label: 'Current Belt', value: child.belt),
                _TrainingRow(label: 'Next Belt Test', value: child.nextBeltTest),
                _TrainingRow(
                  label: 'Classes Per Week',
                  value: '${child.classesPerWeek} sessions',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Skill Progress'),
          const SizedBox(height: 12),
          if (child.skills.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bar_chart_rounded, size: 20),
                      SizedBox(width: 6),
                      Text('Skill Progress', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...child.skills.map((skill) => ChildProfileSkillBar(
                    skillName: skill.name,
                    percentage: skill.percentage,
                  )),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Center(
                child: Text('No skill data available', style: TextStyle(color: Colors.grey)),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Training Row ──
class _TrainingRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _TrainingRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF999999))),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111111))),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

// ── Section Title ──
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF111111))),
      ],
    );
  }
}

// ── Tab Bar Delegate ──
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}