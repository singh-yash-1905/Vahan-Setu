import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class VehicleFilterBar extends StatelessWidget {
  final String selectedFilter;
  final String searchQuery;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<String> onSearchChanged;

  const VehicleFilterBar({
    super.key,
    required this.selectedFilter,
    required this.searchQuery,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        children: [
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search vehicle, model, firm...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () => onSearchChanged(''),
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.accent,
                  width: 1.4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'All Vehicles',
                  selected: selectedFilter == 'ALL',
                  onTap: () => onFilterChanged('ALL'),
                ),
                _FilterChip(
                  label: 'Active',
                  selected: selectedFilter == 'ACTIVE',
                  onTap: () => onFilterChanged('ACTIVE'),
                ),
                _FilterChip(
                  label: 'Inactive',
                  selected: selectedFilter == 'INACTIVE',
                  onTap: () => onFilterChanged('INACTIVE'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : AppColors.border.withValues(alpha: 0.6),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: selected ? AppColors.textLight : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
