class SessionItem {
  final String id;
  final String time;
  final String patientName;
  final String treatment;
  final String location;
  final String status;

  SessionItem({
    required this.id,
    required this.time,
    required this.patientName,
    required this.treatment,
    required this.location,
    required this.status,
  });

  SessionItem copyWith({String? status}) {
    return SessionItem(
      id: id,
      time: time,
      patientName: patientName,
      treatment: treatment,
      location: location,
      status: status ?? this.status,
    );
  }
}