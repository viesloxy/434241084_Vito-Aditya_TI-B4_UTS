import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../shared/widgets/category_badge.dart';
import '../../../../core/theme/app_palette.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 3, offset: Offset(0, 1))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticketId, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: c.textSecondary)),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppConstants.spacingMd),
                  Row(children: [CategoryBadge(category: category), const SizedBox(width: AppConstants.spacingSm), StatusBadge(status: status)]),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(date, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: c.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Icon(Icons.chevron_right, color: c.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }
}
