class SessionModel {
  final String id;
  String time;
  final String patientName;
  final String treatment;
  final String location;
  String status; 
  String? therapistNotes;

  SessionModel({
    required this.id,
    required this.time,
    required this.patientName,
    required this.treatment,
    required this.location,
    required this.status,
    this.therapistNotes,
  });
}