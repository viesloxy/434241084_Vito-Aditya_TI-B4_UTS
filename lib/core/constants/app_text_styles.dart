import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography tokens — font family `Plus Jakarta Display` (disalin dari
/// `FlutterShop Free Version/assets/fonts/plus_jakarta/`).
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 3.
class AppTextStyles {
  AppTextStyles._();

  // ===== Headings =====
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 28, fontWeight: FontWeight.w700,
    height: 1.25, color: AppColors.textPrimary,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 22, fontWeight: FontWeight.w700,
    height: 1.3, color: AppColors.textPrimary,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 18, fontWeight: FontWeight.w700,
    height: 1.35, color: AppColors.textPrimary,
  );
  static const TextStyle h4 = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 16, fontWeight: FontWeight.w600,
    height: 1.4, color: AppColors.textPrimary,
  );

  // ===== Body =====
  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 16, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.textPrimary,
  );
  static const TextStyle body = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.textPrimary,
  );
  static const TextStyle bodySm = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 13, fontWeight: FontWeight.w400,
    height: 1.45, color: AppColors.textSecondary,
  );

  // ===== Label / Caption =====
  static const TextStyle label = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 14, fontWeight: FontWeight.w500,
    height: 1.4, color: AppColors.textPrimary,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 12, fontWeight: FontWeight.w400,
    height: 1.35, color: AppColors.textSecondary,
  );
  static const TextStyle overline = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 11, fontWeight: FontWeight.w600,
    height: 1.4, color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // ===== Button =====
  static const TextStyle button = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 16, fontWeight: FontWeight.w700,
    height: 1.25, color: AppColors.textOnPrimary,
  );
  static const TextStyle buttonSm = TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 14, fontWeight: FontWeight.w600,
    height: 1.3, color: AppColors.textOnPrimary,
  );
}
