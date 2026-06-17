import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/category_badge.dart';

/// TicketCard ala FlutterShop — flat, border 1 px, radius 12.
///
/// Pewarnaan (flat 2D):
/// - Ticket ID → `textSecondary` (mono)
/// - Title → `textPrimary`
/// - Category/Status/Date → existing badges (semantic)
/// - Priority badge: pakai token semantic priority (AppColors.priorityXxxBg/Text)
/// - `assignedTo` icon → `textTertiary` (netral)
/// - Selected state: border + bg `primaryLight`
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 7.3.
class AdminTicketCard extends StatelessWidget {
  final String ticketId;
  final String title;
  final String category;
  final String status;
  final String date;
  final String? assignedTo;
  final String priority;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AdminTicketCard({
    super.key,
    required this.ticketId,
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    this.assignedTo,
    required this.priority,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: AppSpacing.md),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ticketId,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const Spacer(),
                      _buildPriorityBadge(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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
                      const Spacer(),
                      Text(
                        date,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (assignedTo != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          assignedTo!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Priority badge: token semantic dari AppColors (bukan primary semua).
  Widget _buildPriorityBadge() {
    final (bg, fg, label, icon) = _getPriorityConfig(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.overline.copyWith(
              color: fg,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Map priority string → token warna semantic. Selaras dengan
  /// `AppColors.priorityXxxBg/Text` (style guide section 2 & 7.6b).
  (Color, Color, String, IconData) _getPriorityConfig(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return (
          AppColors.priorityHighBg,
          AppColors.priorityHighText,
          'Tinggi',
          Icons.keyboard_double_arrow_up,
        );
      case 'sedang':
        return (
          AppColors.priorityMedBg,
          AppColors.priorityMedText,
          'Sedang',
          Icons.remove,
        );
      case 'rendah':
        return (
          AppColors.priorityLowBg,
          AppColors.priorityLowText,
          'Rendah',
          Icons.keyboard_double_arrow_down,
        );
      default:
        return (
          AppColors.border,
          AppColors.textSecondary,
          priority,
          Icons.help_outline,
        );
    }
  }
}
