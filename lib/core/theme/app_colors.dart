import 'package:flutter/material.dart';

class AppColors {
  // Primary (Reliability, Stability, Structure)
  static const Color primary = Color(
    0xFF1E293B,
  ); // Deep Navy/Slate Blue (softer than black)
  static const Color primaryDark = Color(
    0xFF0F172A,
  ); // Very dark navy for app bars

  // Accent (Safety, Growth, Action)
  static const Color accent = Color(
    0xFF10B981,
  ); // Bright Emerald Green for buttons
  static const Color accentDark = Color(
    0xFF0F766E,
  ); // Deep Teal for hovered/pressed states

  // Backgrounds & Surfaces (High Contrast)
  static const Color background = Color(
    0xFFF1F5F9,
  ); // Light slate-grey for the main background
  static const Color surface =
      Colors.white; // White for cards to pop against the background

  // Typography
  static const Color textPrimary = Color(
    0xFF0F172A,
  ); // Dark navy for maximum readability
  static const Color textSecondary = Color(
    0xFF64748B,
  ); // Mid-grey for subtitles
  static const Color textLight =
      Colors.white; // Text on primary or accent colors

  // Semantic (Status indicators)
  static const Color success = Color(0xFF10B981); // Emerald (Matches accent)
  static const Color warning = Color(0xFFF59E0B); // Amber for 'due soon'
  static const Color error = Color(
    0xFFEF4444,
  ); // Red for 'overdue' or 'rejected'

  // Borders
  static const Color border = Color(0xFFCBD5E1);
  // Add to AppColors class
  static const Color cardGreyBg = Color(0xFFF3F4F6);
  static const Color cardPeachBg = Color(0xFFFFF7ED);
  static const Color cardRedBg = Color(0xFFFEF2F2);
  static const Color cardGreenBg = Color(0xFFECFDF5);

  static const Color iconPeach = Color(0xFFF97316);
  static const Color iconRed = Color(0xFFEF4444);
  static const Color iconGreen = Color(0xFF10B981);
}
