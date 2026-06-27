import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../shared/widgets/category_badge.dart';
import '../../../../core/theme/app_palette.dart';

/// TicketCard User ala FlutterShop — flat, border 1 px, radius 12, miniRight.svg chevron.
class TicketCard extends StatelessWidget {
  final String ticketId;
  final String title;
  final String category;
  final String status;
  final String date;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticketId,
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    required this.onTap,
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticketId,
                    style: AppTextStyles.caption(c).copyWith(
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    style: AppTextStyles.body(c).copyWith(
                      fontWeight: FontWeight.w500,
                      color: c.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      CategoryBadge(category: category),
                      const SizedBox(width: AppSpacing.sm),
                      StatusBadge(status: status),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    date,
                    style: AppTextStyles.caption(c)
                        .copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SvgPicture.asset(
              'assets/icons/miniRight.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
