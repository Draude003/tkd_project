// belt_promotion_model.dart

import 'package:flutter/material.dart';

enum PromotionStatus { ready, needsWork, pending }

enum BeltLevel {
  white,
  yellow,
  orange,
  green,
  blue,
  red,
  black;

  String get label {
    switch (this) {
      case BeltLevel.white:
        return 'White Belt';
      case BeltLevel.yellow:
        return 'Yellow Belt';
      case BeltLevel.orange:
        return 'Orange Belt';
      case BeltLevel.green:
        return 'Green Belt';
      case BeltLevel.blue:
        return 'Blue Belt';
      case BeltLevel.red:
        return 'Red Belt';
      case BeltLevel.black:
        return 'Black Belt';
    }
  }

  Color get color {
    switch (this) {
      case BeltLevel.white:
        return const Color(0xFFBDBDBD);
      case BeltLevel.yellow:
        return const Color(0xFFFFC107);
      case BeltLevel.orange:
        return const Color(0xFFFF7043);
      case BeltLevel.green:
        return const Color(0xFF43A047);
      case BeltLevel.blue:
        return const Color(0xFF1E88E5);
      case BeltLevel.red:
        return const Color(0xFFE53935);
      case BeltLevel.black:
        return const Color(0xFF212121);
    }
  }

  BeltLevel? get next {
    final all = BeltLevel.values;
    final idx = all.indexOf(this);
    if (idx < all.length - 1) return all[idx + 1];
    return null;
  }
}

enum Division {
  kidsBeginner,
  teensIntermediate,
  adultsSparring;

  String get label {
    switch (this) {
      case Division.kidsBeginner:
        return 'Kids Beginner';
      case Division.teensIntermediate:
        return 'Teens Intermediate';
      case Division.adultsSparring:
        return 'Adults Sparring';
    }
  }

  IconData get icon {
    switch (this) {
      case Division.kidsBeginner:
        return Icons.child_care_rounded;
      case Division.teensIntermediate:
        return Icons.school_rounded;
      case Division.adultsSparring:
        return Icons.sports_martial_arts_rounded;
    }
  }
}

class BeltPromotionCandidate {
  final String id;
  final String name;
  final BeltLevel currentBelt;
  final int attendanceCount;
  final double skillScore;
  final double instructorRating;
  final PromotionStatus status;
  final bool isSelected;

  const BeltPromotionCandidate({
    required this.id,
    required this.name,
    required this.currentBelt,
    required this.attendanceCount,
    required this.skillScore,
    required this.instructorRating,
    required this.status,
    this.isSelected = false,
  });

  bool get isReady => status == PromotionStatus.ready;

  BeltPromotionCandidate copyWith({
    String? id,
    String? name,
    BeltLevel? currentBelt,
    int? attendanceCount,
    double? skillScore,
    double? instructorRating,
    PromotionStatus? status,
    bool? isSelected,
  }) {
    return BeltPromotionCandidate(
      id: id ?? this.id,
      name: name ?? this.name,
      currentBelt: currentBelt ?? this.currentBelt,
      attendanceCount: attendanceCount ?? this.attendanceCount,
      skillScore: skillScore ?? this.skillScore,
      instructorRating: instructorRating ?? this.instructorRating,
      status: status ?? this.status,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class BeltPromotionClass {
  final String id;
  final Division division;
  final BeltLevel promotingTo;
  final List<BeltPromotionCandidate> candidates;
  final DateTime? examDate;

  const BeltPromotionClass({
    required this.id,
    required this.division,
    required this.promotingTo,
    required this.candidates,
    this.examDate,
  });

  String get className => division.label;
  String get beltLevel => promotingTo.label;

  int get readyCount =>
      candidates.where((c) => c.status == PromotionStatus.ready).length;
  int get needsWorkCount =>
      candidates.where((c) => c.status == PromotionStatus.needsWork).length;

  BeltPromotionClass copyWith({
    String? id,
    Division? division,
    BeltLevel? promotingTo,
    List<BeltPromotionCandidate>? candidates,
    DateTime? examDate,
  }) {
    return BeltPromotionClass(
      id: id ?? this.id,
      division: division ?? this.division,
      promotingTo: promotingTo ?? this.promotingTo,
      candidates: candidates ?? this.candidates,
      examDate: examDate ?? this.examDate,
    );
  }
}
