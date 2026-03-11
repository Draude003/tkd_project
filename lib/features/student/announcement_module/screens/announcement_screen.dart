import 'package:flutter/material.dart';
import '../../../../models/announcement_model.dart';
import '../widgets/announcement_card.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: dummyAnnouncements.length,
      itemBuilder: (context, index) =>
          AnnouncementCard(announcement: dummyAnnouncements[index]),
    );
  }
}