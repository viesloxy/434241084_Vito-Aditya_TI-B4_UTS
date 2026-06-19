import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_palette.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'status_update',
      'title': 'Status Tiket Diperbarui',
      'message': 'Tiket #TK-2024-001 sedang diproses',
      'time': '5 menit yang lalu',
      'isRead': false,
    },
    {
      'type': 'new_comment',
      'title': 'Komentar Baru',
      'message': 'John Doe membalas tiket Anda',
      'time': '1 jam yang lalu',
      'isRead': false,
    },
    {
      'type': 'ticket_created',
      'title': 'Tiket Dibuat',
      'message': 'Tiket #TK-2024-002 berhasil dibuat',
      'time': '2 jam yang lalu',
      'isRead': true,
    },
    {
      'type': 'status_update',
      'title': 'Tiket Selesai',
      'message': 'Tiket #TK-2024-003 telah selesai',
      'time': '1 hari yang lalu',
      'isRead': true,
    },
    {
      'type': 'announcement',
      'title': 'Pengumuman',
      'message': 'Sistem maintenance dijadwalkan',
      'time': '2 hari yang lalu',
      'isRead': true,
    },
  ];

  int get _unreadCount => _notifications.where((n) => n['isRead'] == false).length;

  IconData _getIcon(String type) {
    switch (type) {
      case 'status_update':
        return Icons.update;
      case 'new_comment':
        return Icons.chat_bubble_outline;
      case 'ticket_created':
        return Icons.add_circle_outline;
      case 'announcement':
        return Icons.campaign_outlined;
      case 'reminder':
        return Icons.alarm_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getIconColor(BuildContext context, String type) {

    final c = context.palette;
    switch (type) {
      case 'status_update':
        return const Color(0xFF3B82F6);
      case 'new_comment':
        return c.success;
      case 'ticket_created':
        return c.primary;
      case 'announcement':
        return const Color(0xFFF59E0B);
      case 'reminder':
        return const Color(0xFF8B5CF6);
      default:
        return c.textSecondary;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notif in _notifications) {
        notif['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Semua notifikasi ditandai sudah dibaca'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
      ),
    );
  }

  void _markAsRead(int index) {
    setState(() {
      _notifications[index]['isRead'] = true;
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _handleNotificationTap(Map<String, dynamic> notif) {
    switch (notif['type']) {
      case 'status_update':
      case 'new_comment':
      case 'ticket_created':
        // Navigate to ticket detail
        Navigator.pushNamed(context, '/ticket-detail', arguments: notif);
        break;
      case 'announcement':
        // Show announcement details
        _showAnnouncementDialog(context, notif);
        break;
      case 'reminder':
        // Show reminder details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notif['message']),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buka: ${notif['title']}'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
          ),
        );
    }
  }

  void _showAnnouncementDialog(BuildContext context, Map<String, dynamic> notif) {

    final c = context.palette;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: Row(
          children: [
            Icon(Icons.campaign_outlined, color: c.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(notif['title'], style: const TextStyle(fontSize: 16))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notif['message'],
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              notif['time'],
              style: TextStyle(fontSize: 12, color: c.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.textPrimary),
        ),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Tandai semua dibaca',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.primary),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
              child: ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: c.divider),
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  return Dismissible(
                    key: Key('notif_$index'),
                    background: Container(
                      color: c.success.withValues(alpha: 0.2),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(Icons.check, color: c.success),
                    ),
                    secondaryBackground: Container(
                      color: c.error.withValues(alpha: 0.2),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: c.error),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _markAsRead(index);
                        return false;
                      } else {
                        return await _showDeleteConfirmation(context);
                      }
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        _deleteNotification(index);
                      }
                    },
                    child: _NotificationItem(
                      icon: _getIcon(notif['type']),
                      iconColor: _getIconColor(context, notif['type']),
                      title: notif['title'],
                      message: notif['message'],
                      time: notif['time'],
                      isRead: notif['isRead'],
                      onTap: () {
                        _markAsRead(index);
                        _handleNotificationTap(notif);
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {

    final c = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing2xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: c.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'Tidak Ada Notifikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.textPrimary),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Notifikasi akan muncul di sini',
              style: TextStyle(fontSize: 14, color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final c = context.palette;
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        title: const Text('Hapus Notifikasi?'),
        content: const Text('Notifikasi ini akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: c.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    ) ?? false;
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isRead ? c.surface : const Color(0xFFF0F7FF),
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread dot
            if (!isRead)
              Container(
                margin: const EdgeInsets.only(right: 12, top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(width: 20),

            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(fontSize: 13, color: c.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: c.textSecondary),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(Icons.chevron_right, color: c.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
