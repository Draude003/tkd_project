import 'package:flutter/material.dart';
import '../../../models/instructor_model.dart';

class TodaysClassesCard extends StatefulWidget {
  final List<InstructorClass> classes;
  const TodaysClassesCard({super.key, required this.classes});

  @override
  State<TodaysClassesCard> createState() => _TodaysClassesCardState();
}

class _TodaysClassesCardState extends State<TodaysClassesCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  String _classStatus(String timeRange) {
    final now = TimeOfDay.now();
    final parts = timeRange.split('–');
    if (parts.length < 2) return 'upcoming';
    final startParts = parts[0].trim().split(':');
    final endParts = parts[1].trim().split(':');
    if (startParts.length < 2 || endParts.length < 2) return 'upcoming';
    final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
    final nowMinutes = now.hour * 60 + now.minute;
    if (nowMinutes >= startMinutes && nowMinutes <= endMinutes) return 'active';
    if (nowMinutes > endMinutes) return 'done';
    return 'upcoming';
  }

  Color _getBgColor(String colorName) {
    switch (colorName) {
      case 'orange': return const Color(0xFFE8682A);
      case 'teal': return const Color(0xFF1D7A6F);
      case 'red': return const Color(0xFFB91C1C);
      default: return const Color(0xFF1D7A6F);
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
            const Text(
              "Today's Classes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              '${widget.classes.length} class${widget.classes.length != 1 ? 'es' : ''}',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Empty state
        if (widget.classes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
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
            child: const Column(
              children: [
                Icon(Icons.event_busy_rounded, size: 36, color: Color(0xFFBDBDBD)),
                SizedBox(height: 8),
                Text('No classes today',
                    style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14)),
              ],
            ),
          )
        else ...[
          // Horizontal PageView
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.classes.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, index) {
                final c = widget.classes[index];
                final times = c.time.split('–');
                final start = _formatTime(times[0].trim());
                final end = times.length > 1 ? _formatTime(times[1].trim()) : '';
                final bg = _getBgColor(c.bgColor);
                final status = _classStatus(c.time);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _ClassCard(
                    cls: c,
                    start: start,
                    end: end,
                    status: status,
                  ),
                );
              },
            ),
          ),

          // Dots indicator
          if (widget.classes.length > 1) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.classes.length, (i) {
                final isActive = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF1C1C1E)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        ],
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  final InstructorClass cls;
  final String start;
  final String end;
  final String status;

  const _ClassCard({
    required this.cls,
    required this.start,
    required this.end,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;

    switch (status) {
      case 'active':
        statusColor = const Color(0xFF22C55E);
        statusLabel = 'Active Now';
        break;
      case 'done':
        statusColor = Colors.grey;
        statusLabel = 'Done';
        break;
      default:
        statusColor = const Color(0xFF60A5FA);
        statusLabel = 'Upcoming';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFF8F9FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            // Left time panel
            Container(
              width: 90,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2D3748),
                    Color(0xFF4A5568),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 20, horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Day pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cls.dayOfWeek.isNotEmpty
                          ? cls.dayOfWeek.substring(0, 3).toUpperCase()
                          : 'TODAY',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white70,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Start time
                  Text(
                    start,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Divider
                  Container(
                    height: 1,
                    width: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white38,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // End time
                  Text(
                    end,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),

            // Right content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Status indicator
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withOpacity(0.4),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Class name
                    Text(
                      cls.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A202C),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Belt level badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF64748B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cls.description,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
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