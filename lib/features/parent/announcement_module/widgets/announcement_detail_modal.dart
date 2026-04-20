import 'package:flutter/material.dart';
import '../../../../models/parent_announce_model.dart';

class AnnouncementDetailModal extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetailModal({super.key, required this.announcement});

  static void show(BuildContext context, Announcement announcement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AnnouncementDetailModal(announcement: announcement),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasEventInfo =
        announcement.eventTime.isNotEmpty ||
        announcement.location.isNotEmpty ||
        announcement.fee.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  announcement.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 11,
                      color: Colors.white38,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      announcement.date,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                    if (announcement.sentAt.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: Colors.white38,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        announcement.sentAt,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Details card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  announcement.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1C1C1E),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // Event Information card
          if (hasEventInfo) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Event Information',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (announcement.eventDate.isNotEmpty)
                    _InfoRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'DATE',
                      value: announcement.eventDate,
                    ),
                  if (announcement.eventTime.isNotEmpty && announcement.eventTime.trim().isNotEmpty)
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.access_time_rounded,
                      label: 'TIME',
                      value: announcement.eventTime,
                    ),
                  if (announcement.location.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.location_on_rounded,
                      label: 'LOCATION',
                      value: announcement.location,
                    ),
                  ],
                  if (announcement.fee.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.payments_rounded,
                      label: 'FEE',
                      value: announcement.fee,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF1C1C1E)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
