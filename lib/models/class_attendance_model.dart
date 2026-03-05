import 'package:flutter/material.dart';
enum AttendanceStatus { present, late, absent, notMarked, excused }

class StudentAttendance {
  final String id;
  final String name;
  final String beltLevel;
  final Color beltColor;
  final String checkInMethod;
  AttendanceStatus status;
  bool isSelected;

  StudentAttendance({
    required this.id,
    required this.name,
    required this.beltLevel,
    required this.beltColor,
    required this.checkInMethod,
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

final sampleClassSession = ClassSession(
  className: 'Kids Beginner',
  coachName: 'Coach Sarah',
  schedule: '4:00–5:00 PM',
  isActive: true,
  students: [
    StudentAttendance(
      id: '1',
      name: 'Juan Cruz',
      beltLevel: 'Yellow Belt',
      beltColor: Color(0xFFEAB308),
      checkInMethod: 'Auto Check-in',
      status: AttendanceStatus.present,
    ),
    StudentAttendance(
      id: '2',
      name: 'Anna Santos',
      beltLevel: 'Green Belt',
      beltColor: Color(0xFF22C55E),
      checkInMethod: 'Auto Check-in',
      status: AttendanceStatus.late,
    ),
    StudentAttendance(
      id: '3',
      name: 'Jose Manalo',
      beltLevel: 'Orange Belt',
      beltColor: Color(0xFFF97316),
      checkInMethod: 'Auto Check-in',
      status: AttendanceStatus.notMarked,
    ),
    StudentAttendance(
      id: '4',
      name: 'Carlo Delacruz',
      beltLevel: 'Yellow Belt',
      beltColor: Color(0xFFEAB308),
      checkInMethod: 'Auto Check-in',
      status: AttendanceStatus.notMarked,
    ),
    StudentAttendance(
      id: '5',
      name: 'Maria Reyes',
      beltLevel: 'Green Belt',
      beltColor: Color(0xFF22C55E),
      checkInMethod: 'Auto Check-in',
      status: AttendanceStatus.absent,
    ),
  ],
);