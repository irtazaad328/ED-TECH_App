import 'package:flutter/material.dart';
import '../../models/program_model.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class ProgramsListScreen extends StatelessWidget {
  const ProgramsListScreen({super.key});

  final List<Program> samplePrograms = const [
    Program(
      id: 'p1',
      title: 'Flutter Mobile App Development',
      teacherName: 'Jerry Mentor',
      category: 'Mobile Dev',
      price: 49.99,
      rating: 4.9,
      studentsEnrolled: 140,
      description: 'Master Flutter and Dart to build production-ready iOS and Android apps.',
      whatIsIncluded: ['40 Hours Video', 'GitHub Source Code', 'Certificate of Completion'],
      imageUrl: '',
    ),
    Program(
      id: 'p2',
      title: 'Prompt Engineering & Research',
      teacherName: 'Laviza Mentor',
      category: 'AI & Data',
      price: 39.99,
      rating: 4.8,
      studentsEnrolled: 220,
      description: 'Learn reproducible AI workflows, prompt frameworks, and research validation.',
      whatIsIncluded: ['10+ Frameworks', 'Hands-on Projects', 'Peer Reviews'],
      imageUrl: '',
    ),
    Program(
      id: 'p3',
      title: 'UI/UX Design with Figma',
      teacherName: 'Excelerate Design Team',
      category: 'Design',
      price: 29.99,
      rating: 4.7,
      studentsEnrolled: 95,
      description: 'Design wireframes, component systems, and high-fidelity mobile prototypes.',
      whatIsIncluded: ['Figma Templates', 'Design Systems', 'Design Audit Checklist'],
      imageUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Programs'),
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search programs, topics, or teachers...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),

          // List of Programs
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: samplePrograms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final program = samplePrograms[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.programDetails);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  program.category,
                                  style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.bookmark_border_rounded),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            program.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Instructor: ${program.teacherName}',
                            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${program.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${program.rating} (${program.studentsEnrolled})',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
