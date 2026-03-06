import 'package:flutter/material.dart';
import '../../../models/instructor_report_model.dart';

class StudentTab extends StatelessWidget {
  final StudentReportModel data;
  const StudentTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Performers ───────────────────────────────────────
          const Text(
            'Top Performers',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              children: data.topPerformers
                  .asMap()
                  .entries
                  .map(
                    (e) => _TopPerformerRow(
                      performer: e.value,
                      isLast: e.key == data.topPerformers.length - 1,
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),

          // ── Alerts ───────────────────────────────────────────────
          const Text(
            'Alerts',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 10),

          ...data.alerts.map((a) => _StudentAlertCard(alert: a)),
        ],
      ),
    );
  }
}

// ── Top Performer Row ─────────────────────────────────────────────────────────
class _TopPerformerRow extends StatelessWidget {
  final TopPerformerModel performer;
  final bool isLast;
  const _TopPerformerRow({required this.performer, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '#${performer.rank}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: const Center(
                  child: Text('🥋', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 10),

              // Name + belt
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      performer.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                    Text(
                      performer.belt,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              // Score
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFB300),
                    size: 16,
                  ),
                  Text(
                    performer.score.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 14,
            endIndent: 14,
            color: Color(0xFFF0F0F0),
          ),
      ],
    );
  }
}

// ── Student Alert Card ────────────────────────────────────────────────────────
class _StudentAlertCard extends StatelessWidget {
  final StudentAlertModel alert;
  const _StudentAlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Center(
              child: Text('🥋', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),

          // Name + alert label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111),
                  ),
                ),
                Text(
                  alert.alertLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: alert.alertColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Percentage
          Text(
            alert.value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
        ],
      ),
    );
  }
}
