import 'package:flutter/material.dart';
import '../../../models/instructor_report_model.dart';

class TrendsTab extends StatelessWidget {
  final TrendsReportModel data;
  const TrendsTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Monthly Attendance Bar Chart ─────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Monthly Attendance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                    Text(
                      'Last 6 months',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1E88E5)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _BarChart(items: data.monthlyAttendance),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Belt Distribution ────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Belt Distribution',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 14),
                ...data.beltDistribution.map((b) => _BeltRow(belt: b)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Class Hours This Month ───────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Class Hours This Month',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: data.classHours
                      .map((c) => _ClassHoursCard(item: c))
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ── Bar Chart ─────────────────────────────────────────────────────────────────
class _BarChart extends StatelessWidget {
  final List<MonthlyAttendanceModel> items;
  const _BarChart({required this.items});

  @override
  Widget build(BuildContext context) {
    final maxPct = items.fold<int>(
      0,
      (max, e) => e.percentage > max ? e.percentage : max,
    );

    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items.map((item) {
          final barHeight = (item.percentage / maxPct) * 90;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${item.percentage}%',
                  style: const TextStyle(fontSize: 9, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Container(
                  height: barHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: item.isHighlighted
                        ? const Color(0xFF1E88E5)
                        : const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.month,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Belt Row ──────────────────────────────────────────────────────────────────
class _BeltRow extends StatelessWidget {
  final BeltDistributionModel belt;
  const _BeltRow({required this.belt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              belt.belt,
              style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: belt.percentage / 100,
                minHeight: 8,
                backgroundColor: const Color(0xFFEEEEEE),
                valueColor: AlwaysStoppedAnimation<Color>(belt.color),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${belt.students} students · ${belt.percentage}%',
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

// ── Class Hours Card ──────────────────────────────────────────────────────────
class _ClassHoursCard extends StatelessWidget {
  final ClassHoursModel item;
  const _ClassHoursCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '${item.hours}h',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.className,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
