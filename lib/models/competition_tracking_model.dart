class CompetitionModel {
  final String id;
  final String title;
  final DateTime eventDate;
  final CompetitionStatus status;
  final List<CompetitionParticipant> participants;

  const CompetitionModel({
    required this.id,
    required this.title,
    required this.eventDate,
    required this.status,
    this.participants = const [],
  });

  CompetitionModel copyWith({
    String? id,
    String? title,
    DateTime? eventDate,
    CompetitionStatus? status,
    List<CompetitionParticipant>? participants,
  }) {
    return CompetitionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      eventDate: eventDate ?? this.eventDate,
      status: status ?? this.status,
      participants: participants ?? this.participants,
    );
  }
}

class CompetitionParticipant {
  final String studentId;
  final String studentName;
  final String studentRole;
  final String avatarInitial;
  final List<CompetitionEvent> events;
  final List<TrainingFocus> trainingFocus;
  final String coachNotes;

  const CompetitionParticipant({
    required this.studentId,
    required this.studentName,
    this.studentRole = 'Student',
    required this.avatarInitial,
    this.events = const [],
    this.trainingFocus = const [],
    this.coachNotes = '',
  });

  CompetitionParticipant copyWith({
    List<CompetitionEvent>? events,
    List<TrainingFocus>? trainingFocus,
    String? coachNotes,
  }) {
    return CompetitionParticipant(
      studentId: studentId,
      studentName: studentName,
      studentRole: studentRole,
      avatarInitial: avatarInitial,
      events: events ?? this.events,
      trainingFocus: trainingFocus ?? this.trainingFocus,
      coachNotes: coachNotes ?? this.coachNotes,
    );
  }
}

class CompetitionEvent {
  final String id;
  final String name;
  final bool isCompleted;
  final MedalResult? medal;
  final EventStatus status;

  const CompetitionEvent({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.medal,
    this.status = EventStatus.upcoming,
  });

  CompetitionEvent copyWith({
    bool? isCompleted,
    MedalResult? medal,
    EventStatus? status,
  }) {
    return CompetitionEvent(
      id: id,
      name: name,
      isCompleted: isCompleted ?? this.isCompleted,
      medal: medal ?? this.medal,
      status: status ?? this.status,
    );
  }
}

enum CompetitionStatus { upcoming, ongoing, completed, cancelled }

enum EventStatus { upcoming, completed }

enum MedalResult { gold, silver, bronze, none }

enum TrainingFocus { speed, power, defense, agility, endurance }

extension CompetitionStatusExt on CompetitionStatus {
  String get label {
    switch (this) {
      case CompetitionStatus.upcoming:
        return 'Upcoming';
      case CompetitionStatus.ongoing:
        return 'Ongoing';
      case CompetitionStatus.completed:
        return 'Completed';
      case CompetitionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

extension MedalResultExt on MedalResult {
  String get label {
    switch (this) {
      case MedalResult.gold:
        return 'GOLD';
      case MedalResult.silver:
        return 'SILVER';
      case MedalResult.bronze:
        return 'BRONZE';
      case MedalResult.none:
        return '';
    }
  }

  String get emoji {
    switch (this) {
      case MedalResult.gold:
        return '🥇';
      case MedalResult.silver:
        return '🥈';
      case MedalResult.bronze:
        return '🥉';
      case MedalResult.none:
        return '';
    }
  }
}

extension TrainingFocusExt on TrainingFocus {
  String get label {
    switch (this) {
      case TrainingFocus.speed:
        return 'Speed';
      case TrainingFocus.power:
        return 'Power';
      case TrainingFocus.defense:
        return 'Defense';
      case TrainingFocus.agility:
        return 'Agility';
      case TrainingFocus.endurance:
        return 'Endurance';
    }
  }

  String get emoji {
    switch (this) {
      case TrainingFocus.speed:
        return '⚡';
      case TrainingFocus.power:
        return '🏃';
      case TrainingFocus.defense:
        return '🛡';
      case TrainingFocus.agility:
        return '🤸';
      case TrainingFocus.endurance:
        return '💪';
    }
  }
}
