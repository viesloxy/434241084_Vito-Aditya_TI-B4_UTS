import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_palette.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const StatCard({super.key, required this.title, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppConstants.radiusSmall)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(count.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: c.textPrimary)),
          const SizedBox(height: AppConstants.spacingXs),
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: c.textSecondary)),
        ],
      ),
    );
  }
}
