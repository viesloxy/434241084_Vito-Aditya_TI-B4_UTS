import 'package:flutter/material.dart';
import '../constants/app_radius.dart';
import '../constants/app_shadow.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import 'app_palette.dart';

/// Global theme — Material 3 + tokens dari style guide.
///
/// Mendukung light & dark mode via `AppPalette` ThemeExtension.
/// `lightTheme` dan `darkTheme` keduanya dipakai di `MaterialApp`.
///
/// Konvensi FlutterShop (lihat `lib/constants.dart`):
/// - `defaultPadding = 16`      → outer page padding
/// - `defaultBorderRadious = 12` → radius default (input/button/card)
/// - `fontFamily: "Plus Jakarta"`
/// - `scaffoldBackgroundColor: Colors.white` (light) / deep neutral (dark)
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 0 & 6.
class AppTheme {
  AppTheme._();

  /// Build ThemeData dari AppPalette (parametric untuk light/dark).
  static ThemeData _buildTheme(AppPalette c) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta',
      brightness: c.background.computeLuminance() > 0.5
          ? Brightness.light
          : Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.primary,
        brightness: c.background.computeLuminance() > 0.5
            ? Brightness.light
            : Brightness.dark,
        primary: c.primary,
        onPrimary: c.textOnPrimary,
        surface: c.surface,
        onSurface: c.textPrimary,
      ),
      scaffoldBackgroundColor: c.background,
      iconTheme: IconThemeData(color: c.textPrimary),

      // ===== TextTheme (ala FlutterShop: titleSmall untuk section header) =====
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Plus Jakarta',
          color: c.textSecondary,
          fontSize: 14,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Plus Jakarta',
          color: c.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),

      // ===== AppBar (ala FlutterShop: flat surface, elevation 0) =====
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: c.textPrimary, size: 24),
        titleTextStyle: TextStyle(
          fontFamily: 'Plus Jakarta',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: c.textPrimary,
        ),
      ),

      // ===== ElevatedButton (ala FlutterShop) =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.lg),
          backgroundColor: c.primary,
          foregroundColor: c.textOnPrimary,
          minimumSize: const Size(double.infinity, 32),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          textStyle: AppTextStyles.button(c),
          elevation: 0,
        ),
      ),

      // ===== OutlinedButton (ala FlutterShop) =====
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.lg),
          minimumSize: const Size(double.infinity, 32),
          side: BorderSide(color: c.border, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
        ),
      ),

      // ===== TextButton (ala FlutterShop: fg = primary) =====
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: c.primary),
      ),

      // ===== InputDecoration (ala FlutterShop) =====
      inputDecorationTheme: InputDecorationTheme(
        fillColor: c.inputFill,
        filled: true,
        hintStyle: TextStyle(color: c.textTertiary),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: c.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: c.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: c.error),
        ),
      ),

      // ===== Card (flat 2D ala FlutterShop) =====
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          side: BorderSide(color: c.border, width: 1),
        ),
      ),

      // ===== Divider =====
      dividerTheme: DividerThemeData(
        color: c.divider,
        thickness: 1,
        space: 1,
      ),

      // ===== Snackbar (custom, floating) =====
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.textPrimary,
        contentTextStyle: AppTextStyles.body(c).copyWith(color: c.background),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),

      // ===== Checkbox =====
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: c.textTertiary, width: 1.5),
      ),

      // ===== BottomSheet =====
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
        clipBehavior: Clip.hardEdge,
      ),

      // ===== Dialog =====
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
          side: BorderSide(color: c.border, width: 1),
        ),
      ),

      // ===== ProgressIndicator =====
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.surfaceAlt,
        circularTrackColor: c.surfaceAlt,
      ),

      // ===== ListTile =====
      listTileTheme: ListTileThemeData(
        iconColor: c.textSecondary,
        textColor: c.textPrimary,
        tileColor: c.surface,
      ),

      // ===== AppPalette ThemeExtension =====
      extensions: <ThemeExtension<dynamic>>[
        c,
      ],
    );
  }

  static ThemeData get lightTheme => _buildTheme(AppPalette.light);
  static ThemeData get darkTheme => _buildTheme(AppPalette.dark);

  // Re-export shadow tokens agar import ringkas.
  static const List<BoxShadow> fab = AppShadow.fab;
  static const List<BoxShadow> dialog = AppShadow.dialog;
  static const List<BoxShadow> none = AppShadow.none;
}
