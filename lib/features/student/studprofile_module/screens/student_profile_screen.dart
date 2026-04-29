import 'package:flutter/material.dart';
import '../widgets/overview_tab.dart';
import 'package:tkd/models/student_model.dart';
import '../widgets/attendance_tab.dart';
import '../widgets/billing_tab.dart';
import '../widgets/competition_tab.dart';

class StudentProfileScreen extends StatefulWidget {
  final Student student;
  const StudentProfileScreen({super.key, required this.student});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  int _selectedTab = 0;
  final ScrollController _scrollController = ScrollController();
  final List<String> _tabs = [
    'Overview',
    'Attendance',
    'Billing',
    'Competition',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _sectionPadding({required Widget child}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: child,
  );

  Widget _card({required Widget child, EdgeInsets padding = EdgeInsets.zero}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }

  Widget _iconWidget(String icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Image.asset(icon, width: 30, height: 30)),
    );
  }

  Widget _labelText(String text) => Text(
    text,
    style: TextStyle(
      color: Colors.grey[500],
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey[100], indent: 16, endIndent: 16);

  Widget _infoRow({
    required String icon,
    required String label,
    required String value,
    required bool divider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _iconWidget(icon),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelText(label),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (divider) _divider(),
      ],
    );
  }

  Widget _beltRow(String belt) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _iconWidget('assets/icons/app_icon.png'),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelText('CURRENT BELT'),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      belt,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            backgroundColor: const Color(0xFF1C1C1E),
            leading: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                // 0.0 = fully collapsed, 1.0 = fully expanded
                final percent =
                    ((constraints.maxHeight - kToolbarHeight) /
                            (220 - kToolbarHeight))
                        .clamp(0.0, 1.0);

                // center ng screen minus half ng text width (approx 70)
                final centerLeft = (constraints.maxWidth / 2) - 70;
                // left ng collapsed — tabi ng back button
                const collapsedLeft = 56.0;

                // smooth interpolation mula collapsed → expanded
                final leftPadding =
                    collapsedLeft + (centerLeft - collapsedLeft) * percent;

                return FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: EdgeInsets.only(
                    bottom: 16,
                    left: leftPadding, // ← smooth na gumagalaw
                  ),
                  title: Text(
                    widget.student.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    color: const Color(0xFF1C1C1E),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // avatar fade out pag nag-scroll
                        Opacity(
                          opacity: percent, // ← fade out ang avatar
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/profile.png',
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Info Card
                _sectionPadding(
                  child: _card(
                    child: Column(
                      children: [
                        _infoRow(
                          icon: 'assets/icons/calendar.png',
                          label: 'AGE',
                          value: '${student.age} years old',
                          divider: true,
                        ),
                        _beltRow(student.beltLevel),
                        _infoRow(
                          icon: 'assets/icons/app_icon.png',
                          label: 'PROGRAM',
                          value: student.program,
                          divider: true,
                        ),
                        _infoRow(
                          icon: 'assets/icons/location.png',
                          label: 'BRANCH',
                          value: student.branch,
                          divider: false,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Linked Parent Card
                _sectionPadding(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD0D9FF)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/icons/linked.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LINKED PARENT',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              student.linkedParent,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1C1E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tab Bar
                _sectionPadding(
                  child: _card(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: List.generate(_tabs.length, (i) {
                        final selected = _selectedTab == i;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedTab = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF1C1C1E)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _tabs[i],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tab Content
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _selectedTab == 0
                      ? const OverviewTab(key: ValueKey('overview'))
                      : _selectedTab == 1
                      ? const AttendanceTab(key: ValueKey('attendance'))
                      : _selectedTab == 2
                      ? const SingleChildScrollView(
                          key: ValueKey('billing'),
                          child: BillingTab(),
                        )
                      : const CompetitionTab(key: ValueKey('competition')),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
