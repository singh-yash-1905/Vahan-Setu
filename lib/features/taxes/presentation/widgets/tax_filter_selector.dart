import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TaxFilterSelector extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const TaxFilterSelector({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                filters[index].toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              selectedColor: AppColors.accent.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.accent : AppColors.border,
                ),
              ),
              onSelected: (selected) {
                if (selected) onSelected(index);
              },
            ),
          );
        },
      ),
    );
  }
}
