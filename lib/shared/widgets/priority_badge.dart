import 'package:flutter/material.dart';

/// Priority badge untuk tiket.
/// Mendukung 3 level prioritas: tinggi, sedang, rendah.
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
          'bg': const Color(0xFFFEE2E2),
          'text': const Color(0xFF991B1B),
          'icon': Icons.keyboard_double_arrow_up,
        };
      case 'sedang':
        return {
          'bg': const Color(0xFFFEF3C7),
          'text': const Color(0xFF92400E),
          'icon': Icons.remove,
        };
      case 'rendah':
        return {
          'bg': const Color(0xFFD1FAE5),
          'text': const Color(0xFF065F46),
          'icon': Icons.keyboard_double_arrow_down,
        };
      default:
        return {
          'bg': const Color(0xFFE5E7EB),
          'text': const Color(0xFF374151),
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
