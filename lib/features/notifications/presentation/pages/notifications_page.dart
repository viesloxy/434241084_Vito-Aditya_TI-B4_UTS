import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_palette.dart';

/// User Notifications ala FlutterShop — flat 2D, divider-only list, SVG icons.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> _notifications = [
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

  int get _unreadCount =>
      _notifications.where((n) => n['isRead'] == false).length;

  String _getSvg(String type) {
    switch (type) {
      case 'status_update':
        return 'assets/icons/Loading.svg';
      case 'new_comment':
        return 'assets/icons/Message.svg';
      case 'ticket_created':
        return 'assets/icons/Order.svg';
      case 'announcement':
      case 'reminder':
      default:
        return 'assets/icons/Notification.svg';
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
      ),
    );
  }

  void _markAsRead(int index) {
    setState(() => _notifications[index]['isRead'] = true);
  }

  void _deleteNotification(int index) {
    setState(() => _notifications.removeAt(index));
  }

  void _handleNotificationTap(Map<String, dynamic> notif) {
    switch (notif['type']) {
      case 'status_update':
      case 'new_comment':
      case 'ticket_created':
        Navigator.pushNamed(context, '/ticket-detail', arguments: notif);
        break;
      case 'announcement':
        _showAnnouncementDialog(context, notif);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buka: ${notif['title']}'),
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            ),
            margin: const EdgeInsets.all(AppSpacing.lg),
          ),
        );
    }
  }

  void _showAnnouncementDialog(
      BuildContext context, Map<String, dynamic> notif) {
    final c = context.palette;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Notification.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(notif['title'] as String,
                  style: AppTextStyles.h4(c)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notif['message'] as String,
              style: AppTextStyles.body(c).copyWith(height: 1.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              notif['time'] as String,
              style: AppTextStyles.caption(c).copyWith(color: c.textSecondary),
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
        title: Text('Notifikasi', style: AppTextStyles.h4(c)),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Tandai semua dibaca',
                style: AppTextStyles.body(c).copyWith(
                  color: c.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: () async =>
                  await Future.delayed(const Duration(seconds: 1)),
              color: c.primary,
              child: ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: c.divider),
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  return Dismissible(
                    key: Key('notif_$index'),
                    background: Container(
                      color: c.primary.withValues(alpha: 0.1),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: AppSpacing.xl),
                      child: SvgPicture.asset(
                        'assets/icons/Doublecheck.svg',
                        width: 20,
                        height: 20,
                        colorFilter:
                            ColorFilter.mode(c.primary, BlendMode.srcIn),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: c.error.withValues(alpha: 0.1),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.xl),
                      child: SvgPicture.asset(
                        'assets/icons/Delete.svg',
                        width: 20,
                        height: 20,
                        colorFilter:
                            ColorFilter.mode(c.error, BlendMode.srcIn),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _markAsRead(index);
                        return false;
                      }
                      return await _showDeleteConfirmation(context);
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        _deleteNotification(index);
                      }
                    },
                    child: _NotificationItem(
                      svgAsset: _getSvg(notif['type'] as String),
                      title: notif['title'] as String,
                      message: notif['message'] as String,
                      time: notif['time'] as String,
                      isRead: notif['isRead'] as bool,
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
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Notification.svg',
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Tidak Ada Notifikasi', style: AppTextStyles.h4(c)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Notifikasi akan muncul di sini',
              style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
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
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
            ),
            title: Text('Hapus Notifikasi?', style: AppTextStyles.h4(c)),
            content: Text('Notifikasi ini akan dihapus.',
                style: AppTextStyles.body(c)),
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
        ) ??
        false;
  }
}

class _NotificationItem extends StatelessWidget {
  final String svgAsset;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.svgAsset,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isRead ? c.surface : c.primaryLight,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread dot (always reserve space)
            Padding(
              padding: const EdgeInsets.only(top: 6, right: AppSpacing.md),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isRead ? Colors.transparent : c.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgAsset,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body(c).copyWith(
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: AppTextStyles.bodySm(c)
                        .copyWith(color: c.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: AppTextStyles.overline(c).copyWith(
                      fontSize: 12,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            SvgPicture.asset(
              'assets/icons/miniRight.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
