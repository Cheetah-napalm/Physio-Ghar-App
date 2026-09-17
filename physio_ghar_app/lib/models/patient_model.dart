class SessionNoteModel {
  final String id;
  final String date;
  final String note;
  final List<String> exercises;
  final String nextSessionPlan;

  SessionNoteModel({
    required this.id,
    required this.date,
    required this.note,
    required this.exercises,
    required this.nextSessionPlan,
  });

  SessionNoteModel copyWith({
    String? id,
    String? date,
    String? note,
    List<String>? exercises,
    String? nextSessionPlan,
  }) {
    return SessionNoteModel(
      id: id ?? this.id,
      date: date ?? this.date,
      note: note ?? this.note,
      exercises: exercises ?? this.exercises,
      nextSessionPlan: nextSessionPlan ?? this.nextSessionPlan,
    );
  }

  factory SessionNoteModel.fromJson(Map<String, dynamic> json) {
    return SessionNoteModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      note: json['note'] ?? '',
      exercises: List<String>.from(json['exercises'] ?? []),
      nextSessionPlan: json['next_session_plan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'note': note,
      'exercises': exercises,
      'next_session_plan': nextSessionPlan,
    };
  }
}

class PatientModel {
  final String id;
  final String name;
  final String condition;
  final int age;
  final String gender;
  final String contact;
  final String lastSessionDate;
  final List<String> treatmentHistory;
  final List<SessionNoteModel> sessionNotes;

  PatientModel({
    required this.id,
    required this.name,
    required this.condition,
    required this.age,
    required this.gender,
    required this.contact,
    required this.lastSessionDate,
    required this.treatmentHistory,
    required this.sessionNotes,
  });

  PatientModel copyWith({
    String? id,
    String? name,
    String? condition,
    int? age,
    String? gender,
    String? contact,
    String? lastSessionDate,
    List<String>? treatmentHistory,
    List<SessionNoteModel>? sessionNotes,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      condition: condition ?? this.condition,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      contact: contact ?? this.contact,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      treatmentHistory: treatmentHistory ?? this.treatmentHistory,
      sessionNotes: sessionNotes ?? this.sessionNotes,
    );
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    var notesList = json['session_notes'] as List? ?? [];
    List<SessionNoteModel> parsedNotes =
        notesList.map((noteJson) => SessionNoteModel.fromJson(noteJson)).toList();

    return PatientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      condition: json['condition'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      contact: json['contact'] ?? '',
      lastSessionDate: json['last_session_date'] ?? '',
      treatmentHistory: List<String>.from(json['treatment_history'] ?? []),
      sessionNotes: parsedNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'condition': condition,
      'age': age,
      'gender': gender,
      'contact': contact,
      'last_session_date': lastSessionDate,
      'treatment_history': treatmentHistory,
      'session_notes': sessionNotes.map((note) => note.toJson()).toList(),
    };
  }
}