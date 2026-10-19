import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/program_model.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

/// Loads the mock programs from assets/data/programs.json.
Future<List<Program>> loadPrograms() async {
  final String jsonString =
      await rootBundle.loadString('assets/data/programs.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((item) => Program.fromJson(item)).toList();
}

/// Screen 5 — Programs List (Learner).
/// Loads programs from JSON, with live search + category filter chips.
class ProgramsListScreen extends StatefulWidget {
  const ProgramsListScreen({super.key});

  @override
  State<ProgramsListScreen> createState() => _ProgramsListScreenState();
}

class _ProgramsListScreenState extends State<ProgramsListScreen> {
  static const List<String> _categories = [
    'All',
    'Mobile Dev',
    'Artificial Intelligence',
    'UI/UX Design',
  ];

  late final Future<List<Program>> _programsFuture;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  final Set<String> _bookmarkedIds = {};

  @override
  void initState() {
    super.initState();
    // Load once in initState so the future isn't re-created on every rebuild.
    _programsFuture = loadPrograms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Applies the category chip + search text to the full list.
  List<Program> _applyFilters(List<Program> programs) {
    final query = _searchQuery.trim().toLowerCase();
    return programs.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.teacherName.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _toggleBookmark(Program program) {
    final added = !_bookmarkedIds.contains(program.id);
    setState(() {
      if (added) {
        _bookmarkedIds.add(program.id);
      } else {
        _bookmarkedIds.remove(program.id);
      }
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(added
              ? 'Saved "${program.title}" to bookmarks'
              : 'Removed "${program.title}" from bookmarks'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _openDetails(Program program) {
    // The program is passed as an argument so the details screen can read it
    // with ModalRoute.of(context)!.settings.arguments as Program.
    Navigator.pushNamed(
      context,
      AppRoutes.programDetails,
      arguments: program,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Programs')),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Program>>(
              future: _programsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _buildMessage(
                    icon: Icons.error_outline_rounded,
                    title: 'Could not load programs',
                    subtitle: '${snapshot.error}',
                  );
                }

                final filtered = _applyFilters(snapshot.data ?? []);
                if (filtered.isEmpty) {
                  return _buildMessage(
                    icon: Icons.search_off_rounded,
                    title: 'No programs found',
                    subtitle: 'Try a different search or category.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final program = filtered[index];
                    return _ProgramCard(
                      program: program,
                      isBookmarked: _bookmarkedIds.contains(program.id),
                      onTap: () => _openDetails(program),
                      onBookmark: () => _toggleBookmark(program),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search programs, topics, or teachers...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = category == _selectedCategory;
          return Center(
            child: ChoiceChip(
              label: Text(category),
              selected: selected,
              showCheckmark: false,
              onSelected: (_) => setState(() => _selectedCategory = category),
              selectedColor: AppTheme.primary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: selected ? AppTheme.primary : Colors.grey.shade300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppTheme.textSecondary),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single course card: image/icon, category pill, title, teacher,
/// rating + enrolled count, price and bookmark.
class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.program,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmark,
  });

  final Program program;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmark;

  IconData get _categoryIcon {
    switch (program.category) {
      case 'Mobile Dev':
        return Icons.phone_iphone_rounded;
      case 'Artificial Intelligence':
        return Icons.psychology_rounded;
      case 'UI/UX Design':
        return Icons.design_services_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course image (falls back to a category icon if the asset is missing)
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: program.imageUrl.isEmpty
                      ? _imageFallback()
                      : Image.asset(
                          program.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imageFallback(),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 1,
                    child: IconButton(
                      tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: AppTheme.primary,
                      ),
                      onPressed: onBookmark,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
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
                  const SizedBox(height: 10),
                  Text(
                    program.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    program.teacherName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        program.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.people_alt_outlined,
                          size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${program.studentsEnrolled} enrolled',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${program.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppTheme.primary.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Icon(_categoryIcon, size: 56, color: AppTheme.primary),
    );
  }
}
