import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/category_badge.dart';
import '../../../shared/widgets/priority_badge.dart';

/// Task card khusus Helpdesk.
/// Berbeda dengan AdminTicketCard: tombol quick action adalah
/// "Mulai Kerjakan" atau "Selesaikan" sesuai status tiket.
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
  final VoidCallback? onStart;   // status = signed_assigned
  final VoidCallback? onResolve; // status = in_progress

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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticketId,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Wrap(
              spacing: AppConstants.spacingXs,
              runSpacing: AppConstants.spacingXs,
              children: [
                CategoryBadge(category: category),
                StatusBadge(status: status),
                PriorityBadge(priority: priority),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Dari: $createdBy',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (resolutionNote != null) ...[
              const SizedBox(height: AppConstants.spacingSm),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note_outlined,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        resolutionNote!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
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
            // Quick action button
            if (onStart != null || onResolve != null) ...[
              const SizedBox(height: AppConstants.spacingMd),
              if (onStart != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onStart,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Mulai Kerjakan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                    ),
                  ),
                )
              else if (onResolve != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onResolve,
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('Selesaikan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                      ),
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
