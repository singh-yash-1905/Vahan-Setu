import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class VehicleCategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const VehicleCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
      child: Row(
        children: [
          Expanded(
            child: _CategoryButton(
              label: 'All',
              icon: Icons.grid_view_rounded,
              selected: selectedCategory == 'ALL',
              onTap: () => onCategoryChanged('ALL'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CategoryButton(
              label: 'Truck',
              icon: Icons.local_shipping_rounded,
              selected: selectedCategory == 'TRUCK',
              onTap: () => onCategoryChanged('TRUCK'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CategoryButton(
              label: 'Trailer',
              icon: Icons.rv_hookup_rounded,
              selected: selectedCategory == 'TRAILER',
              onTap: () => onCategoryChanged('TRAILER'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CategoryButton(
              label: 'Tanker',
              icon: Icons.water_drop_rounded,
              selected: selectedCategory == 'TANKER',
              onTap: () => onCategoryChanged('TANKER'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 44,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.border.withValues(alpha: 0.55),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.textLight : AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected
                        ? AppColors.textLight
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
