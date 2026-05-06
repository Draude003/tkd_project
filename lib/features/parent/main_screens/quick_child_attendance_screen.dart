import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';

class QuickChildAttendanceScreen extends StatefulWidget {
  final int childId;

  const QuickChildAttendanceScreen({super.key, required this.childId});

  @override
  State<QuickChildAttendanceScreen> createState() => _QuickChildAttendanceScreenState();
}

class _QuickChildAttendanceScreenState extends State<QuickChildAttendanceScreen> {
  List<dynamic> _children = [];
  Map<String, dynamic>? _selectedChild;
  bool _loadingChildren = true;

  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Present', 'Absent', 'Late'];
  bool _loadingAttendance = false;
  List<Map<String, dynamic>> _allRecords = [];
  int _presentCount = 0;
  int _absentCount = 0;
  int _lateCount = 0;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final profile = await ApiService.getParentProfile();
    if (profile != null && profile['children'] != null) {
      final children = profile['children'] as List;
      setState(() {
        _children = children;
        _selectedChild = children.isNotEmpty
            ? Map<String, dynamic>.from(children.first)
            : null;
        _loadingChildren = false;
      });
      if (_selectedChild != null) {
        _loadAttendance(_selectedChild!['id'] as int);
      }
    } else {
      setState(() => _loadingChildren = false);
    }
  }

  Future<void> _loadAttendance(int childId) async {
    setState(() => _loadingAttendance = true);
    final data = await ApiService.getChildAttendance(childId);
    if (data != null) {
      final records = (data['records'] as List)
          .map((r) => Map<String, dynamic>.from(r))
          .toList();
      setState(() {
        _allRecords = records;
        _presentCount = data['summary']['present'] ?? 0;
        _absentCount = data['summary']['absent'] ?? 0;
        _lateCount = data['summary']['late'] ?? 0;
        _loadingAttendance = false;
      });
    } else {
      setState(() => _loadingAttendance = false);
    }
  }

  List<Map<String, dynamic>> get _filteredRecords {
    if (_selectedFilter == 0) return _allRecords;
    final label = _filters[_selectedFilter];
    return _allRecords.where((r) => r['status'] == label).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: const Text(
          'Attendance',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: _loadingChildren
          ? const Center(child: CircularProgressIndicator())
          : _children.isEmpty
              ? const Center(child: Text('No children found.'))
              : Column(
                  children: [
                    // Child Selector
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedChild?['id'] as int?,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: _children.map<DropdownMenuItem<int>>((c) {
                            return DropdownMenuItem<int>(
                              value: c['id'] as int,
                              child: Row(
                                children: [
                                  const Text('🥋',
                                      style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 10),
                                  Text(
                                    c['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (id) {
                            final child =
                                _children.firstWhere((c) => c['id'] == id);
                            setState(() {
                              _selectedChild =
                                  Map<String, dynamic>.from(child);
                              _selectedFilter = 0;
                            });
                            _loadAttendance(id!);
                          },
                        ),
                      ),
                    ),

                    // Attendance Content
                    Expanded(
                      child: _loadingAttendance
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Summary
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    iconColor: const Color(
                                                        0xFF22C55E),
                                                    borderColor: const Color(
                                                        0xFFBBF7D0))),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: _summaryCard(
                                                    count: _absentCount,
                                                    label: 'ABSENT',
                                                    icon: Icons.cancel,
                                                    iconColor: const Color(
                                                        0xFFEF4444),
                                                    borderColor: const Color(
                                                        0xFFFECACA))),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: _summaryCard(
                                                    count: _lateCount,
                                                    label: 'LATE',
                                                    icon:
                                                        Icons.timer_outlined,
                                                    iconColor: const Color(
                                                        0xFFF59E0B),
                                                    borderColor: const Color(
                                                        0xFFFDE68A))),
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
                                      children: List.generate(
                                          _filters.length, (i) {
                                        final selected = _selectedFilter == i;
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  i < _filters.length - 1
                                                      ? 8
                                                      : 0),
                                          child: GestureDetector(
                                            onTap: () => setState(
                                                () => _selectedFilter = i),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                color: selected
                                                    ? const Color(0xFF1C1C1E)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 4,
                                                    offset:
                                                        const Offset(0, 1),
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
                                                  color: selected
                                                      ? Colors.white
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // History
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.list_alt,
                                                color: Color(0xFF1C1C1E),
                                                size: 18),
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 24),
                                            child: Center(
                                              child: Text(
                                                'No records found',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 14),
                                              ),
                                            ),
                                          )
                                        else
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                _filteredRecords.length,
                                            itemBuilder: (_, i) =>
                                                _historyRow(
                                                    _filteredRecords[i]),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
    );
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
                      horizontal: 10, vertical: 4),
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
}