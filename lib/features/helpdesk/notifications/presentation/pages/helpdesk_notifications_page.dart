import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/theme/app_palette.dart';

/// Helpdesk Notifications ala FlutterShop — flat 2D, divider-only list.
class HelpdeskNotificationsPage extends StatefulWidget {
  const HelpdeskNotificationsPage({super.key});

  @override
  State<HelpdeskNotificationsPage> createState() =>
      _HelpdeskNotificationsPageState();
}

class _HelpdeskNotificationsPageState
    extends State<HelpdeskNotificationsPage> {
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
        'message': 'Admin menugaskan tiket #TK-2024-007 kepada Anda',
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
        'message': 'Admin menugaskan tiket #TK-2024-006 kepada Anda',
        'time': '30 menit yang lalu',
        'isRead': false,
      },
      {
        'type': 'status_update',
        'title': 'Update Otomatis',
        'message': 'Status tiket #TK-2024-003 diperbarui menjadi In Progress',
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
        'message': 'Tiket #TK-2024-002 telah ditutup oleh Admin',
        'time': '3 jam yang lalu',
        'isRead': true,
      },
    ];
  }

  int get _unreadCount =>
      _notifications.where((n) => n['isRead'] == false).length;

  String _getSvg(String type) {
    switch (type) {
      case 'ticket_assigned':
        return 'assets/icons/Man&Woman.svg';
      case 'comment':
        return 'assets/icons/Message.svg';
      case 'status_update':
        return 'assets/icons/Loading.svg';
      case 'ticket_closed':
        return 'assets/icons/Doublecheck.svg';
      default:
        return 'assets/icons/Notification.svg';
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n['isRead'] = true;
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
          : _buildNotificationList(context),
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    final c = context.palette;
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      color: c.primary,
      child: ListView.separated(
        itemCount: _notifications.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: c.divider),
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          return Dismissible(
            key: Key('helpdesk_notif_$index'),
            background: Container(
              color: c.primary.withValues(alpha: 0.1),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: AppSpacing.xl),
              child: SvgPicture.asset(
                'assets/icons/Doublecheck.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
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
                colorFilter: ColorFilter.mode(c.error, BlendMode.srcIn),
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
                Navigator.pushNamed(
                  context,
                  '/helpdesk/task-detail',
                  arguments: {'ticketId': '#TK-2024-007'},
                );
              },
            ),
          );
        },
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
            content:
                Text('Notifikasi ini akan dihapus.', style: AppTextStyles.body(c)),
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
            // Unread dot
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
