import 'package:flutter/material.dart';
import '../../../../models/parent_announce_model.dart'; 
import 'announcement_detail_modal.dart';
import 'package:tkd/services/api_service.dart';

class AnnouncementCard extends StatefulWidget {
  final Announcement announcement;
  final VoidCallback? onRead;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.onRead,
  });

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  late bool _isRead;

  @override
  void initState() {
    super.initState();
    _isRead = widget.announcement.isRead;
  }

  Future<void> _handleViewDetails() async {
    AnnouncementDetailModal.show(context, widget.announcement);
    if (!_isRead) {
      await ApiService.markAnnouncementRead(widget.announcement.id);
      if (mounted) {
        setState(() => _isRead = true);
        widget.onRead?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _isRead ? Colors.grey.shade300 : Colors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Time + NEW badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.announcement.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: const Color(0xFF1C1C1E),
                                  ),
                                ),
                              ),
                              if (!_isRead) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (widget.announcement.sentAt.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.access_time_rounded,
                              size: 11, color: Colors.grey.shade400),
                          const SizedBox(width: 3),
                          Text(
                            widget.announcement.sentAt,
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.announcement.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 11, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              widget.announcement.date,
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 11),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _handleViewDetails,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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