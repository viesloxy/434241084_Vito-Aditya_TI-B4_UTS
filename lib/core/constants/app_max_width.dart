/// Max-width tokens untuk konten terpusat (centered).
///
/// Tujuannya: di layar lebar (tablet, landscape, web), konten tidak bleed
/// ke edge — terlihat lebih rapi dan "tidak mepet".
///
/// **Default untuk semua form**: `AppMaxWidth.form` (360 dp). Ini dipakai
/// konsisten oleh Login, Register, Create Ticket, dan semua form lain agar
/// lebar body seragam.
///
/// Token lain (`reading`, `infinite`) untuk kasus khusus:
/// - `reading` = body artikel / detail panjang (lebih lebar agar tidak terpotong)
/// - `infinite` = full-bleed (Home, Dashboard, List) — tidak di-center
///
/// Dipakai via `CenteredContent` widget di bawah.
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 4.1.
library;

import 'package:flutter/material.dart';

class AppMaxWidth {
  AppMaxWidth._();

  /// Form standar (Login, Register, Create Ticket, semua form).
  /// **Gunakan ini secara default** untuk konsistensi lebar body.
  static const double form = 360;

  /// Reading content (artikel panjang, profile bio, detail body).
  static const double reading = 600;

  /// Tidak dibatasi (full-bleed ala FlutterShop native).
  /// Dipakai untuk Home, Dashboard, List, dan halaman konten lebar.
  static const double infinite = double.infinity;
}

/// Widget untuk membungkus konten di max-width tertentu, ter-center.
///
/// - `maxWidth: AppMaxWidth.form` (default) → center 360 dp
/// - `maxWidth: AppMaxWidth.reading`       → center 600 dp
/// - `maxWidth: AppMaxWidth.infinite`      → no-op (full-bleed)
///
/// Dipakai:
/// ```dart
/// SingleChildScrollView(
///   padding: const EdgeInsets.all(AppSpacing.lg),
///   child: CenteredContent(   // default maxWidth = form (360)
///     child: Form(...),
///   ),
/// )
/// ```
class CenteredContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const CenteredContent({
    super.key,
    required this.child,
    this.maxWidth = AppMaxWidth.form,
  });

  @override
  Widget build(BuildContext context) {
    if (maxWidth == AppMaxWidth.infinite) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
