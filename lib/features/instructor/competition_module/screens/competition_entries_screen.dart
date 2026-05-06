import 'package:flutter/material.dart';
import '../../../../../services/api_service.dart';

class CompetitionEntriesScreen extends StatefulWidget {
  final int competitionId;
  final String competitionName;

  const CompetitionEntriesScreen({
    super.key,
    required this.competitionId,
    required this.competitionName,
  });

  @override
  State<CompetitionEntriesScreen> createState() =>
      _CompetitionEntriesScreenState();
}

class _CompetitionEntriesScreenState
    extends State<CompetitionEntriesScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getCompetitionEntries(widget.competitionId);
    setState(() {
      _data = data;
      _loading = false;
    });
  }

  Color _beltColor(String? hex) {
    if (hex == null) return Colors.grey;
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
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

  String _resultLabel(String result) {
    switch (result.toLowerCase()) {
      case 'win':
        return 'Win';
      case 'loss':
        return 'Loss';
      case 'draw':
        return 'Draw';
      case 'pending':
        return 'Pending';
      default:
        return result;
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

  void _showAddNoteDialog(Map<String, dynamic> entry) {
    final controller =
        TextEditingController(text: entry['remarks'] ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Coach Note — ${entry['first_name']} ${entry['last_name']}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Add training focus or remarks...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1C1C1E)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1C1C1E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final success = await ApiService.addCompetitionNote(
                  entry['id'] as int, controller.text.trim());
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      success ? 'Note saved!' : 'Failed to save note.'),
                  backgroundColor:
                      success ? const Color(0xFF22C55E) : Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              if (success) _load();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.competitionName,
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 16,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data == null
              ? const Center(child: Text('Failed to load entries.'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildCompetitionInfo(),
                      const SizedBox(height: 16),
                      _buildEntriesHeader(),
                      const SizedBox(height: 8),
                      ...(_data!['entries'] as List)
                          .map((e) => _buildEntryCard(e)),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCompetitionInfo() {
    final c = _data!['competition'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded,
                  color: Color(0xFFFFD700), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  c['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 13, color: Colors.white54),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  c['location'],
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 13, color: Colors.white54),
              const SizedBox(width: 4),
              Text(
                c['date'],
                style:
                    const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 12),
              Text(
                c['organizer'] ?? '',
                style:
                    const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesHeader() {
    final entries = _data!['entries'] as List;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${entries.length} Student${entries.length != 1 ? 's' : ''}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1E),
          ),
        ),
      ],
    );
  }

  Widget _buildEntryCard(Map<String, dynamic> entry) {
    final beltColor = _beltColor(entry['belt_color']);
    final medal = entry['medal'] ?? 'none';
    final result = entry['result'] ?? 'pending';

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
              CircleAvatar(
                radius: 20,
                backgroundColor: beltColor.withOpacity(0.15),
                child: Text(
                  '${entry['first_name'][0]}${entry['last_name'][0]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: beltColor == Colors.white
                        ? Colors.grey
                        : beltColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry['first_name']} ${entry['last_name']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: beltColor,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.grey.shade300),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${entry['belt_name']} Belt',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                _medalEmoji(medal),
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(Icons.sports_martial_arts,
                  entry['category'] ?? ''),
              const SizedBox(width: 8),
              _infoChip(Icons.group_outlined,
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
                  _resultLabel(result),
                  style: TextStyle(
                    fontSize: 12,
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
                  const Icon(Icons.notes_rounded,
                      size: 14, color: Colors.blue),
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
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAddNoteDialog(entry),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1C1C1E),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.edit_note_rounded, size: 16),
              label: Text(
                entry['remarks'] != null &&
                        entry['remarks'].toString().isNotEmpty
                    ? 'Edit Note'
                    : 'Add Note',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            style: TextStyle(
                fontSize: 11, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}