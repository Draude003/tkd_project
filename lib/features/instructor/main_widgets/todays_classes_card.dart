import 'package:flutter/material.dart';
import '../../../models/instructor_model.dart';

class TodaysClassesCard extends StatelessWidget {
  final List<InstructorClass> classes;
  const TodaysClassesCard({super.key, required this.classes});

  Color _getBgColor(String colorName) {
    switch (colorName) {
      case 'orange': return const Color(0xFFE8682A);
      case 'teal':   return const Color(0xFF1D7A6F);
      case 'red':    return const Color(0xFFB91C1C);
      default:       return const Color(0xFF1D7A6F);
    }
  }

  String _formatTime(String raw) {
    try {
      final parts = raw.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(width: 4, height: 18, color: const Color(0xFF1C1C1E)),
            const SizedBox(width: 8),
            const Text("Today's Classes",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${classes.length} class${classes.length != 1 ? 'es' : ''}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
        const SizedBox(height: 12),

        // Card container
        Container(
          height: classes.length <= 2 ? null : 210,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: classes.isEmpty
              ? _EmptyState()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: classes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final c = classes[index];
                      final times = c.time.split('–');
                      final start = _formatTime(times[0].trim());
                      final end = times.length > 1
                          ? _formatTime(times[1].trim())
                          : '';
                      final bg = _getBgColor(c.bgColor);
                      return _ClassTile(cls: c, start: start, end: end, bg: bg);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _ClassTile extends StatelessWidget {
  final InstructorClass cls;
  final String start;
  final String end;
  final Color bg;

  const _ClassTile({
    required this.cls,
    required this.start,
    required this.end,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bg.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left colored time block
            Container(
              width: 76,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  bottomLeft: Radius.circular(11),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    start,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(height: 1, width: 28, color: Colors.white38),
                  const SizedBox(height: 4),
                  Text(
                    end,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Class info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cls.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: bg.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cls.description,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: bg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: const Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 36, color: Color(0xFFBDBDBD)),
          SizedBox(height: 8),
          Text('No classes today',
              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
        ],
      ),
    );
  }
}