import 'package:flutter/material.dart';
import '../../../models/coach_models.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Section Header ───────────────────────────────────────
        const Row(
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 20,
              color: Color(0xFF111111),
            ),
            SizedBox(width: 8),
            Text(
              'Parent- Coach Chat',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Coach Cards ──────────────────────────────────────────
        ...sampleCoaches.map(
          (coach) => _CoachCard(
            coach: coach,
            onChat: () {
              // TODO: navigate to chat with this coach
            },
          ),
        ),
      ],
    );
  }
}

// ── Coach Card ────────────────────────────────────────────────────────────────
class _CoachCard extends StatelessWidget {
  final CoachModel coach;
  final VoidCallback onChat;

  const _CoachCard({required this.coach, required this.onChat});

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
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Center(
              child: Text('🥋', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 12),

          // Name + role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coach.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                Text(
                  coach.role,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),

          // Go to chat button
          OutlinedButton(
            onPressed: onChat,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF111111),
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Go to chat',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
