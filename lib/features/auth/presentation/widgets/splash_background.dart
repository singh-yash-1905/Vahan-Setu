import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Main background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark,
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
          ),
        ),

        // Top glow
        Positioned(
          top: -size.width * 0.35,
          right: -size.width * 0.25,
          child: _GlowCircle(
            size: size.width * 0.9,
            color: AppColors.primary,
            opacity: 0.55,
          ),
        ),

        // Bottom accent glow
        Positioned(
          bottom: -size.width * 0.45,
          left: -size.width * 0.35,
          child: _GlowCircle(
            size: size.width * 0.9,
            color: AppColors.accent,
            opacity: 0.12,
          ),
        ),

        // Top decorative ring
        Positioned(
              top: -80,
              left: -80,
              child: _DecorativeRing(size: 230, opacity: 0.20),
            )
            .animate()
            .fadeIn(duration: 1100.ms, curve: Curves.easeOut)
            .rotate(
              begin: -0.08,
              end: 0.12,
              duration: 4200.ms,
              curve: Curves.easeInOut,
            ),

        // Bottom decorative ring
        Positioned(
              bottom: -100,
              right: -80,
              child: _DecorativeRing(size: 260, opacity: 0.14),
            )
            .animate()
            .fadeIn(delay: 300.ms, duration: 1100.ms)
            .rotate(
              begin: 0.08,
              end: -0.10,
              duration: 4500.ms,
              curve: Curves.easeInOut,
            ),

        // Floating particles
        Positioned(
              top: size.height * 0.20,
              left: size.width * 0.12,
              child: const _Particle(size: 5),
            )
            .animate()
            .fadeIn(delay: 500.ms, duration: 900.ms)
            .moveY(
              begin: 6,
              end: -6,
              duration: 2600.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .moveY(
              begin: -6,
              end: 6,
              duration: 2600.ms,
              curve: Curves.easeInOut,
            ),

        Positioned(
              top: size.height * 0.28,
              right: size.width * 0.13,
              child: const _Particle(size: 4),
            )
            .animate()
            .fadeIn(delay: 700.ms, duration: 900.ms)
            .moveY(
              begin: -5,
              end: 6,
              duration: 2800.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .moveY(
              begin: 6,
              end: -5,
              duration: 2800.ms,
              curve: Curves.easeInOut,
            ),

        Positioned(
              bottom: size.height * 0.25,
              left: size.width * 0.18,
              child: const _Particle(size: 3),
            )
            .animate()
            .fadeIn(delay: 900.ms, duration: 900.ms)
            .moveY(
              begin: 4,
              end: -4,
              duration: 3000.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: opacity * 0.35),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _DecorativeRing extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeRing({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accent.withValues(alpha: opacity),
          width: 2,
        ),
      ),
    );
  }
}

class _Particle extends StatelessWidget {
  final double size;

  const _Particle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent.withValues(alpha: 0.6),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.35),
            blurRadius: 7,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
