import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class VehicleListCard extends StatelessWidget {
  final dynamic vehicle;
  final VoidCallback onTap;

  const VehicleListCard({
    super.key,
    required this.vehicle,
    required this.onTap,
  });

  String _getCategory() {
    final value = vehicle.vehicleClass.toString().toLowerCase();

    if (value.contains('tanker')) return 'Tanker';
    if (value.contains('trailer')) return 'Trailer';
    if (value.contains('truck')) return 'Truck';

    return vehicle.vehicleClass.toString();
  }

  IconData _getIcon() {
    final category = _getCategory().toLowerCase();

    if (category.contains('tanker')) {
      return Icons.water_drop_rounded;
    }

    if (category.contains('trailer')) {
      return Icons.rv_hookup_rounded;
    }

    return Icons.local_shipping_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final category = _getCategory();

    final isActive = vehicle.status.toString().trim().toUpperCase() == 'ACTIVE';

    final statusColor = isActive ? AppColors.success : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.55),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_getIcon(), size: 22, color: AppColors.primary),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.vehicleNumber.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${vehicle.make} ${vehicle.model}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.business_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              vehicle.firmName.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        vehicle.status.toString(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
