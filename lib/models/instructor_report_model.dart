import 'package:flutter/material.dart';

// ── Overview Models ───────────────────────────────────────────────────────────
class OverviewStatModel {
  final String value;
  final String label;
  final String trend;
  final bool trendPositive;
  final String emoji;

  const OverviewStatModel({
    required this.value,
    required this.label,
    required this.trend,
    required this.trendPositive,
    required this.emoji,
  });
}

class AlertItemModel {
  final String label;
  final int count;

  const AlertItemModel({required this.label, required this.count});
}

class OverviewReportModel {
  final List<OverviewStatModel> stats;
  final int avgSkillScore;
  final List<AlertItemModel> alerts;

  const OverviewReportModel({
    required this.stats,
    required this.avgSkillScore,
    required this.alerts,
  });
}

// ── Student Models ────────────────────────────────────────────────────────────
class TopPerformerModel {
  final int rank;
  final String name;
  final String belt;
  final int score;

  const TopPerformerModel({
    required this.rank,
    required this.name,
    required this.belt,
    required this.score,
  });
}

class StudentAlertModel {
  final String name;
  final String alertLabel;
  final Color alertColor;
  final String value; // e.g. "78%"

  const StudentAlertModel({
    required this.name,
    required this.alertLabel,
    required this.alertColor,
    required this.value,
  });
}

class StudentReportModel {
  final List<TopPerformerModel> topPerformers;
  final List<StudentAlertModel> alerts;

  const StudentReportModel({required this.topPerformers, required this.alerts});
}

// ── Trends Models ─────────────────────────────────────────────────────────────
class MonthlyAttendanceModel {
  final String month;
  final int percentage;
  final bool isHighlighted;

  const MonthlyAttendanceModel({
    required this.month,
    required this.percentage,
    this.isHighlighted = false,
  });
}

class BeltDistributionModel {
  final String belt;
  final int students;
  final int percentage;
  final Color color;

  const BeltDistributionModel({
    required this.belt,
    required this.students,
    required this.percentage,
    required this.color,
  });
}

class ClassHoursModel {
  final String className;
  final double hours;

  const ClassHoursModel({required this.className, required this.hours});
}

class TrendsReportModel {
  final List<MonthlyAttendanceModel> monthlyAttendance;
  final List<BeltDistributionModel> beltDistribution;
  final List<ClassHoursModel> classHours;

  const TrendsReportModel({
    required this.monthlyAttendance,
    required this.beltDistribution,
    required this.classHours,
  });
}

// ── Top-level Report Model ────────────────────────────────────────────────────
class InstructorReportModel {
  final String title;
  final String date;
  final String selectedClass;
  final OverviewReportModel overview;
  final StudentReportModel student;
  final TrendsReportModel trends;

  const InstructorReportModel({
    required this.title,
    required this.date,
    required this.selectedClass,
    required this.overview,
    required this.student,
    required this.trends,
  });
}

// ── Sample Data ───────────────────────────────────────────────────────────────
final sampleInstructorReport = InstructorReportModel(
  title: 'Instructor Reports',
  date: 'Mon, Feb 11, 2026',
  selectedClass: 'All Classes',
  overview: const OverviewReportModel(
    stats: [
      OverviewStatModel(
        value: '87%',
        label: 'Attendance Rate',
        trend: '+3% vs last month',
        trendPositive: true,
        emoji: '📅',
      ),
      OverviewStatModel(
        value: '52',
        label: 'Active students',
        trend: '+6% vs last month',
        trendPositive: true,
        emoji: '👥',
      ),
      OverviewStatModel(
        value: '9',
        label: 'Promotion Ready\nbelt exam candidates',
        trend: '',
        trendPositive: true,
        emoji: '🥋',
      ),
      OverviewStatModel(
        value: '4',
        label: 'Delinquent\nbelow attendance',
        trend: '',
        trendPositive: false,
        emoji: '⚠️',
      ),
    ],
    avgSkillScore: 81,
    alerts: [
      AlertItemModel(label: 'Students with expiring membership', count: 6),
      AlertItemModel(label: 'Belt exam candidates ready', count: 9),
      AlertItemModel(label: 'Delinquent attendance (< 70%)', count: 4),
    ],
  ),
  student: const StudentReportModel(
    topPerformers: [
      TopPerformerModel(
        rank: 1,
        name: 'Benedick James Caber',
        belt: 'Blue Belt',
        score: 94,
      ),
      TopPerformerModel(
        rank: 2,
        name: 'Eduard Estareje',
        belt: 'Blue Belt',
        score: 93,
      ),
      TopPerformerModel(
        rank: 3,
        name: 'Rhodmark Terencio',
        belt: 'Rainbow Belt',
        score: 93,
      ),
    ],
    alerts: [
      StudentAlertModel(
        name: 'Carlo Dela Cruz',
        alertLabel: 'Low Attendance',
        alertColor: Color(0xFFE53935),
        value: '78%',
      ),
      StudentAlertModel(
        name: 'Ben Tulfo',
        alertLabel: 'Missed 3 classes',
        alertColor: Color(0xFFFF8F00),
        value: '67%',
      ),
      StudentAlertModel(
        name: 'Oleg Cruz',
        alertLabel: 'Low Balance',
        alertColor: Color(0xFFE53935),
        value: '67%',
      ),
    ],
  ),
  trends: TrendsReportModel(
    monthlyAttendance: const [
      MonthlyAttendanceModel(month: 'Sep', percentage: 82),
      MonthlyAttendanceModel(month: 'Oct', percentage: 92),
      MonthlyAttendanceModel(month: 'Nov', percentage: 88),
      MonthlyAttendanceModel(month: 'Dec', percentage: 76),
      MonthlyAttendanceModel(month: 'Jan', percentage: 87),
      MonthlyAttendanceModel(month: 'Feb', percentage: 98, isHighlighted: true),
    ],
    beltDistribution: const [
      BeltDistributionModel(
        belt: 'White',
        students: 14,
        percentage: 27,
        color: Color.fromARGB(255, 107, 107, 107),
      ),
      BeltDistributionModel(
        belt: 'Yellow',
        students: 13,
        percentage: 23,
        color: Color(0xFFFFEB3B),
      ),
      BeltDistributionModel(
        belt: 'Orange',
        students: 10,
        percentage: 17,
        color: Color(0xFFFF9800),
      ),
      BeltDistributionModel(
        belt: 'Green',
        students: 4,
        percentage: 12,
        color: Color(0xFF43A047),
      ),
      BeltDistributionModel(
        belt: 'Blue',
        students: 1,
        percentage: 14,
        color: Color(0xFF1E88E5),
      ),
      BeltDistributionModel(
        belt: 'Purple',
        students: 7,
        percentage: 7,
        color: Color(0xFF8E24AA),
      ),
    ],
    classHours: const [
      ClassHoursModel(className: 'Kids Beginner', hours: 9),
      ClassHoursModel(className: 'Teens Inter', hours: 9),
      ClassHoursModel(className: 'Adults Sparring', hours: 7.5),
    ],
  ),
);
