import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';

class StudentCompetitionScreen extends StatefulWidget {
  const StudentCompetitionScreen({super.key});

  @override
  State<StudentCompetitionScreen> createState() =>
      _StudentCompetitionScreenState();
}

class _StudentCompetitionScreenState extends State<StudentCompetitionScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getStudentCompetitions();
    setState(() {
      _data = data;
      _loading = false;
    });
  }

  Color _medalColor(String medal) {
    switch (medal.toLowerCase()) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'bronze':
        return const Color(0xFFCD7F32);
      default:
        return Colors.grey.shade300;
    }
  }

  String _medalEmoji(String medal) {
    switch (medal.toLowerCase()) {
      case 'gold':
        return '🥇';
      case 'silver':
        return '🥈';
      case 'bronze':
        return '🥉';
      default:
        return '—';
    }
  }

  Color _resultColor(String result) {
    switch (result.toLowerCase()) {
      case 'win':
        return const Color(0xFF22C55E);
      case 'loss':
        return const Color(0xFFEF4444);
      case 'draw':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'local':
        return const Color(0xFF3B82F6);
      case 'regional':
        return const Color(0xFF8B5CF6);
      case 'national':
        return const Color(0xFFF59E0B);
      case 'international':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        title: const Text(
          'My Competitions',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data == null
              ? const Center(child: Text('Failed to load competitions.'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: (_data!['entries'] as List).isEmpty
                      ? _buildEmptyState()
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _buildStatsCard(),
                            const SizedBox(height: 16),
                            const Text(
                              'Competition History',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1C1C1E),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...(_data!['entries'] as List)
                                .map((e) => _buildEntryCard(e)),
                          ],
                        ),
                ),
    );
  }

  Widget _buildStatsCard() {
    final stats = _data!['stats'] as Map<String, dynamic>;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Medal Tally',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('🥇', 'Gold', stats['gold'] as int),
              _statItem('🥈', 'Silver', stats['silver'] as int),
              _statItem('🥉', 'Bronze', stats['bronze'] as int),
              _statItem('🏆', 'Total', stats['total'] as int),
              _statItem('✅', 'Wins', stats['wins'] as int),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String emoji, String label, int count) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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

  Widget _buildEntryCard(Map<String, dynamic> entry) {
    final medal = entry['medal'] ?? 'none';
    final result = entry['result'] ?? 'pending';
    final levelColor = _levelColor(entry['level'] ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry['competition_name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              ),
              Text(
                _medalEmoji(medal),
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  entry['location'] ?? '',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                entry['date'] ?? '',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  (entry['level'] ?? '').toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: levelColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip(Icons.sports_martial_arts, entry['category'] ?? ''),
              const SizedBox(width: 8),
              _chip(Icons.group_outlined,
                  'Div ${entry['division'] ?? ''}'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _resultColor(result).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  result.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _resultColor(result),
                  ),
                ),
              ),
            ],
          ),
          if (entry['remarks'] != null &&
              entry['remarks'].toString().isNotEmpty) ...[
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
                      entry['remarks'],
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
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events_outlined,
                  size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text(
                'No Competitions Yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C1E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your competition history\nwill appear here.',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}