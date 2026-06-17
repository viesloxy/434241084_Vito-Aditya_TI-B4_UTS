import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';

/// StatCard ala FlutterShop — flat, border 1 px, radius 12.
///
/// Pewarnaan: angka & judul pakai `textPrimary` (netral), icon container
/// pakai `primaryLight` dengan icon `textPrimary` (netral gelap), chevron
/// pakai `textTertiary`. Primary TIDAK dipakai — sesuai style guide section 2
/// ("Primary hanya untuk CTA utama, tab aktif, link, focus state").
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 7.3 (Cards).
class AdminStatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final VoidCallback? onTap;

  const AdminStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon di soft container, icon sendiri netral (bukan primary)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.textPrimary),
                ),
                // Chevron netral
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Angka NETRAL (bukan primary)
            Text(
              count.toString(),
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                fontSize: 28,
                height: 1.1,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // Judul di-override ke secondary (label-style)
            Text(
              title,
              style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
