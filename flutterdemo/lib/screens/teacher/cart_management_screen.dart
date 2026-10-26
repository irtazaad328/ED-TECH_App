import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Screen 13: Cart Management Screen (Teacher / Admin Flow)
/// Allows instructors to monitor who added programs to their cart vs who completed payment.
class CartManagementScreen extends StatefulWidget {
  const CartManagementScreen({super.key});

  @override
  State<CartManagementScreen> createState() => _CartManagementScreenState();
}

class _CartManagementScreenState extends State<CartManagementScreen> {
  String _selectedFilter = 'All'; // 'All', 'In Cart', 'Paid'
  String _searchQuery = '';
  final Set<String> _remindedEmails = {};

  void _sendReminder(Map<String, String> item) {
    setState(() {
      _remindedEmails.add(item['email']!);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Payment reminder sent to ${item['studentName']} (${item['email']})',
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  final List<Map<String, String>> _allEnrollments = const [
    {
      'studentName': 'Ali Khan',
      'email': 'ali.khan@gmail.com',
      'program': 'Flutter Mobile App Development',
      'status': 'Paid',
      'price': '\$49.99',
      'date': 'Oct 14, 2026',
    },
    {
      'studentName': 'Sara Ahmed',
      'email': 'sara.ahmed@outlook.com',
      'program': 'Flutter Mobile App Development',
      'status': 'In Cart',
      'price': '\$49.99',
      'date': 'Oct 15, 2026',
    },
    {
      'studentName': 'David Miller',
      'email': 'david.m@university.edu',
      'program': 'Prompt Engineering & Research',
      'status': 'Paid',
      'price': '\$39.99',
      'date': 'Oct 13, 2026',
    },
    {
      'studentName': 'Zainab Fatima',
      'email': 'zainab.f@gmail.com',
      'program': 'UI/UX Design with Figma',
      'status': 'In Cart',
      'price': '\$29.99',
      'date': 'Oct 16, 2026',
    },
    {
      'studentName': 'Johnathan Doe',
      'email': 'jdoe@techcorp.com',
      'program': 'Flutter Mobile App Development',
      'status': 'Paid',
      'price': '\$49.99',
      'date': 'Oct 17, 2026',
    },
  ];

  List<Map<String, String>> get _filteredEnrollments {
    return _allEnrollments.where((item) {
      final matchesFilter =
          _selectedFilter == 'All' || item['status'] == _selectedFilter;
      final matchesSearch = item['studentName']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          item['email']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['program']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final paidCount =
        _allEnrollments.where((e) => e['status'] == 'Paid').length;
    final inCartCount =
        _allEnrollments.where((e) => e['status'] == 'In Cart').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart & Enrollment Pipeline'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Search learner, email, or program...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
            const SizedBox(height: 14),

            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All (${_allEnrollments.length})', 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Paid ($paidCount)', 'Paid'),
                  const SizedBox(width: 8),
                  _buildFilterChip('In Cart ($inCartCount)', 'In Cart'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Enrollment List
            Expanded(
              child: _filteredEnrollments.isEmpty
                  ? Center(
                      child: Text(
                        'No student records match your criteria.',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredEnrollments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _filteredEnrollments[index];
                        final isPaid = item['status'] == 'Paid';

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['studentName']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isPaid
                                            ? AppTheme.success.withOpacity(0.12)
                                            : AppTheme.warning
                                                .withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isPaid
                                                ? Icons.check_circle_rounded
                                                : Icons.shopping_cart_outlined,
                                            size: 14,
                                            color: isPaid
                                                ? AppTheme.success
                                                : AppTheme.warning,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['status']!,
                                            style: TextStyle(
                                              color: isPaid
                                                  ? AppTheme.success
                                                  : AppTheme.warning,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['email']!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const Divider(height: 18),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['program']!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['price']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Added on: ${item['date']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    if (!isPaid) () {
                                      final bool isReminded =
                                          _remindedEmails.contains(item['email']);
                                      return TextButton.icon(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(50, 30),
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap,
                                          foregroundColor: isReminded
                                              ? Colors.green.shade700
                                              : AppTheme.primary,
                                        ),
                                        icon: Icon(
                                          isReminded
                                              ? Icons.check_circle_rounded
                                              : Icons.send_rounded,
                                          size: 14,
                                        ),
                                        label: Text(
                                          isReminded
                                              ? 'Reminder Sent'
                                              : 'Send Reminder',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        onPressed: isReminded
                                            ? null
                                            : () => _sendReminder(item),
                                      );
                                    }(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final bool isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
      selectedColor: AppTheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
    );
  }
}
