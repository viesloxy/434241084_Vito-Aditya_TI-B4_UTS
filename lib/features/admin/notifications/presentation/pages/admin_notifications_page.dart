import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/theme/app_palette.dart';

/// Admin Notifications ala FlutterShop — flat 2D, divider-only list.
/// Semua icon & aksen pakai `c.primary` (no decorative colors).
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 7.9.
class AdminNotificationsPage extends StatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  State<AdminNotificationsPage> createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
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
      {'type': 'new_ticket', 'title': 'Tiket Baru', 'message': 'John Doe membuat tiket baru #TK-2024-006', 'time': '5 menit yang lalu', 'isRead': false},
      {'type': 'ticket_assigned', 'title': 'Tiket Ditugaskan', 'message': 'Tiket #TK-2024-005 ditugaskan kepada Anda', 'time': '15 menit yang lalu', 'isRead': false},
      {'type': 'status_update', 'title': 'Status Diperbarui', 'message': 'Tiket #TK-2024-003 berubah menjadi Diproses', 'time': '30 menit yang lalu', 'isRead': false},
      {'type': 'new_ticket', 'title': 'Tiket Baru', 'message': 'Sarah membuat tiket baru #TK-2024-004', 'time': '1 jam yang lalu', 'isRead': true},
      {'type': 'comment', 'title': 'Komentar Baru', 'message': 'John membalas tiket #TK-2024-002', 'time': '2 jam yang lalu', 'isRead': true},
      {'type': 'ticket_completed', 'title': 'Tiket Selesai', 'message': 'Tiket #TK-2024-001 telah selesai', 'time': '3 jam yang lalu', 'isRead': true},
    ];
  }

  int get _unreadCount => _notifications.where((n) => n['isRead'] == false).length;

  String _getSvg(String type) {
    switch (type) {
      case 'new_ticket': return 'assets/icons/Order.svg';
      case 'ticket_assigned': return 'assets/icons/Man&Woman.svg';
      case 'status_update': return 'assets/icons/Loading.svg';
      case 'comment': return 'assets/icons/Message.svg';
      case 'ticket_completed': return 'assets/icons/Doublecheck.svg';
      default: return 'assets/icons/Notification.svg';
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notif in _notifications) {
        notif['isRead'] = true;
      }
    });
    _showSnackBar('Semua notifikasi ditandai sudah dibaca');
  }

  void _markAsRead(int index) {
    setState(() => _notifications[index]['isRead'] = true);
  }

  void _deleteNotification(int index) {
    setState(() => _notifications.removeAt(index));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
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
      body: _notifications.isEmpty ? _buildEmptyState(context) : _buildNotificationList(context),
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
            key: Key('admin_notif_$index'),
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
              if (direction == DismissDirection.endToStart) _deleteNotification(index);
            },
            child: _NotificationItem(
              svgAsset: _getSvg(notif['type']),
              title: notif['title'],
              message: notif['message'],
              time: notif['time'],
              isRead: notif['isRead'],
              onTap: () {
                _markAsRead(index);
                Navigator.pushNamed(context, '/admin/ticket-detail', arguments: notif);
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
            Text('Notifikasi akan muncul di sini',
              style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
              textAlign: TextAlign.center),
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
        content: Text('Notifikasi ini akan dihapus.', style: AppTextStyles.body(c)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
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
            // Icon container — single primary
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
                    style: AppTextStyles.bodySm(c).copyWith(color: c.textSecondary),
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
              colorFilter:
                  ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
