import 'package:flutter/material.dart';
import '/models/competition_model.dart';

class CompetitionTab extends StatelessWidget {
  const CompetitionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Section Header ───────────────────────────────────────
        const Row(
          children: [
            SizedBox(
              child: Icon(
                Icons.emoji_events_rounded,
                size: 20,
                color: Color(0xFF111111),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Competition History',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Competition List ─────────────────────────────────────
        ...sampleCompetitions.map(
          (competition) => _CompetitionCard(competition: competition),
        ),
      ],
    );
  }
}

// ── Competition Card ──────────────────────────────────────────────────────────
class _CompetitionCard extends StatelessWidget {
  final CompetitionModel competition;

  const _CompetitionCard({required this.competition});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Medal icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: competition.resultColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                competition.medalEmoji,
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Title + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${competition.title} — ${competition.resultLabel}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  competition.date,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
