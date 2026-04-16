import 'package:flutter/material.dart';
import 'package:tkd/services/api_service.dart';

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Present', 'Absent', 'Late'];

  bool _isLoading = true;
  List<Map<String, dynamic>> _allRecords = [];
  int _presentCount = 0;
  int _absentCount = 0;
  int _lateCount = 0;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final data = await ApiService.getStudentAttendance();
    if (data != null) {
      final records = (data['records'] as List)
          .map((r) => Map<String, dynamic>.from(r))
          .toList();
      setState(() {
        _allRecords = records;
        _presentCount = data['summary']['present'] ?? 0;
        _absentCount = data['summary']['absent'] ?? 0;
        _lateCount = data['summary']['late'] ?? 0;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredRecords {
    if (_selectedFilter == 0) return _allRecords;
    final label = _filters[_selectedFilter];
    return _allRecords.where((r) => r['status'] == label).toList();
  }

  Widget _summaryCard({
    required int count,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyRow(Map<String, dynamic> record) {
    final isPresent = record['status'] == 'Present';
    final isAbsent = record['status'] == 'Absent';
    final statusColor = isPresent
        ? const Color(0xFF22C55E)
        : isAbsent
        ? const Color(0xFFEF4444)
        : const Color(0xFFF59E0B);
    final statusBg = isPresent
        ? const Color(0xFFDCFCE7)
        : isAbsent
        ? const Color(0xFFFEE2E2)
        : const Color(0xFFFEF3C7);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['day'],
                  style: const TextStyle(
                    color: Color(0xFF1C1C1E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  record['month'],
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPresent
                            ? Icons.check_circle
                            : isAbsent
                            ? Icons.cancel
                            : Icons.timer_outlined,
                        color: statusColor,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        record['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  record['method'],
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            record['time'],
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Card
          Container(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        count: _presentCount,
                        label: 'PRESENT',
                        icon: Icons.check_circle,
                        iconColor: const Color(0xFF22C55E),
                        borderColor: const Color(0xFFBBF7D0),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _summaryCard(
                        count: _absentCount,
                        label: 'ABSENT',
                        icon: Icons.cancel,
                        iconColor: const Color(0xFFEF4444),
                        borderColor: const Color(0xFFFECACA),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _summaryCard(
                        count: _lateCount,
                        label: 'LATE',
                        icon: Icons.timer_outlined,
                        iconColor: const Color(0xFFF59E0B),
                        borderColor: const Color(0xFFFDE68A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (i) {
                final selected = _selectedFilter == i;
                return Padding(
                  padding: EdgeInsets.only(
                    right: i < _filters.length - 1 ? 8 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF1C1C1E)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Attendance History
          Container(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.list_alt, color: Color(0xFF1C1C1E), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Attendance History',
                      style: TextStyle(
                        color: Color(0xFF1C1C1E),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_filteredRecords.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No records found',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredRecords.length,
                    itemBuilder: (_, i) => _historyRow(_filteredRecords[i]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Download Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Downloading report...'),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
              icon: const Icon(Icons.download, size: 18),
              label: const Text(
                'DOWNLOAD REPORT',
                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1C1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
