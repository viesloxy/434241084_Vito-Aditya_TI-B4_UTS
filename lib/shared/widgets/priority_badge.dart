import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Priority badge untuk tiket. Mendukung 3 level: tinggi | sedang | rendah.
///
/// Semua warna berasal dari `AppColors.priorityXxxBg/Text` (token semantic).
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 2.4 & 7.6b.
class PriorityBadge extends StatelessWidget {
  final String priority;
  final bool showIcon;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getPriorityConfig(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              config['icon'] as IconData,
              size: 12,
              color: config['text'] as Color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            _getPriorityLabel(priority),
            style: TextStyle(
              fontFamily: 'Plus Jakarta',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: config['text'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getPriorityConfig(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return {
          'bg': AppColors.priorityHighBg,
          'text': AppColors.priorityHighText,
          'icon': Icons.keyboard_double_arrow_up,
        };
      case 'sedang':
        return {
          'bg': AppColors.priorityMedBg,
          'text': AppColors.priorityMedText,
          'icon': Icons.remove,
        };
      case 'rendah':
        return {
          'bg': AppColors.priorityLowBg,
          'text': AppColors.priorityLowText,
          'icon': Icons.keyboard_double_arrow_down,
        };
      default:
        return {
          'bg': AppColors.border,
          'text': AppColors.textSecondary,
          'icon': Icons.help_outline,
        };
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return 'Tinggi';
      case 'sedang':
        return 'Sedang';
      case 'rendah':
        return 'Rendah';
      default:
        return priority;
    }
  }
}
