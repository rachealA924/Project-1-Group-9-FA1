class Opportunity {
  final String id;
  final String title;
  final String description;
  final String type;
  final String organizer;
  final String deadline;
  final String location;
  final String imageUrl;
  bool isApplied;

  Opportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.organizer,
    required this.deadline,
    required this.location,
    required this.imageUrl,
    this.isApplied = false,
  });
}