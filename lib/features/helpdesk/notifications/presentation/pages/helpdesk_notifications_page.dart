import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_palette.dart';

/// Halaman notifikasi untuk role Helpdesk.
/// Notifikasi yang diterima Helpdesk:
/// - Tiket baru di-assign oleh Admin
/// - Komentar baru dari User
/// - Update status tiket (oleh sistem)
/// - Tiket closed oleh Admin
class HelpdeskNotificationsPage extends StatefulWidget {
  const HelpdeskNotificationsPage({super.key});

  @override
  State<HelpdeskNotificationsPage> createState() =>
      _HelpdeskNotificationsPageState();
}

class _HelpdeskNotificationsPageState extends State<HelpdeskNotificationsPage> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _notifications = _getMockNotifications());
    }
  }

  List<Map<String, dynamic>> _getMockNotifications() {
    return [
      {
        'type': 'ticket_assigned',
        'title': 'Tiket Baru Ditugaskan',
        'message':
            'Admin menugaskan tiket #TK-2024-007 kepada Anda',
        'time': '5 menit yang lalu',
        'isRead': false,
      },
      {
        'type': 'comment',
        'title': 'Komentar Baru',
        'message': 'Ahmad Rizki mengomentari tiket #TK-2024-005',
        'time': '15 menit yang lalu',
        'isRead': false,
      },
      {
        'type': 'ticket_assigned',
        'title': 'Tiket Baru Ditugaskan',
        'message':
            'Admin menugaskan tiket #TK-2024-006 kepada Anda',
        'time': '30 menit yang lalu',
        'isRead': false,
      },
      {
        'type': 'status_update',
        'title': 'Update Otomatis',
        'message':
            'Status tiket #TK-2024-003 diperbarui menjadi In Progress',
        'time': '1 jam yang lalu',
        'isRead': true,
      },
      {
        'type': 'comment',
        'title': 'Komentar Baru',
        'message': 'Dewi Lestari membalas tiket #TK-2024-001',
        'time': '2 jam yang lalu',
        'isRead': true,
      },
      {
        'type': 'ticket_closed',
        'title': 'Tiket Selesai',
        'message':
            'Tiket #TK-2024-002 telah ditutup oleh Admin',
        'time': '3 jam yang lalu',
        'isRead': true,
      },
    ];
  }

  int get _unreadCount =>
      _notifications.where((n) => n['isRead'] == false).length;

  IconData _getIcon(String type) {
    switch (type) {
      case 'ticket_assigned':
        return Icons.assignment_ind;
      case 'comment':
        return Icons.chat_bubble_outline;
      case 'status_update':
        return Icons.update;
      case 'ticket_closed':
        return Icons.lock_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getIconColor(BuildContext context, String type) {

    final c = context.palette;
    switch (type) {
      case 'ticket_assigned':
        return const Color(0xFF3B82F6);
      case 'comment':
        return const Color(0xFFF59E0B);
      case 'status_update':
        return const Color(0xFF6366F1);
      case 'ticket_closed':
        return const Color(0xFF6B7280);
      default:
        return c.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        title: Text(
          'Notifikasi',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: c.textPrimary),
        ),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (var n in _notifications) {
                    n['isRead'] = true;
                  }
                });
              },
              child: const Text('Tandai Dibaca',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 64,
                      color:
                          c.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: AppConstants.spacingLg),
                  Text('Tidak ada notifikasi',
                      style: TextStyle(
                          fontSize: 16,
                          color: c.textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingSm),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 72,
                  color: c.divider),
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                final isRead = notif['isRead'] as bool;
                return Container(
                  color: isRead
                      ? c.surface
                      : const Color(0xFFEFF6FF),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getIconColor(context, notif['type'] as String)
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIcon(notif['type'] as String),
                        color: _getIconColor(context, notif['type'] as String),
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif['title'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        notif['message'] as String,
                        style: TextStyle(
                            fontSize: 12,
                            color: c.textSecondary),
                      ),
                    ),
                    trailing: Text(
                      notif['time'] as String,
                      style: TextStyle(
                          fontSize: 10,
                          color: c.textSecondary),
                    ),
                    onTap: () {
                      setState(() => notif['isRead'] = true);
                      // Navigate to task detail
                      Navigator.pushNamed(
                          context, '/helpdesk/task-detail',
                          arguments: {'ticketId': '#TK-2024-007'});
                    },
                  ),
                );
              },
            ),
    );
  }
}
