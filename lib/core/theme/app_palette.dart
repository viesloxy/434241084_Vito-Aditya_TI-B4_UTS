import 'package:flutter/material.dart';

/// ThemeExtension untuk color palette yang adaptive light/dark.
///
/// Gunakan `context.palette.xxx` di widget untuk mendapat warna yang
/// sesuai dengan mode saat ini (otomatis light/dark via `Theme.of(context)`).
///
/// `AppColors` di `lib/core/constants/app_colors.dart` adalah source of truth
/// untuk light mode (backward compatibility). `AppPalette.light` harus identik
/// dengan `AppColors` agar migrasi inkremental konsisten.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  // Brand
  final Color primary;
  final Color primaryHover;
  final Color primaryPressed;
  final Color primaryLight;
  final Color primaryDark;
  final List<Color> primaryGradient;
  final Color textOnPrimary;

  // Surface
  final Color background;
  final Color surface;
  final Color surfaceAlt;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;

  // Border
  final Color border;
  final Color divider;

  // Semantic
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color error;
  final Color errorLight;
  final Color info;
  final Color infoLight;

  // Status tiket
  final Color statusBaruBg;
  final Color statusBaruText;
  final Color statusProsesBg;
  final Color statusProsesText;
  final Color statusSelesaiBg;
  final Color statusSelesaiText;
  final Color statusTolakBg;
  final Color statusTolakText;

  // Priority
  final Color priorityLowBg;
  final Color priorityLowText;
  final Color priorityMedBg;
  final Color priorityMedText;
  final Color priorityHighBg;
  final Color priorityHighText;

  // Input
  final Color inputFill;
  final Color inputBorder;
  final Color inputBorderFocus;

  const AppPalette({
    required this.primary,
    required this.primaryHover,
    required this.primaryPressed,
    required this.primaryLight,
    required this.primaryDark,
    required this.primaryGradient,
    required this.textOnPrimary,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.border,
    required this.divider,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.infoLight,
    required this.statusBaruBg,
    required this.statusBaruText,
    required this.statusProsesBg,
    required this.statusProsesText,
    required this.statusSelesaiBg,
    required this.statusSelesaiText,
    required this.statusTolakBg,
    required this.statusTolakText,
    required this.priorityLowBg,
    required this.priorityLowText,
    required this.priorityMedBg,
    required this.priorityMedText,
    required this.priorityHighBg,
    required this.priorityHighText,
    required this.inputFill,
    required this.inputBorder,
    required this.inputBorderFocus,
  });

  /// Light palette — source of truth = `AppColors`.
  static const AppPalette light = AppPalette(
    primary: Color(0xFF3921D9),
    primaryHover: Color(0xFF2A18B8),
    primaryPressed: Color(0xFF1F118F),
    primaryLight: Color(0xFFEFEBFF),
    primaryDark: Color(0xFF1F118F),
    primaryGradient: [Color(0xFF3921D9), Color(0xFF5028E8)],
    textOnPrimary: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFFAFBFE),
    textPrimary: Color(0xFF16161E),
    textSecondary: Color(0xFF737378),
    textTertiary: Color(0xFFA2A2A5),
    textDisabled: Color(0xFFD0D0D2),
    border: Color(0xFFE8E8E9),
    divider: Color(0xFFF3F3F4),
    success: Color(0xFF22C55E),
    successLight: Color(0xFFDCFCE7),
    warning: Color(0xFFF59E0B),
    warningLight: Color(0xFFFEF3C7),
    error: Color(0xFFEF4444),
    errorLight: Color(0xFFFEE2E2),
    info: Color(0xFF0EA5E9),
    infoLight: Color(0xFFE0F2FE),
    statusBaruBg: Color(0xFFFEF3C7),
    statusBaruText: Color(0xFF92400E),
    statusProsesBg: Color(0xFFE0F2FE),
    statusProsesText: Color(0xFF0369A1),
    statusSelesaiBg: Color(0xFFDCFCE7),
    statusSelesaiText: Color(0xFF166534),
    statusTolakBg: Color(0xFFFEE2E2),
    statusTolakText: Color(0xFF991B1B),
    priorityLowBg: Color(0xFFDCFCE7),
    priorityLowText: Color(0xFF166534),
    priorityMedBg: Color(0xFFFEF3C7),
    priorityMedText: Color(0xFF92400E),
    priorityHighBg: Color(0xFFFEE2E2),
    priorityHighText: Color(0xFF991B1B),
    inputFill: Color(0xFFF8F8F9),
    inputBorder: Color(0xFFE8E8E9),
    inputBorderFocus: Color(0xFF3921D9),
  );

  /// Dark palette — primary dinaikkan ke `#7B6CF0` untuk kontras.
  /// Background `#0F1115` deep neutral (bukan pure black).
  static const AppPalette dark = AppPalette(
    primary: Color(0xFF7B6CF0),
    primaryHover: Color(0xFF8E80F4),
    primaryPressed: Color(0xFF6A5FE6),
    primaryLight: Color(0xFF2A2654),
    primaryDark: Color(0xFF5849C7),
    primaryGradient: [Color(0xFF7B6CF0), Color(0xFF8E80F4)],
    textOnPrimary: Color(0xFFFFFFFF),
    background: Color(0xFF0F1115),
    surface: Color(0xFF1A1C22),
    surfaceAlt: Color(0xFF22252D),
    textPrimary: Color(0xFFF2F2F5),
    textSecondary: Color(0xFFA8A8B0),
    textTertiary: Color(0xFF737378),
    textDisabled: Color(0xFF50525A),
    border: Color(0xFF2A2D34),
    divider: Color(0xFF22252D),
    success: Color(0xFF34D399),
    successLight: Color(0xFF14322A),
    warning: Color(0xFFFBBF24),
    warningLight: Color(0xFF3A2D14),
    error: Color(0xFFF87171),
    errorLight: Color(0xFF3A1C1C),
    info: Color(0xFF38BDF8),
    infoLight: Color(0xFF143142),
    statusBaruBg: Color(0xFF3A2D14),
    statusBaruText: Color(0xFFFBBF24),
    statusProsesBg: Color(0xFF143142),
    statusProsesText: Color(0xFF38BDF8),
    statusSelesaiBg: Color(0xFF14322A),
    statusSelesaiText: Color(0xFF34D399),
    statusTolakBg: Color(0xFF3A1C1C),
    statusTolakText: Color(0xFFF87171),
    priorityLowBg: Color(0xFF14322A),
    priorityLowText: Color(0xFF34D399),
    priorityMedBg: Color(0xFF3A2D14),
    priorityMedText: Color(0xFFFBBF24),
    priorityHighBg: Color(0xFF3A1C1C),
    priorityHighText: Color(0xFFF87171),
    inputFill: Color(0xFF22252D),
    inputBorder: Color(0xFF2A2D34),
    inputBorderFocus: Color(0xFF7B6CF0),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? primaryHover,
    Color? primaryPressed,
    Color? primaryLight,
    Color? primaryDark,
    List<Color>? primaryGradient,
    Color? textOnPrimary,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? border,
    Color? divider,
    Color? success,
    Color? successLight,
    Color? warning,
    Color? warningLight,
    Color? error,
    Color? errorLight,
    Color? info,
    Color? infoLight,
    Color? statusBaruBg,
    Color? statusBaruText,
    Color? statusProsesBg,
    Color? statusProsesText,
    Color? statusSelesaiBg,
    Color? statusSelesaiText,
    Color? statusTolakBg,
    Color? statusTolakText,
    Color? priorityLowBg,
    Color? priorityLowText,
    Color? priorityMedBg,
    Color? priorityMedText,
    Color? priorityHighBg,
    Color? priorityHighText,
    Color? inputFill,
    Color? inputBorder,
    Color? inputBorderFocus,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      info: info ?? this.info,
      infoLight: infoLight ?? this.infoLight,
      statusBaruBg: statusBaruBg ?? this.statusBaruBg,
      statusBaruText: statusBaruText ?? this.statusBaruText,
      statusProsesBg: statusProsesBg ?? this.statusProsesBg,
      statusProsesText: statusProsesText ?? this.statusProsesText,
      statusSelesaiBg: statusSelesaiBg ?? this.statusSelesaiBg,
      statusSelesaiText: statusSelesaiText ?? this.statusSelesaiText,
      statusTolakBg: statusTolakBg ?? this.statusTolakBg,
      statusTolakText: statusTolakText ?? this.statusTolakText,
      priorityLowBg: priorityLowBg ?? this.priorityLowBg,
      priorityLowText: priorityLowText ?? this.priorityLowText,
      priorityMedBg: priorityMedBg ?? this.priorityMedBg,
      priorityMedText: priorityMedText ?? this.priorityMedText,
      priorityHighBg: priorityHighBg ?? this.priorityHighBg,
      priorityHighText: priorityHighText ?? this.priorityHighText,
      inputFill: inputFill ?? this.inputFill,
      inputBorder: inputBorder ?? this.inputBorder,
      inputBorderFocus: inputBorderFocus ?? this.inputBorderFocus,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      statusBaruBg: Color.lerp(statusBaruBg, other.statusBaruBg, t)!,
      statusBaruText: Color.lerp(statusBaruText, other.statusBaruText, t)!,
      statusProsesBg: Color.lerp(statusProsesBg, other.statusProsesBg, t)!,
      statusProsesText: Color.lerp(statusProsesText, other.statusProsesText, t)!,
      statusSelesaiBg: Color.lerp(statusSelesaiBg, other.statusSelesaiBg, t)!,
      statusSelesaiText: Color.lerp(statusSelesaiText, other.statusSelesaiText, t)!,
      statusTolakBg: Color.lerp(statusTolakBg, other.statusTolakBg, t)!,
      statusTolakText: Color.lerp(statusTolakText, other.statusTolakText, t)!,
      priorityLowBg: Color.lerp(priorityLowBg, other.priorityLowBg, t)!,
      priorityLowText: Color.lerp(priorityLowText, other.priorityLowText, t)!,
      priorityMedBg: Color.lerp(priorityMedBg, other.priorityMedBg, t)!,
      priorityMedText: Color.lerp(priorityMedText, other.priorityMedText, t)!,
      priorityHighBg: Color.lerp(priorityHighBg, other.priorityHighBg, t)!,
      priorityHighText: Color.lerp(priorityHighText, other.priorityHighText, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputBorderFocus: Color.lerp(inputBorderFocus, other.inputBorderFocus, t)!,
    );
  }
}

/// Extension untuk akses palette via `context.palette.xxx`.
extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
