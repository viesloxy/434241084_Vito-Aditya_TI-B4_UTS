import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_shadow.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Global theme — Material 3 + tokens dari style guide.
///
/// Diadopsi dari `FlutterShop Free Version/lib/theme/app_theme.dart`,
/// `input_decoration_theme.dart`, dan `button_theme.dart`.
///
/// Konvensi FlutterShop (lihat `lib/constants.dart`):
/// - `defaultPadding = 16`      → outer page padding
/// - `defaultBorderRadious = 12` → radius default (input/button/card)
/// - `fontFamily: "Plus Jakarta"`
/// - `scaffoldBackgroundColor: Colors.white`
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 0 & 6.
class AppTheme {
  AppTheme._();

  /// Input fill. FlutterShop `lightGreyColor = #F8F8F9`.
  static const Color _inputFill = AppColors.inputFill;

  /// Border default. FlutterShop `Colors.transparent` (no visible border
  /// sampai focus). Kita pakai `inputBorder` (`#E8E8E9`) untuk fallback.
  static const OutlineInputBorder _outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)), // 12
    borderSide: BorderSide(color: Colors.transparent),
  );

  static const OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
    borderSide: BorderSide(color: AppColors.primary),
  );

  static const OutlineInputBorder _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
    borderSide: BorderSide(color: AppColors.error),
  );

  /// Input decoration ala FlutterShop:
  /// - fill `lightGreyColor` (`#F8F8F9`)
  /// - border transparan
  /// - focused border primary 1 px
  /// - hint color `greyColor` (`#B8B5C3`)
  /// - **TIDAK set contentPadding** → pakai default Material
  static const InputDecorationTheme _inputDecoration = InputDecorationTheme(
    fillColor: _inputFill,
    filled: true,
    hintStyle: TextStyle(color: Color(0xFFB8B5C3)), // greyColor FlutterShop
    border: _outlineBorder,
    enabledBorder: _outlineBorder,
    focusedBorder: _focusedBorder,
    errorBorder: _errorBorder,
    focusedErrorBorder: _errorBorder,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta',
      brightness: Brightness.light,
      // FlutterShop: primarySwatch + primaryColor = #7B61FF.
      // Kita override dengan brand #3921D9.
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      // FlutterShop: scaffoldBackgroundColor: Colors.white (kita override juga).
      scaffoldBackgroundColor: AppColors.background,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),

      // ===== AppBar (ala FlutterShop: white, elevation 0) =====
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface, // white
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 24),
        titleTextStyle: TextStyle(
          fontFamily: 'Plus Jakarta',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),

      // ===== ElevatedButton (ala FlutterShop) =====
      // padding all 16, min tinggi 32, radius 12.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.lg), // defaultPadding = 16
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size(double.infinity, 32),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          textStyle: AppTextStyles.button, // override ke Plus Jakarta 16/w700
          elevation: 0,
        ),
      ),

      // ===== OutlinedButton (ala FlutterShop) =====
      // side 1.5 px blackColor10 (#E8E8E9). Kita pakai AppColors.border.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.lg),
          minimumSize: const Size(double.infinity, 32),
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
        ),
      ),

      // ===== TextButton (ala FlutterShop: fg = primary) =====
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),

      // ===== InputDecoration (ala FlutterShop, no custom contentPadding) =====
      inputDecorationTheme: _inputDecoration,

      // ===== Card (flat ala product_card OutlinedButton pattern) =====
      // FlutterShop TIDAK set cardTheme — default Card elevation 1.
      // Kita override flat: elevation 0 + border 1 px ala OutlinedButton.
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          side: BorderSide(color: AppColors.border, width: 1),
        ),
      ),

      // ===== Divider =====
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ===== Snackbar (custom, floating) =====
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),

      // ===== Checkbox (ala FlutterShop: side = blackColor40) =====
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.textTertiary, width: 1.5),
      ),

      // BottomSheet default shape ala FlutterShop (radius 24 atas).
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl), // 24
          ),
        ),
        clipBehavior: Clip.hardEdge,
      ),
    );
  }

  // Re-export shadow tokens agar import ringkas.
  static const List<BoxShadow> fab = AppShadow.fab;
  static const List<BoxShadow> dialog = AppShadow.dialog;
  static const List<BoxShadow> none = AppShadow.none;
}
