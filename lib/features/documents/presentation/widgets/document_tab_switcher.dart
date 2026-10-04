import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DocumentTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DocumentTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _TabButton(
                label: 'Expiring Soon',
                icon: Icons.schedule_rounded,
                selected: selectedIndex == 0,
                onTap: () => onChanged(0),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _TabButton(
                label: 'Reupload Requests',
                icon: Icons.upload_file_rounded,
                selected: selectedIndex == 1,
                onTap: () => onChanged(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: selected
                      ? AppColors.textLight
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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
      ),
    );
  }
}
