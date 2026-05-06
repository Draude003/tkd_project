import 'package:flutter/material.dart';
import '../../../../../services/api_service.dart';

class AttendanceTab extends StatefulWidget {
  final int childId;
  const AttendanceTab({super.key, required this.childId});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  String _selectedFilter = 'All';
  static const _filters = ['All', 'Present', 'Absent', 'Late'];

  bool _loading = true;
  List<Map<String, dynamic>> _allRecords = [];
  int _presentCount = 0;
  int _absentCount = 0;
  int _lateCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getChildAttendance(widget.childId);
    if (data != null) {
      final records = (data['records'] as List)
          .map((r) => Map<String, dynamic>.from(r))
          .toList();
      setState(() {
        _allRecords = records;
        _presentCount = data['summary']['present'] ?? 0;
        _absentCount = data['summary']['absent'] ?? 0;
        _lateCount = data['summary']['late'] ?? 0;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 'All') return _allRecords;
    return _allRecords
        .where((r) => r['status'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        // Filter Tabs
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
                        horizontal: 16, vertical: 7),
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

        // Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
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
                        children: _filtered.asMap().entries.map((entry) {
                          final i = entry.key;
                          final record = entry.value;
                          final status = record['status'] ?? 'Present';
                          final isPresent = status == 'Present';
                          final isAbsent = status == 'Absent';
                          final statusColor = isPresent
                              ? const Color(0xFF43A047)
                              : isAbsent
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFFFF8F00);

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: Column(
                                        children: [
                                          Text(
                                            record['day'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF111111),
                                            ),
                                          ),
                                          Text(
                                            record['month'] ?? '',
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: statusColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            record['method'] ?? '',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      record['time'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black45),
                                    ),
                                  ],
                                ),
                              ),
                              if (i < _filtered.length - 1)
                                const Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  color: Color(0xFFF0F0F0),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

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