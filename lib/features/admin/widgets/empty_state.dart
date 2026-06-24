import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_palette.dart';

/// EmptyState ala FlutterShop — icon muted 80×80, text center.
/// Gunakan [svgAsset] untuk ikon SVG (lebih diutamakan), atau [icon] Material.
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRefresh;
  final String? svgAsset;
  final IconData? icon;

  const EmptyState({
    super.key,
    this.title = 'Belum ada data',
    this.message = 'Data akan muncul setelah tersedia',
    this.onRefresh,
    this.svgAsset,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: c.textTertiary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: svgAsset != null
                    ? SvgPicture.asset(
                        svgAsset!,
                        width: 40,
                        height: 40,
                        colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
                      )
                    : Icon(icon, size: 40, color: c.textTertiary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTextStyles.h3(c).copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: AppSpacing.lg),
              TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
                style: TextButton.styleFrom(foregroundColor: c.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
