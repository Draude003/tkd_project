import 'package:flutter/material.dart';

enum CompetitionResult { gold, silver, bronze, participant }

class CompetitionModel {
  final String title;
  final String date;
  final CompetitionResult result;

  const CompetitionModel({
    required this.title,
    required this.date,
    required this.result,
  });

  String get medalEmoji {
    switch (result) {
      case CompetitionResult.gold:
        return '🥇';
      case CompetitionResult.silver:
        return '🥈';
      case CompetitionResult.bronze:
        return '🥉';
      case CompetitionResult.participant:
        return '🏅';
    }
  }

  String get resultLabel {
    switch (result) {
      case CompetitionResult.gold:
        return 'Gold';
      case CompetitionResult.silver:
        return 'Silver';
      case CompetitionResult.bronze:
        return 'Bronze';
      case CompetitionResult.participant:
        return 'Participant';
    }
  }

  Color get resultColor {
    switch (result) {
      case CompetitionResult.gold:
        return const Color(0xFFFFB300);
      case CompetitionResult.silver:
        return const Color(0xFF9E9E9E);
      case CompetitionResult.bronze:
        return const Color(0xFFBF8040);
      case CompetitionResult.participant:
        return const Color(0xFF1E88E5);
    }
  }
}

// ── Sample Data ───────────────────────────────────────────────────────────────
final List<CompetitionModel> sampleCompetitions = [
  const CompetitionModel(
    title: 'NCR Junior Championship',
    date: 'July 2025',
    result: CompetitionResult.silver,
  ),
  const CompetitionModel(
    title: 'Club Sparring Day',
    date: 'March 2025',
    result: CompetitionResult.gold,
  ),
  const CompetitionModel(
    title: 'National Kids TKD',
    date: 'Jan 2025',
    result: CompetitionResult.participant,
  ),
];
