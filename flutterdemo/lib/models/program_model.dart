class Program {
  final String id;
  final String title;
  final String teacherName;
  final String category;
  final double price;
  final double rating;
  final int studentsEnrolled;
  final String description;
  final List<String> whatIsIncluded;
  final String imageUrl;

  const Program({
    required this.id,
    required this.title,
    required this.teacherName,
    required this.category,
    required this.price,
    required this.rating,
    required this.studentsEnrolled,
    required this.description,
    required this.whatIsIncluded,
    required this.imageUrl,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      teacherName: json['teacherName'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      studentsEnrolled: json['studentsEnrolled'] ?? 0,
      description: json['description'] ?? '',
      whatIsIncluded: List<String>.from(json['whatIsIncluded'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'teacherName': teacherName,
      'category': category,
      'price': price,
      'rating': rating,
      'studentsEnrolled': studentsEnrolled,
      'description': description,
      'whatIsIncluded': whatIsIncluded,
      'imageUrl': imageUrl,
    };
  }
}
