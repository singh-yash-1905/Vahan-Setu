import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class VehicleHeader extends StatelessWidget {
  final VoidCallback onRefresh;

  const VehicleHeader({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fleet Vehicles',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Manage your fleet',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight.withValues(alpha: 0.65),
                    ),
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
