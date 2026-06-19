import 'package:flutter/material.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_palette.dart';

/// Filter chip ala FlutterShop — pill rounded 12.
///
/// Pewarnaan:
/// - **Default**: bg `surface`, border `border`, text & icon `textPrimary`.
/// - **Active**  : bg `primary`, text & icon `textOnPrimary` (CTA pattern).
/// - Counter badge: `primaryLight` + `primary` (default) / `primary` + `textOnPrimary` (active).
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 7.6c.
class AdminCategoryChip extends StatelessWidget {
  final String category;
  final int count;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const AdminCategoryChip({
    super.key,
    required this.category,
    required this.count,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    // Token-driven warna — single source of truth (AppColors)
    final bg = isActive ? c.primary : c.surface;
    final fg = isActive ? c.textOnPrimary : c.textPrimary;
    final iconColor = isActive ? c.textOnPrimary : c.textPrimary;
    final badgeBg = isActive ? c.textOnPrimary.withValues(alpha: 0.2) : c.primaryLight;
    final badgeFg = isActive ? c.textOnPrimary : c.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive ? c.primary : c.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              category,
              style: AppTextStyles.bodySm(c).copyWith(color: fg, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: AppTextStyles.overline(c).copyWith(
                  color: badgeFg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
