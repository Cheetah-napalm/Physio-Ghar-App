class ComplaintModel {
  final String id;
  final String category;
  final String subject;
  final String description;
  final String dateSubmitted;
  final String status;

  ComplaintModel({
    required this.id,
    required this.category,
    required this.subject,
    required this.description,
    required this.dateSubmitted,
    this.status = 'Pending',
  });
}