import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DocumentHeader extends StatelessWidget {
  final VoidCallback onRefresh;

  const DocumentHeader({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.folder_copy_rounded,
                color: AppColors.textLight,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Documents',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textLight,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Monitor fleet documents',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
              child: InkWell(
                onTap: onRefresh,
                borderRadius: BorderRadius.circular(11),
                child: const Padding(
                  padding: EdgeInsets.all(9),
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 20,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
