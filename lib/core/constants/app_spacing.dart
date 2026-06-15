/// Spacing tokens ala FlutterShop Free Version.
///
/// Lihat: `FlutterShop Free Version/lib/constants.dart`:
/// ```dart
/// const double defaultPadding = 16.0;
/// ```
///
/// Semua spacing di FlutterShop adalah kelipatan dari `defaultPadding`:
/// - `defaultPadding / 4` = 4   → spasi sangat kecil (dot indicator gap)
/// - `defaultPadding / 2` = 8   → spasi setengah (card content internal)
/// - `defaultPadding * 0.75` = 12 → prefix icon vertical padding
/// - `defaultPadding` = 16     → spasi standar (field-to-field, outer pad)
/// - `defaultPadding * 1.5` = 24 → section break
/// - `defaultPadding * 2` = 32 → bottom space sebelum CTA button
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 4.
class AppSpacing {
  AppSpacing._();

  // ===== Named tokens (untuk konsistensi) =====
  static const double xs    = 4;   // defaultPadding / 4
  static const double sm    = 8;   // defaultPadding / 2
  static const double md    = 12;  // defaultPadding * 0.75
  static const double lg    = 16;  // defaultPadding
  static const double xl    = 20;
  static const double xxl   = 24;  // defaultPadding * 1.5
  static const double xxxl  = 32;  // defaultPadding * 2
  static const double huge  = 48;
  static const double mega  = 64;  // cart button height
}
