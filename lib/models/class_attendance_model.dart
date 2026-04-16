import 'package:flutter/material.dart';

enum AttendanceStatus { present, late, absent, notMarked, excused }

class StudentAttendance {
  final String id;
  final String name;
  final String beltLevel;
  final Color beltColor;
  final String loginType;
  AttendanceStatus status;
  bool isSelected;

  StudentAttendance({
    required this.id,
    required this.name,
    required this.beltLevel,
    required this.beltColor,
    required this.loginType,
    this.status = AttendanceStatus.notMarked,
    this.isSelected = false,
  });
}

class ClassSession {
  final String className;
  final String coachName;
  final String schedule;
  final bool isActive;
  final List<StudentAttendance> students;

  const ClassSession({
    required this.className,
    required this.coachName,
    required this.schedule,
    required this.isActive,
    required this.students,
  });
}