import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';
import 'splash_logo.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SplashLogo(),

                const SizedBox(height: 34),

                // App name
                RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Vahan ',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          TextSpan(
                            text: 'Setu',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(
                      delay: 650.ms,
                      duration: 1000.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.25,
                      end: 0,
                      duration: 1100.ms,
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: 10),

                // Subtitle
                Text(
                      'Secure Logistics Management',
                      style: TextStyle(
                        color: AppColors.textLight.withValues(alpha: 0.72),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.7,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 950.ms, duration: 1000.ms)
                    .slideY(
                      begin: 0.18,
                      end: 0,
                      duration: 1000.ms,
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: 42),

                // Loading bar
                SizedBox(
                      width: 54,
                      height: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.textLight.withValues(
                            alpha: 0.10,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.accent,
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1200.ms, duration: 700.ms)
                    .scaleX(
                      begin: 0.15,
                      end: 1,
                      duration: 1000.ms,
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: 14),

                // Status text
                Text(
                  'Connecting to your fleet...',
                  style: TextStyle(
                    color: AppColors.textLight.withValues(alpha: 0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ).animate().fadeIn(delay: 1400.ms, duration: 800.ms),
              ],
            ),
          ),

          // Bottom branding
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'TRANSPORT • TRACK • MANAGE',
                style: TextStyle(
                  color: AppColors.textLight.withValues(alpha: 0.28),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 1600.ms, duration: 800.ms),
            ),
          ),
        ],
      ),
    );
  }
}
