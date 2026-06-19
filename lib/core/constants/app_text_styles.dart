import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

/// Typography tokens — font family `Plus Jakarta Display` (disalin dari
/// `FlutterShop Free Version/assets/fonts/plus_jakarta/`).
///
/// Setiap style adalah function yang menerima `AppPalette` agar teks adaptif
/// ke light/dark mode. Contoh: `AppTextStyles.h3(c)` atau
/// `AppTextStyles.body.copyWith(color: c.primary)`.
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 3.
class AppTextStyles {
  AppTextStyles._();

  // ===== Headings =====
  static TextStyle h1(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 28, fontWeight: FontWeight.w700,
    height: 1.25, color: c.textPrimary,
  );
  static TextStyle h2(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 22, fontWeight: FontWeight.w700,
    height: 1.3, color: c.textPrimary,
  );
  static TextStyle h3(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 18, fontWeight: FontWeight.w700,
    height: 1.35, color: c.textPrimary,
  );
  static TextStyle h4(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 16, fontWeight: FontWeight.w600,
    height: 1.4, color: c.textPrimary,
  );

  // ===== Body =====
  static TextStyle bodyLg(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 16, fontWeight: FontWeight.w400,
    height: 1.5, color: c.textPrimary,
  );
  static TextStyle body(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 14, fontWeight: FontWeight.w400,
    height: 1.5, color: c.textPrimary,
  );
  static TextStyle bodySm(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 13, fontWeight: FontWeight.w400,
    height: 1.45, color: c.textSecondary,
  );

  // ===== Label / Caption =====
  static TextStyle label(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 14, fontWeight: FontWeight.w500,
    height: 1.4, color: c.textPrimary,
  );
  static TextStyle caption(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 12, fontWeight: FontWeight.w400,
    height: 1.35, color: c.textSecondary,
  );
  static TextStyle overline(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 11, fontWeight: FontWeight.w600,
    height: 1.4, color: c.textSecondary,
    letterSpacing: 0.5,
  );

  // ===== Button =====
  static TextStyle button(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 16, fontWeight: FontWeight.w700,
    height: 1.25, color: c.textOnPrimary,
  );
  static TextStyle buttonSm(AppPalette c) => TextStyle(
    fontFamily: 'Plus Jakarta',
    fontSize: 14, fontWeight: FontWeight.w600,
    height: 1.3, color: c.textOnPrimary,
  );
}
