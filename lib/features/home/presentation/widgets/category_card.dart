import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_palette.dart';

/// CategoryCard User ala FlutterShop — flat, border 1 px, SVG icon, single primary color.
class CategoryCard extends StatelessWidget {
  final String category;
  final int count;
  final String svgAsset;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.count,
    required this.svgAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: c.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgAsset,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category,
              style: AppTextStyles.caption(c).copyWith(
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '$count tiket',
              style: AppTextStyles.overline(c).copyWith(
                color: c.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
