/// Border radius tokens ala FlutterShop Free Version.
///
/// Lihat: `FlutterShop Free Version/lib/constants.dart`:
/// ```dart
/// const double defaultBorderRadious = 12.0;
/// ```
///
/// FlutterShop hierarchy:
/// - `defaultBorderRadious` (12)     → input, button, card kecil, badge
/// - `defaultPadding` (16)           → network image default, banner image
/// - `defaultBorderRadious * 2` (24) → credit card, modal bottom sheet
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 5.
class AppRadius {
  AppRadius._();

  static const double sm   = 8;    // small chip
  static const double md   = 12;   // defaultBorderRadious — input, button, card
  static const double lg   = 16;   // defaultPadding — banner, network image
  static const double xl   = 20;
  static const double xxl  = 24;   // defaultBorderRadious * 2 — modal, card hero
  static const double pill = 999;
}
