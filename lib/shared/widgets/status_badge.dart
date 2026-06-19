import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';

/// Status badge untuk tiket. Mendukung 6 status sesuai workflow 3 role:
/// - submitted: Tiket baru, perlu di-assign Admin
/// - signed_assigned: Sudah di-assign ke Helpdesk
/// - in_progress: Helpdesk sedang mengerjakan
/// - resolved: Helpdesk selesai, menunggu konfirmasi User
/// - closed: Sudah ditutup Admin (final)
/// - rejected: Ditolak
///
/// Semua warna berasal dari `AppColors` (token semantic, bukan raw Color).
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 2.4 & 7.6a.
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config['icon'] as IconData,
            size: 12,
            color: config['text'] as Color,
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusLabel(status),
            style: TextStyle(
              fontFamily: 'Plus Jakarta',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: config['text'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  /// Status workflow 3-role + legacy mapping. Semua token via `AppColors`.
  Map<String, dynamic> _getStatusConfig(BuildContext context, String status) {
    final c = context.palette;
    switch (status.toLowerCase()) {
      case 'submitted':
      case 'baru':
        return {
          'bg': c.statusBaruBg,
          'text': c.statusBaruText,
          'icon': Icons.access_time,
        };
      case 'signed_assigned':
      case 'ditangani':
        return {
          'bg': c.statusProsesBg,
          'text': c.statusProsesText,
          'icon': Icons.assignment_ind,
        };
      case 'in_progress':
      case 'diproses':
        return {
          'bg': c.infoLight,
          'text': c.statusProsesText,
          'icon': Icons.refresh,
        };
      case 'resolved':
      case 'selesai':
        return {
          'bg': c.statusSelesaiBg,
          'text': c.statusSelesaiText,
          'icon': Icons.check_circle,
        };
      case 'closed':
        return {
          'bg': c.border,
          'text': c.textPrimary,
          'icon': Icons.lock,
        };
      case 'rejected':
      case 'ditolak':
        return {
          'bg': c.statusTolakBg,
          'text': c.statusTolakText,
          'icon': Icons.cancel,
        };
      default:
        return {
          'bg': c.border,
          'text': c.textSecondary,
          'icon': Icons.circle,
        };
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Submitted';
      case 'signed_assigned':
        return 'Ditugaskan';
      case 'in_progress':
        return 'Diproses';
      case 'resolved':
        return 'Selesai';
      case 'closed':
        return 'Closed';
      case 'rejected':
        return 'Ditolak';
      case 'baru':
        return 'Baru';
      case 'ditangani':
        return 'Ditangani';
      case 'selesai':
        return 'Selesai';
      case 'ditolak':
        return 'Ditolak';
      default:
        return status;
    }
  }
}
