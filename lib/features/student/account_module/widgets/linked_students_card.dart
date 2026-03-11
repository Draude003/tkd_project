import 'package:flutter/material.dart';
import '../../../../../models/parent_model.dart';

class LinkedStudentsCard extends StatelessWidget {
  final List<ChildInfo> children;
  const LinkedStudentsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
            const SizedBox(width: 8),
            const Text('Linked Students', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        ...children.map((child) => _StudentTile(child: child)),
      ],
    );
  }
}

class _StudentTile extends StatelessWidget {
  final ChildInfo child;
  const _StudentTile({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(child.avatarAsset, width: 28, height: 28),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                child.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                '${child.beltLevel} • ${child.status}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}