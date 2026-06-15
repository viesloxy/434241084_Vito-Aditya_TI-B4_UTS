import 'package:flutter/material.dart';

/// Color palette untuk E-Ticketing Helpdesk.
///
/// Primary color (`#3921D9`) diambil dari `assets/logoprimmary.svg` (logo
/// proyek). FlutterShop Free Version hanya dipakai sebagai referensi pola
/// visual (card, radius, shadow, typography) — bukan sumber warna brand.
///
/// Untuk warna netral (abu-abu, scaffold, border, text), diadopsi dari
/// FlutterShop `constants.dart`:
/// - `lightGreyColor = #F8F8F9` → input fill
/// - `blackColor10 = #E8E8E9`   → divider
/// - `blackColor20 = #D0D0D2`   → border
/// - `blackColor40 = #A2A2A5`   → text disabled
/// - `blackColor60 = #737378`   → text secondary
/// - `blackColor80 = #45454B`   → text primary dim
/// - `blackColor = #16161E`     → text primary
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 2 & 3.
class AppColors {
  AppColors._();

  // ===== Brand Primary (logo E-Ticketing Helpdesk) =====
  static const Color primary        = Color(0xFF3921D9); // brand utama (dari logo)
  static const Color primaryHover   = Color(0xFF2A18B8); // tombol saat di-hover
  static const Color primaryPressed = Color(0xFF1F118F); // tombol ditekan lama
  static const Color primaryLight   = Color(0xFFEFEBFF); // bg chip, badge, hover area
  static const Color primaryDark    = Color(0xFF1F118F); // header, gradient end

  /// Gradient brand (untuk splash / hero header).
  static const List<Color> primaryGradient = [
    Color(0xFF3921D9), // primary
    Color(0xFF5028E8), // lighter indigo (accent)
  ];

  // ===== Backgrounds (FlutterShop scaffold = Colors.white) =====
  /// Scaffold background. FlutterShop pakai `Colors.white` — kita override
  /// juga ke putih. Kontras dengan input fill `#F8F8F9` masih visible
  /// (delta luminance ~2.4%).
  static const Color background     = Color(0xFFFFFFFF);

  /// Card / appbar / bottom nav / modal surface.
  static const Color surface        = Color(0xFFFFFFFF);

  /// List item zebra / subtle surface variant.
  static const Color surfaceAlt     = Color(0xFFFAFBFE);

  // ===== Text (ala FlutterShop blackColor family) =====
  static const Color textPrimary    = Color(0xFF16161E); // blackColor FlutterShop
  static const Color textSecondary  = Color(0xFF737378); // blackColor60
  static const Color textTertiary   = Color(0xFFA2A2A5); // blackColor40
  static const Color textDisabled   = Color(0xFFD0D0D2); // blackColor20
  static const Color textOnPrimary  = Color(0xFFFFFFFF);

  // ===== Border & Divider (ala FlutterShop) =====
  static const Color border         = Color(0xFFE8E8E9); // blackColor10
  static const Color divider        = Color(0xFFF3F3F4); // blackColor5

  // ===== Semantic =====
  static const Color success        = Color(0xFF22C55E);
  static const Color successLight   = Color(0xFFDCFCE7);
  static const Color warning        = Color(0xFFF59E0B);
  static const Color warningLight   = Color(0xFFFEF3C7);
  static const Color error          = Color(0xFFEF4444);
  static const Color errorLight     = Color(0xFFFEE2E2);
  static const Color info           = Color(0xFF0EA5E9);
  static const Color infoLight      = Color(0xFFE0F2FE);

  // ===== Status Tiket =====
  static const Color statusBaruBg        = warningLight;
  static const Color statusBaruText      = Color(0xFF92400E);
  static const Color statusProsesBg     = infoLight;
  static const Color statusProsesText    = Color(0xFF075985);
  static const Color statusSelesaiBg    = successLight;
  static const Color statusSelesaiText  = Color(0xFF166534);
  static const Color statusTolakBg      = errorLight;
  static const Color statusTolakText     = Color(0xFF991B1B);

  // ===== Priority =====
  static const Color priorityLowBg     = Color(0xFFE0F2FE);
  static const Color priorityLowText   = Color(0xFF075985);
  static const Color priorityMedBg     = Color(0xFFFEF3C7);
  static const Color priorityMedText   = Color(0xFF92400E);
  static const Color priorityHighBg    = Color(0xFFFEE2E2);
  static const Color priorityHighText  = Color(0xFF991B1B);

  // ===== Input (ala FlutterShop) =====
  /// Fill input field. FlutterShop `lightGreyColor = #F8F8F9`.
  static const Color inputFill       = Color(0xFFF8F8F9);

  /// Input border (sangat halus, default FlutterShop `Colors.transparent`).
  static const Color inputBorder     = Color(0xFFE8E8E9);

  /// Input focus border = primary.
  static const Color inputBorderFocus = primary;
}
