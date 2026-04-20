import 'package:flutter/material.dart';
import '../../../../models/student_announce_model.dart';
import 'package:tkd/services/api_service.dart';
import '../widgets/announcement_card.dart';

class StudentAnnouncementScreen extends StatefulWidget {
  const StudentAnnouncementScreen({super.key});

  @override
  State<StudentAnnouncementScreen> createState() => _StudentAnnouncementScreenState();
}

class _StudentAnnouncementScreenState extends State<StudentAnnouncementScreen> {
  List<Announcement> _announcements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    final data = await ApiService.getAnnouncements();
    setState(() {
      _announcements = data
          .map((a) => Announcement.fromJson(Map<String, dynamic>.from(a)))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _dismissAnnouncement(int index) async {
    final announcement = _announcements[index];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Announcement',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text(
          'Remove this announcement from your list?',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.dismissAnnouncement(announcement.id);
      setState(() => _announcements.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_announcements.isEmpty) {
      return const Center(
        child: Text(
          'No announcements yet.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _announcements.length,
      itemBuilder: (context, index) => Dismissible(
        key: Key(_announcements[index].id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          await _dismissAnnouncement(index);
          return false; // hindi auto-dismiss — ginagawa natin manually
        },
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
              SizedBox(height: 4),
              Text('Remove',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        child: AnnouncementCard(
          announcement: _announcements[index],
          onRead: () {
            setState(() {
              final old = _announcements[index];
              _announcements[index] = Announcement(
                id: old.id,
                title: old.title,
                description: old.description,
                date: old.date,
                sentAt: old.sentAt,
                location: old.location,
                eventDate: old.eventDate,
                eventTime: old.eventTime,
                fee: old.fee,
                isRead: true,
              );
            });
          },
        ),
      ),
    );
  }
}