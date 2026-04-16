import 'package:flutter/material.dart';
import '../../../../models/announcement_model.dart';
import '../widgets/announcement_card.dart';
import 'package:tkd/services/api_service.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
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
      itemBuilder: (context, index) =>
          AnnouncementCard(announcement: _announcements[index]),
    );
  }
}