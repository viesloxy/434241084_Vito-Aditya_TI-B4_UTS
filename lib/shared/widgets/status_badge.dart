import 'package:flutter/material.dart';

/// Status badge untuk tiket. Mendukung 6 status sesuai workflow 3 role:
/// - submitted: Tiket baru, perlu di-assign Admin
/// - signed_assigned: Sudah di-assign ke Helpdesk
/// - in_progress: Helpdesk sedang mengerjakan
/// - resolved: Helpdesk selesai, menunggu konfirmasi User
/// - closed: Sudah ditutup Admin (final)
/// - rejected: Ditolak
///
/// Badge ini support baik format value baru (English) maupun legacy (Indonesian)
/// untuk backward compatibility dengan kode yang sudah ada.
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

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
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: config['text'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    // Support baik format baru (submitted, signed_assigned, dll) maupun legacy
    switch (status.toLowerCase()) {
      // Status workflow 3 role (BARU)
      case 'submitted':
      case 'baru':
        return {
          'bg': const Color(0xFFFEF3C7), // Warning Light
          'text': const Color(0xFF92400E), // Warning Dark
          'icon': Icons.access_time,
        };
      case 'signed_assigned':
      case 'ditangani':
        return {
          'bg': const Color(0xFFDBEAFE), // Info Light
          'text': const Color(0xFF1E40AF), // Info Dark
          'icon': Icons.assignment_ind,
        };
      case 'in_progress':
      case 'diproses':
        return {
          'bg': const Color(0xFFE0E7FF), // Indigo Light
          'text': const Color(0xFF3730A3), // Indigo Dark
          'icon': Icons.refresh,
        };
      case 'resolved':
      case 'selesai':
        return {
          'bg': const Color(0xFFD1FAE5), // Success Light
          'text': const Color(0xFF065F46), // Success Dark
          'icon': Icons.check_circle,
        };
      case 'closed':
        return {
          'bg': const Color(0xFFE5E7EB), // Gray Light
          'text': const Color(0xFF374151), // Gray Dark
          'icon': Icons.lock,
        };
      case 'rejected':
      case 'ditolak':
        return {
          'bg': const Color(0xFFFEE2E2), // Error Light
          'text': const Color(0xFF991B1B), // Error Dark
          'icon': Icons.cancel,
        };
      default:
        return {
          'bg': const Color(0xFFE5E7EB),
          'text': const Color(0xFF374151),
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
      // Legacy mapping (untuk backward compatibility)
      case 'baru':
        return 'Baru';
      case 'ditangani':
        return 'Ditangani';
      case 'diproses':
        return 'Diproses';
      case 'selesai':
        return 'Selesai';
      case 'ditolak':
        return 'Ditolak';
      default:
        return status;
    }
  }
}
