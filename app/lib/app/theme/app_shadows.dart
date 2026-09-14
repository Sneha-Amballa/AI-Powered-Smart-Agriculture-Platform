import 'package:flutter/material.dart';

/// Centralized Shadow and Elevation tokens.
/// Built with low opacity and high blur for clean, modern depth without harsh shadows.
class AppShadows {
  // Level 1: Subtle card depth
  static final List<BoxShadow> card = [
    BoxShadow(
      color: const Color(0xFF1B241E).withValues(alpha: 0.04),
      offset: const Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: const Color(0xFF1B241E).withValues(alpha: 0.02),
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  // Level 2: Interactive / elevated state (hover, active card)
  static final List<BoxShadow> elevated = [
    BoxShadow(
      color: const Color(0xFF1B241E).withValues(alpha: 0.08),
      offset: const Offset(0, 6),
      blurRadius: 16,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: const Color(0xFF1B241E).withValues(alpha: 0.03),
      offset: const Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  // Level 3: Modal / Floating Sheet / Navigation bar
  static final List<BoxShadow> floating = [
    BoxShadow(
      color: const Color(0xFF1B241E).withValues(alpha: 0.12),
      offset: const Offset(0, 12),
      blurRadius: 28,
      spreadRadius: -4,
    ),
  ];

  // Soft glow for primary elements (like CTAs)
  static final List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: const Color(0xFF2D6A4F).withValues(alpha: 0.25),
      offset: const Offset(0, 4),
      blurRadius: 14,
      spreadRadius: 0,
    ),
  ];
}
