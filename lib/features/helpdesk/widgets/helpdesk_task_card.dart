import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/category_badge.dart';
import '../../../shared/widgets/priority_badge.dart';
import '../../../core/theme/app_palette.dart';

/// TaskCard Helpdesk ala FlutterShop — flat, border 1 px, radius 12.
/// Quick action: "Mulai Kerjakan" (assigned) atau "Selesaikan" (in_progress).
class HelpdeskTaskCard extends StatelessWidget {
  final String ticketId;
  final String title;
  final String category;
  final String status;
  final String priority;
  final String date;
  final String createdBy;
  final String? resolutionNote;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onResolve;

  const HelpdeskTaskCard({
    super.key,
    required this.ticketId,
    required this.title,
    required this.category,
    required this.status,
    required this.priority,
    required this.date,
    required this.createdBy,
    this.resolutionNote,
    this.onTap,
    this.onStart,
    this.onResolve,
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
            // ID + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticketId,
                  style: AppTextStyles.caption(c).copyWith(
                    color: c.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  date,
                  style: AppTextStyles.caption(c)
                      .copyWith(color: c.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Title
            Text(
              title,
              style: AppTextStyles.bodyLg(c).copyWith(
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Badges
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                CategoryBadge(category: category),
                StatusBadge(status: status),
                PriorityBadge(priority: priority),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Created by
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Profile.svg',
                  width: 14,
                  height: 14,
                  colorFilter:
                      ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Dari: $createdBy',
                    style: AppTextStyles.caption(c)
                        .copyWith(color: c.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Resolution note
            if (resolutionNote != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: c.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Message.svg',
                      width: 14,
                      height: 14,
                      colorFilter:
                          ColorFilter.mode(c.textSecondary, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        resolutionNote!,
                        style: AppTextStyles.caption(c).copyWith(
                          color: c.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Quick action buttons
            if (onStart != null || onResolve != null) ...[
              const SizedBox(height: AppSpacing.md),
              if (onStart != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.primary,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Loading.svg',
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Text('Mulai Kerjakan'),
                      ],
                    ),
                  ),
                )
              else if (onResolve != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onResolve,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.success,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Doublecheck.svg',
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Text('Selesaikan'),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
