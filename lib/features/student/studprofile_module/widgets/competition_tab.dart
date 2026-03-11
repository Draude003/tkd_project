import 'package:flutter/material.dart';

class CompetitionTab extends StatefulWidget {
  const CompetitionTab({super.key});

  @override
  State<CompetitionTab> createState() => _CompetitionTabState();
}

class _CompetitionTabState extends State<CompetitionTab> {
  String _selectedYear = 'All';
  final List<String> _yearFilters = ['All', '2024', '2025'];

  static const _badgeConfigs = {
    'Gold': {'color': Color(0xFFF59E0B), 'bg': Color(0xFFFEF3C7)},
    'Silver': {'color': Color(0xFF94A3B8), 'bg': Color(0xFFF1F5F9)},
    'Bronze': {'color': Color(0xFFB45309), 'bg': Color(0xFFFEF3C7)},
    'Participant': {'color': Color(0xFF6366F1), 'bg': Color(0xFFEEF2FF)},
    'Champion': {'color': Color(0xFFEF4444), 'bg': Color(0xFFFEE2E2)},
  };

  final List<Map<String, dynamic>> _allCompetitions = [
    {
      'name': 'NCR Juniors',
      'date': 'July 2025',
      'year': '2025',
      'result': 'Silver',
    },
    {
      'name': 'Club Meet',
      'date': 'March 2025',
      'year': '2025',
      'result': 'Gold',
    },
    {
      'name': 'National Kids',
      'date': 'August 2024',
      'year': '2024',
      'result': 'Participant',
    },
    {
      'name': 'City Open',
      'date': 'May 2024',
      'year': '2024',
      'result': 'Bronze',
    },
    {
      'name': 'Regional Cup',
      'date': 'January 2024',
      'year': '2024',
      'result': 'Champion',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedYear == 'All') return _allCompetitions;
    return _allCompetitions.where((c) => c['year'] == _selectedYear).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year Filter Chips
          Row(
            children: _yearFilters.map((year) {
              final selected = _selectedYear == year;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedYear = year),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF1C1C1E) : Colors.white,
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
                      year,
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
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Competition List
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
            child: _filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No competitions found',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ),
                  )
                : Column(
                    children: _filtered.asMap().entries.map((entry) {
                      final i = entry.key;
                      final comp = entry.value;
                      final result = comp['result'] as String;
                      final config =
                          _badgeConfigs[result] ??
                          {
                            'color': const Color(0xFF6B7280),
                            'bg': const Color(0xFFF3F4F6),
                          };
                      final badgeColor = config['color'] as Color;
                      final badgeBg = config['bg'] as Color;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comp['name'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1C1C1E),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        comp['date'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: badgeColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    result,
                                    style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i < _filtered.length - 1)
                            Divider(
                              height: 1,
                              color: Colors.grey[100],
                              indent: 16,
                              endIndent: 16,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 24),

          // View Certificate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening certificate...'),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1C1E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'VIEW CERTIFICATE',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
