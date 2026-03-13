import 'package:flutter/material.dart';

class CompetitionFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  static const List<String> filters = [
    'All',
    'Upcoming',
    'Ongoing',
    'Completed',
    'Cancelled',
  ];

  const CompetitionFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFE5E5E5),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF555555),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
