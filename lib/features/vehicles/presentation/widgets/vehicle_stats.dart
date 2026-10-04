import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class VehicleStats extends StatelessWidget {
  final int total;
  final int truck;
  final int trailer;
  final int tanker;

  const VehicleStats({
    super.key,
    required this.total,
    required this.truck,
    required this.trailer,
    required this.tanker,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: total,
              label: 'Total',
              icon: Icons.directions_car_rounded,
              color: AppColors.primary,
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatItem(
              value: truck,
              label: 'Truck',
              icon: Icons.local_shipping_rounded,
              color: AppColors.accent,
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatItem(
              value: trailer,
              label: 'Trailer',
              icon: Icons.rv_hookup_rounded,
              color: AppColors.warning,
            ),
          ),
          _Divider(),
          Expanded(
            child: _StatItem(
              value: tanker,
              label: 'Tanker',
              icon: Icons.water_drop_rounded,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 19, color: color),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.border.withValues(alpha: 0.5),
    );
  }
}
