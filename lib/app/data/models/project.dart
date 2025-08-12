class Project {
  final int id;
  final String name;
  final String status;
  final String borrower;
  final String lender;
  final double budget;
  final String type;
  final String location;
  final String createdAt;

  Project({
    required this.id,
    required this.name,
    required this.status,
    required this.borrower,
    required this.lender,
    required this.budget,
    required this.type,
    required this.location,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      borrower: json['borrower'],
      lender: json['lender'],
      budget: double.tryParse(json['budget']) ?? 0.0,
      type: json['type'],
      location: json['location'],
      createdAt: json['created_at'],
    );
  }
}
