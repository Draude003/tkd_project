import 'package:flutter/material.dart';
import '../../../models/alert_model.dart';
import 'widgets/alert_card.dart';
import 'widgets/alert_filter_tab.dart';
import 'widgets/alert_stat_card.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  String _selectedFilter = 'All';

  static const _filterTabs = ['All', 'Important', 'Event', 'General'];

  List<AlertModel> get _filtered {
    if (_selectedFilter == 'All') return sampleAlerts;

    const categoryMap = {
      'Important': AlertCategory.important,
      'Event': AlertCategory.event,
      'General': AlertCategory.general,
    };

    return sampleAlerts
        .where((a) => a.category == categoryMap[_selectedFilter])
        .toList();
  }

  int get _totalCount => sampleAlerts.length;
  int get _unreadCount => sampleAlerts.where((a) => !a.isRead).length;
  int get _thisWeekCount {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return sampleAlerts
        .where(
          (a) => a.date.isAfter(weekStart.subtract(const Duration(days: 1))),
        )
        .length;
  }

  void _openDetail(AlertModel alert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    alert.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              alert.formattedDate,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Text(
              alert.description,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Walang Scaffold at sariling header —
    // hawak na ng ParentHomeScreen ang AppBar at SafeArea
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dark Stat Cards ──────────────────────────────────────
        Container(
          color: const Color(0xFF0A0A0A),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Row(
            children: [
              AlertStatCard(value: _totalCount.toString(), label: 'TOTAL'),
              const SizedBox(width: 8),
              AlertStatCard(value: _unreadCount.toString(), label: 'UNREAD'),
              const SizedBox(width: 8),
              AlertStatCard(
                value: _thisWeekCount.toString(),
                label: 'THIS WEEK',
              ),
            ],
          ),
        ),

        // ── Filter Tabs ──────────────────────────────────────────
        Container(
          color: const Color.fromARGB(242, 242, 246, 248),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterTabs
                  .map(
                    (tab) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: AlertFilterTab(
                        label: tab,
                        isSelected: _selectedFilter == tab,
                        onTap: () => setState(() => _selectedFilter = tab),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),

        // ── Alert List ───────────────────────────────────────────
        Expanded(
          child: _filtered.isEmpty
              ? const Center(
                  child: Text(
                    'No alerts found.',
                    style: TextStyle(color: Colors.black38),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: _filtered.length,
                  itemBuilder: (_, index) => AlertCard(
                    alert: _filtered[index],
                    onViewDetails: () => _openDetail(_filtered[index]),
                  ),
                ),
        ),
      ],
    );
  }
}
