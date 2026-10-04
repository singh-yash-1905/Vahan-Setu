import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ExpenseCategorySelector extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onSelected;

  const ExpenseCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = categories[index];

            final bool isSelected = (selectedCategory ?? 'All') == category;

            return ChoiceChip(
              label: Text(
                category.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.accent.withValues(alpha: 0.15),
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.accent : AppColors.border,
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  onSelected(category);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
