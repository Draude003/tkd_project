import 'package:flutter/material.dart';
import '../../../../../services/api_service.dart';
import 'competition_entries_screen.dart';

class CompetitionTrackingScreen extends StatefulWidget {
  const CompetitionTrackingScreen({super.key});

  @override
  State<CompetitionTrackingScreen> createState() =>
      _CompetitionTrackingScreenState();
}

class _CompetitionTrackingScreenState
    extends State<CompetitionTrackingScreen> {
  List<dynamic> _competitions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getInstructorCompetitions();
    setState(() {
      _competitions = data;
      _loading = false;
    });
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Competition Tracking',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18,
            color: Colors.white,
            ),
        ),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _competitions.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        ..._competitions.map((c) => _buildCompetitionCard(c)),
                      ],
                    ),
            ),
    );
  }

  Widget _buildHeader() {
    final totalGold = _competitions.fold<int>(
        0, (sum, c) => sum + (int.tryParse(c['gold_count'].toString()) ?? 0));
    final totalSilver = _competitions.fold<int>(
        0, (sum, c) => sum + (int.tryParse(c['silver_count'].toString()) ?? 0));
    final totalBronze = _competitions.fold<int>(
        0, (sum, c) => sum + (int.tryParse(c['bronze_count'].toString()) ?? 0));

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
            'Overall Medal Tally',
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
              _medalStat('🥇', 'Gold', totalGold, const Color(0xFFFFD700)),
              _medalStat('🥈', 'Silver', totalSilver, const Color(0xFFC0C0C0)),
              _medalStat('🥉', 'Bronze', totalBronze, const Color(0xFFCD7F32)),
              _medalStat('🏆', 'Events', _competitions.length, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _medalStat(String emoji, String label, int count, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildCompetitionCard(Map<String, dynamic> c) {
    final levelColor = _levelColor(c['level']);
    final goldCount = int.tryParse(c['gold_count'].toString()) ?? 0;
    final silverCount = int.tryParse(c['silver_count'].toString()) ?? 0;
    final bronzeCount = int.tryParse(c['bronze_count'].toString()) ?? 0;
    final totalEntries = int.tryParse(c['total_entries'].toString()) ?? 0;
    final isUpcoming = DateTime.tryParse(c['date'])?.isAfter(DateTime.now()) ?? false;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CompetitionEntriesScreen(
            competitionId: c['id'] as int,
            competitionName: c['name'],
          ),
        ),
      ),
      child: Container(
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
                    c['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? const Color(0xFF3B82F6).withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isUpcoming ? 'Upcoming' : 'Done',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isUpcoming
                          ? const Color(0xFF3B82F6)
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    c['location'],
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
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
                  c['date'],
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    c['level'].toString().toUpperCase(),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$totalEntries Student${totalEntries != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
                Row(
                  children: [
                    if (goldCount > 0) _medalChip('🥇', goldCount),
                    if (silverCount > 0) _medalChip('🥈', silverCount),
                    if (bronzeCount > 0) _medalChip('🥉', bronzeCount),
                    if (goldCount == 0 && silverCount == 0 && bronzeCount == 0)
                      Text(
                        'No medals yet',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade400),
                      ),
                  ],
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _medalChip(String emoji, int count) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$emoji $count',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
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
                'Competitions will appear here\nonce students are enrolled.',
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