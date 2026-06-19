import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';

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
    final config = _getPriorityConfig(context, priority);

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

  Map<String, dynamic> _getPriorityConfig(BuildContext context, String priority) {
    final c = context.palette;
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return {
          'bg': c.priorityHighBg,
          'text': c.priorityHighText,
          'icon': Icons.keyboard_double_arrow_up,
        };
      case 'sedang':
        return {
          'bg': c.priorityMedBg,
          'text': c.priorityMedText,
          'icon': Icons.remove,
        };
      case 'rendah':
        return {
          'bg': c.priorityLowBg,
          'text': c.priorityLowText,
          'icon': Icons.keyboard_double_arrow_down,
        };
      default:
        return {
          'bg': c.border,
          'text': c.textSecondary,
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
