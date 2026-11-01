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
  final List<SyllabusModule> syllabus;

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
    this.syllabus = const [],
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
      syllabus: (json['syllabus'] as List<dynamic>? ?? [])
          .map((m) => SyllabusModule.fromJson(m as Map<String, dynamic>))
          .toList(),
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
      'syllabus': syllabus.map((m) => m.toJson()).toList(),
    };
  }
}

/// One module (week / unit) of a program's syllabus.
class SyllabusModule {
  final String title;
  final String duration;
  final List<String> lessons;

  const SyllabusModule({
    required this.title,
    required this.duration,
    required this.lessons,
  });

  factory SyllabusModule.fromJson(Map<String, dynamic> json) {
    return SyllabusModule(
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      lessons: List<String>.from(json['lessons'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'duration': duration,
      'lessons': lessons,
    };
  }
}
