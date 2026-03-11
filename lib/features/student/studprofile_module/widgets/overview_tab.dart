import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  Widget _card({required Widget child, EdgeInsets padding = EdgeInsets.zero}) {
    return Container(
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
      padding: padding,
      child: child,
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey[100], indent: 16, endIndent: 16);

  Widget _statCard(String value, String label, Color bg, Color fg) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: fg.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _achievementRow({
    required String title,
    required String subtitle,
    required bool divider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1C1C1E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (divider) _divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('overview'),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: [
              _statCard(
                '47',
                'Total Classes',
                const Color(0xFFEFF6FF),
                const Color(0xFF3B82F6),
              ),
              _statCard(
                '94%',
                'Attendance Rate',
                const Color(0xFFF0FDF4),
                const Color(0xFF22C55E),
              ),
              _statCard(
                '8',
                'Months training',
                const Color(0xFFFFFBEB),
                const Color(0xFFF59E0B),
              ),
              _statCard(
                '3',
                'Tournaments',
                const Color(0xFFFDF4FF),
                const Color(0xFFA855F7),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Text('🏆', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text(
                'Recent Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _card(
            child: Column(
              children: [
                _achievementRow(
                  title: 'Green Belt Promotion',
                  subtitle: 'Awarded on July 15, 2024',
                  divider: true,
                ),
                _achievementRow(
                  title: 'Bronze Medal – Sparring',
                  subtitle: 'City Championship, June 2024',
                  divider: true,
                ),
                _achievementRow(
                  title: 'Perfect Attendance Award',
                  subtitle: 'May 2024',
                  divider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
