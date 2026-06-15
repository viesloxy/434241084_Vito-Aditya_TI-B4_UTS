import 'package:flutter/material.dart';

/// Shadow tokens. FlutterShop TIDAK pakai shadow di card biasa — hanya di
/// FAB/glow dan promo dialog. Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 6.
///
/// Referensi FlutterShop: `components/buy_full_ui_kit.dart` (dialog shadow).
class AppShadow {
  AppShadow._();

  static const List<BoxShadow> none = <BoxShadow>[];

  /// FAB / primary floating button glow (purple 25% ala FlutterShop).
  static const List<BoxShadow> fab = <BoxShadow>[
    BoxShadow(
      color: Color(0x403921D9), // 25% primary
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  /// Promo dialog / bottom card shadow.
  /// Copy dari `buy_full_ui_kit.dart`:
  /// `color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(4, 10)`
  static const List<BoxShadow> dialog = <BoxShadow>[
    BoxShadow(
      color: Color(0x1A000000), // black 10%
      blurRadius: 20,
      offset: Offset(4, 10),
    ),
  ];

  /// Soft hover/pressed untuk card (opsional, JANGAN default).
  static const List<BoxShadow> cardHover = <BoxShadow>[
    BoxShadow(
      color: Color(0x143921D9),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}
