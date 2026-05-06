import 'package:flutter/material.dart';
import '../../../../../services/api_service.dart';

class ParentCompetitionTab extends StatefulWidget {
  final int childId;
  const ParentCompetitionTab({super.key, required this.childId});

  @override
  State<ParentCompetitionTab> createState() => _ParentCompetitionTabState();
}

class _ParentCompetitionTabState extends State<ParentCompetitionTab> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String _selectedYear = 'All';
  List<String> _yearFilters = ['All'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getChildCompetitions(widget.childId);
    if (data != null) {
      final entries = data['entries'] as List;
      final years = entries
          .map((e) => e['date']?.toString().substring(0, 4) ?? '')
          .where((y) => y.isNotEmpty)
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));
      setState(() {
        _data = data;
        _yearFilters = ['All', ...years];
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  List<dynamic> get _filtered {
    if (_data == null) return [];
    final entries = _data!['entries'] as List;
    if (_selectedYear == 'All') return entries;
    return entries
        .where((e) => (e['date']?.toString() ?? '').startsWith(_selectedYear))
        .toList();
  }

  Color _medalColor(String medal) {
    switch (medal.toLowerCase()) {
      case 'gold': return const Color(0xFFF59E0B);
      case 'silver': return const Color(0xFF94A3B8);
      case 'bronze': return const Color(0xFFB45309);
      default: return const Color(0xFF6366F1);
    }
  }

  Color _medalBg(String medal) {
    switch (medal.toLowerCase()) {
      case 'gold': return const Color(0xFFFEF3C7);
      case 'silver': return const Color(0xFFF1F5F9);
      case 'bronze': return const Color(0xFFFEF3C7);
      default: return const Color(0xFFEEF2FF);
    }
  }

  String _medalEmoji(String medal) {
    switch (medal.toLowerCase()) {
      case 'gold': return '🥇';
      case 'silver': return '🥈';
      case 'bronze': return '🥉';
      default: return '🏅';
    }
  }

  Color _resultColor(String result) {
    switch (result.toLowerCase()) {
      case 'win': return const Color(0xFF22C55E);
      case 'loss': return const Color(0xFFEF4444);
      case 'draw': return const Color(0xFFF59E0B);
      default: return Colors.grey;
    }
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'local': return const Color(0xFF3B82F6);
      case 'regional': return const Color(0xFF8B5CF6);
      case 'national': return const Color(0xFFF59E0B);
      case 'international': return const Color(0xFFEF4444);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_data == null) return const Center(child: Text('Failed to load competitions.'));

    final stats = _data!['stats'] as Map<String, dynamic>;
    final filtered = _filtered;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('🥇', 'Gold', stats['gold'] as int),
                _statItem('🥈', 'Silver', stats['silver'] as int),
                _statItem('🥉', 'Bronze', stats['bronze'] as int),
                _statItem('🏆', 'Total', stats['total'] as int),
                _statItem('✅', 'Wins', stats['wins'] as int),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Year Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _yearFilters.map((year) {
                final selected = _selectedYear == year;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedYear = year),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Competition List
          filtered.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.emoji_events_outlined,
                          size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        'No competitions found',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: filtered.map((comp) {
                    final medal = comp['medal'] ?? 'none';
                    final result = comp['result'] ?? 'pending';
                    final level = comp['level'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comp['competition_name'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1C1C1E),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_outlined,
                                              size: 11, color: Colors.grey.shade500),
                                          const SizedBox(width: 4),
                                          Text(
                                            comp['date'] ?? '',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: _levelColor(level).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              level.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: _levelColor(level),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(_medalEmoji(medal),
                                    style: const TextStyle(fontSize: 26)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _medalBg(medal),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: _medalColor(medal).withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    medal.toUpperCase(),
                                    style: TextStyle(
                                      color: _medalColor(medal),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _resultColor(result).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    result.toUpperCase(),
                                    style: TextStyle(
                                      color: _resultColor(result),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    comp['category'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (comp['remarks'] != null &&
                                comp['remarks'].toString().isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.sports_martial_arts,
                                        size: 14, color: Color(0xFF1C1C1E)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        comp['remarks'],
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statItem(String emoji, String label, int count) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }
}