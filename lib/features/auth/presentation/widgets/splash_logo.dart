import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft glow
        Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.20),
                    AppColors.primary.withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.65, 0.65),
              end: const Offset(1, 1),
              duration: 1400.ms,
              curve: Curves.easeOutBack,
            ),

        // Outer animated ring
        Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.45),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(top: -3, left: 48, child: _RingAccent(width: 45)),
                  Positioned(
                    bottom: -3,
                    right: 35,
                    child: _RingAccent(width: 30, opacity: 0.65),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: 300.ms, duration: 1100.ms)
            .rotate(
              begin: -0.15,
              end: 0.15,
              duration: 2200.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .rotate(
              begin: 0.15,
              end: -0.15,
              duration: 2200.ms,
              curve: Curves.easeInOut,
            ),

        // Main truck icon
        Container(
              width: 128,
              height: 128,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryDark,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.18),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_shipping_rounded,
                size: 62,
                color: AppColors.accent,
              ),
            )
            .animate()
            .fadeIn(delay: 450.ms, duration: 1200.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.45, 0.45),
              end: const Offset(1, 1),
              duration: 1500.ms,
              curve: Curves.easeOutBack,
            )
            .then()
            .shimmer(
              delay: 400.ms,
              duration: 1800.ms,
              color: Colors.white.withValues(alpha: 0.22),
            ),
      ],
    );
  }
}

class _RingAccent extends StatelessWidget {
  final double width;
  final double opacity;

  const _RingAccent({required this.width, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.55 * opacity),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
