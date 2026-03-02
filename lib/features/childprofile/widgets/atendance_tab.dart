import 'package:flutter/material.dart';
import '../../../models/atendance_model.dart';

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  String _selectedFilter = 'All';
  static const _filters = ['All', 'Present', 'Absent', 'Late'];

  // ── Counts ────────────────────────────────────────────────────────────────
  int get _presentCount => sampleAttendance
      .where((r) => r.status == AttendanceStatus.present)
      .length;

  int get _absentCount =>
      sampleAttendance.where((r) => r.status == AttendanceStatus.absent).length;

  int get _lateCount =>
      sampleAttendance.where((r) => r.status == AttendanceStatus.late).length;

  // ── Filtered list ─────────────────────────────────────────────────────────
  List<AttendanceRecord> get _filtered {
    switch (_selectedFilter) {
      case 'Present':
        return sampleAttendance
            .where((r) => r.status == AttendanceStatus.present)
            .toList();
      case 'Absent':
        return sampleAttendance
            .where((r) => r.status == AttendanceStatus.absent)
            .toList();
      case 'Late':
        return sampleAttendance
            .where((r) => r.status == AttendanceStatus.late)
            .toList();
      default:
        return sampleAttendance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Filter Tabs ──────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            children: _filters.map((f) {
              final isSelected = _selectedFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1C1C1E)
                          : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // ── Scrollable Content ───────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary Section
              _SectionHeader(title: 'Summary'),
              const SizedBox(height: 10),
              Row(
                children: [
                  _SummaryCard(
                    count: _presentCount,
                    label: 'PRESENT',
                    color: const Color(0xFF43A047),
                    icon: Icons.check_circle_rounded,
                  ),
                  const SizedBox(width: 10),
                  _SummaryCard(
                    count: _absentCount,
                    label: 'ABSENT',
                    color: const Color(0xFFE53935),
                    icon: Icons.cancel_rounded,
                  ),
                  const SizedBox(width: 10),
                  _SummaryCard(
                    count: _lateCount,
                    label: 'LATE',
                    color: const Color(0xFFFF8F00),
                    icon: Icons.access_time_rounded,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Attendance History Section
              _SectionHeader(title: 'Attendance History'),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: _filtered.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No records found.',
                            style: TextStyle(color: Colors.black38),
                          ),
                        ),
                      )
                    : Column(
                        children: _filtered
                            .asMap()
                            .entries
                            .map(
                              (entry) => _AttendanceRow(
                                record: entry.value,
                                isLast: entry.key == _filtered.length - 1,
                              ),
                            )
                            .toList(),
                      ),
              ),

              const SizedBox(height: 24),

              // Download Report Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: implement download
                  },
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text(
                    'DOWNLOAD REPORT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Summary Card ──────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.count,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black45,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Attendance Row ────────────────────────────────────────────────────────────
class _AttendanceRow extends StatelessWidget {
  final AttendanceRecord record;
  final bool isLast;

  const _AttendanceRow({required this.record, this.isLast = false});

  Color get _statusColor {
    switch (record.status) {
      case AttendanceStatus.present:
        return const Color(0xFF43A047);
      case AttendanceStatus.absent:
        return const Color(0xFFE53935);
      case AttendanceStatus.late:
        return const Color(0xFFFF8F00);
    }
  }

  String get _statusLabel {
    switch (record.status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Date
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Text(
                      record.formattedDay,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111111),
                      ),
                    ),
                    Text(
                      record.formattedMonth,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Status badge + method
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.method,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              // Time
              if (record.time != null)
                Text(
                  record.time!,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Color(0xFFF0F0F0),
          ),
      ],
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111111),
          ),
        ),
      ],
    );
  }
}
