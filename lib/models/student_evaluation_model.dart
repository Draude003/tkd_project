import 'package:flutter/material.dart';

class EvaluationSkill {
  final String name;
  bool isChecked;
  final String status; // 'Mastered', 'In Progress', 'Not Yet'

  EvaluationSkill({
    required this.name,
    required this.isChecked,
    required this.status,
  });
}

class PerformanceScore {
  final String label;
  final double score; // 0.0 - 1.0

  const PerformanceScore({required this.label, required this.score});
}

class InstructorStudent {
  final String id;
  final String name;
  final String initials;
  final String beltLevel;
  final Color beltColor;
  final String className;
  final int sessions;
  final String lastExam;
  final List<EvaluationSkill> skills;
  final List<PerformanceScore> scores;

  const InstructorStudent({
    required this.id,
    required this.name,
    required this.initials,
    required this.beltLevel,
    required this.beltColor,
    required this.className,
    required this.sessions,
    required this.lastExam,
    required this.skills,
    required this.scores,
  });
}

final List<InstructorStudent> sampleInstructorStudents = [
  InstructorStudent(
    id: '1',
    name: 'Juan Cruz',
    initials: 'JC',
    beltLevel: 'Yellow Belt',
    beltColor: const Color(0xFFEAB308),
    className: 'Kids Beginner',
    sessions: 32,
    lastExam: 'Passed',
    skills: [
      EvaluationSkill(name: 'Basic Kicks', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Forms 1', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Sparring Control', isChecked: false, status: 'In Progress'),
      EvaluationSkill(name: 'Breaking', isChecked: false, status: 'Not Yet'),
    ],
    scores: const [
      PerformanceScore(label: 'Technique', score: 0.78),
      PerformanceScore(label: 'Discipline', score: 0.85),
      PerformanceScore(label: 'Fitness', score: 0.70),
      PerformanceScore(label: 'Attitude', score: 0.92),
    ],
  ),
  InstructorStudent(
    id: '2',
    name: 'Ana Santos',
    initials: 'AS',
    beltLevel: 'White Belt',
    beltColor: const Color(0xFF9CA3AF),
    className: 'Kids Beginner',
    sessions: 18,
    lastExam: 'Pending',
    skills: [
      EvaluationSkill(name: 'Basic Kicks', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Forms 1', isChecked: false, status: 'In Progress'),
      EvaluationSkill(name: 'Sparring Control', isChecked: false, status: 'Not Yet'),
      EvaluationSkill(name: 'Breaking', isChecked: false, status: 'Not Yet'),
    ],
    scores: const [
      PerformanceScore(label: 'Technique', score: 0.60),
      PerformanceScore(label: 'Discipline', score: 0.72),
      PerformanceScore(label: 'Fitness', score: 0.55),
      PerformanceScore(label: 'Attitude', score: 0.80),
    ],
  ),
  InstructorStudent(
    id: '3',
    name: 'Mark Lee',
    initials: 'ML',
    beltLevel: 'Green Belt',
    beltColor: const Color(0xFF22C55E),
    className: 'Kids Beginner',
    sessions: 41,
    lastExam: 'Passed',
    skills: [
      EvaluationSkill(name: 'Basic Kicks', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Forms 1', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Sparring Control', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Breaking', isChecked: false, status: 'In Progress'),
    ],
    scores: const [
      PerformanceScore(label: 'Technique', score: 0.88),
      PerformanceScore(label: 'Discipline', score: 0.90),
      PerformanceScore(label: 'Fitness', score: 0.82),
      PerformanceScore(label: 'Attitude', score: 0.95),
    ],
  ),
  InstructorStudent(
    id: '4',
    name: 'Rica Dela Cruz',
    initials: 'RD',
    beltLevel: 'Blue Belt',
    beltColor: const Color(0xFF3B82F6),
    className: 'Teens Intermediate',
    sessions: 27,
    lastExam: 'Passed',
    skills: [
      EvaluationSkill(name: 'Basic Kicks', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Forms 1', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Sparring Control', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Breaking', isChecked: true, status: 'Mastered'),
    ],
    scores: const [
      PerformanceScore(label: 'Technique', score: 0.84),
      PerformanceScore(label: 'Discipline', score: 0.88),
      PerformanceScore(label: 'Fitness', score: 0.79),
      PerformanceScore(label: 'Attitude', score: 0.91),
    ],
  ),
  InstructorStudent(
    id: '5',
    name: 'Karl Reyes',
    initials: 'KR',
    beltLevel: 'Yellow Belt',
    beltColor: const Color(0xFFEAB308),
    className: 'Teens Intermediate',
    sessions: 22,
    lastExam: 'Pending',
    skills: [
      EvaluationSkill(name: 'Basic Kicks', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Forms 1', isChecked: false, status: 'In Progress'),
      EvaluationSkill(name: 'Sparring Control', isChecked: false, status: 'In Progress'),
      EvaluationSkill(name: 'Breaking', isChecked: false, status: 'Not Yet'),
    ],
    scores: const [
      PerformanceScore(label: 'Technique', score: 0.65),
      PerformanceScore(label: 'Discipline', score: 0.70),
      PerformanceScore(label: 'Fitness', score: 0.68),
      PerformanceScore(label: 'Attitude', score: 0.75),
    ],
  ),
  InstructorStudent(
    id: '6',
    name: 'Lara Pangilinan',
    initials: 'LP',
    beltLevel: 'White Belt',
    beltColor: const Color(0xFF9CA3AF),
    className: 'Adults Sparring',
    sessions: 10,
    lastExam: 'No exam yet',
    skills: [
      EvaluationSkill(name: 'Basic Kicks', isChecked: false, status: 'In Progress'),
      EvaluationSkill(name: 'Forms 1', isChecked: false, status: 'Not Yet'),
      EvaluationSkill(name: 'Sparring Control', isChecked: false, status: 'Not Yet'),
      EvaluationSkill(name: 'Breaking', isChecked: false, status: 'Not Yet'),
    ],
    scores: const [
      PerformanceScore(label: 'Technique', score: 0.45),
      PerformanceScore(label: 'Discipline', score: 0.60),
      PerformanceScore(label: 'Fitness', score: 0.50),
      PerformanceScore(label: 'Attitude', score: 0.70),
    ],
  ),
  InstructorStudent(
    id: '7',
    name: 'Paolo Torres',
    initials: 'PT',
    beltLevel: 'Green Belt',
    beltColor: const Color(0xFF22C55E),
    className: 'Adults Sparring',
    sessions: 38,
    lastExam: 'Passed',
    skills: [
      EvaluationSkill(name: 'Basic Kicks', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Forms 1', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Sparring Control', isChecked: true, status: 'Mastered'),
      EvaluationSkill(name: 'Breaking', isChecked: false, status: 'In Progress'),
    ],
    scores: const [
      PerformanceScore(label: 'Technique', score: 0.86),
      PerformanceScore(label: 'Discipline', score: 0.89),
      PerformanceScore(label: 'Fitness', score: 0.91),
      PerformanceScore(label: 'Attitude', score: 0.88),
    ],
  ),
];

const List<String> classFilters = [
  'All Classes',
  'Kids Beginner',
  'Teens Intermediate',
  'Adults Sparring',
];