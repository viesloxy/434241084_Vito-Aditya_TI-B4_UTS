import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_palette.dart';

/// StatCard User ala FlutterShop — flat, border 1 px, radius 12, SVG icon.
/// Matches AdminStatCard / HelpdeskStatCard exactly.
class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final String svgAsset;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.svgAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: c.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      svgAsset,
                      width: 20,
                      height: 20,
                      colorFilter:
                          ColorFilter.mode(c.primary, BlendMode.srcIn),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/miniRight.svg',
                  width: 16,
                  height: 16,
                  colorFilter:
                      ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              count.toString(),
              style: AppTextStyles.h1(c).copyWith(
                color: c.textPrimary,
                fontSize: 28,
                height: 1.1,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTextStyles.bodySm(c).copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
