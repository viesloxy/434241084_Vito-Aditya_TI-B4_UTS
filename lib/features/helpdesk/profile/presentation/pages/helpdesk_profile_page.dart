import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/theme/app_palette.dart';

/// Halaman profil untuk role Helpdesk.
/// Berbeda dengan Admin Profile: role badge "Helpdesk" (bukan Administrator),
/// ada statistik personal, dan Work Preferences menu.
class HelpdeskProfilePage extends StatelessWidget {
  const HelpdeskProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    const helpdeskName = 'John Helpdesk';
    const helpdeskEmail = 'john.h@university.ac.id';
    const helpdeskRole = 'Helpdesk';
    const helpdeskNip = '1987654321';
    const helpdeskDept = 'IT Support';

    final menuItems = [
      {
        'icon': Icons.analytics_outlined,
        'title': 'Statistik Lengkap',
        'onTap': () => _showComingSoon(context),
      },
      {
        'icon': Icons.work_outline,
        'title': 'Preferensi Kerja',
        'onTap': () => _showComingSoon(context),
      },
      {
        'icon': Icons.lock_outlined,
        'title': 'Ubah Password',
        'onTap': () => _showComingSoon(context),
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Pengaturan Notifikasi',
        'onTap': () => _showComingSoon(context),
      },
      {
        'icon': Icons.info_outlined,
        'title': 'Tentang Aplikasi',
        'onTap': () => _showComingSoon(context),
      },
    ];

    return Scaffold(
      backgroundColor: c.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, helpdeskName, helpdeskEmail,
                      helpdeskRole, isWide),
                  SizedBox(
                      height: isWide
                          ? AppSpacing.xxl
                          : AppSpacing.lg),
                  _buildMiniStats(context, isWide),
                  SizedBox(
                      height: isWide
                          ? AppSpacing.xxl
                          : AppSpacing.lg),
                  _buildAccountInfo(context, helpdeskName, helpdeskEmail,
                      helpdeskRole, helpdeskNip, helpdeskDept, isWide),
                  SizedBox(
                      height: isWide
                          ? AppSpacing.xxl
                          : AppSpacing.lg),
                  _buildMenuSection(context, menuItems, isWide),
                  SizedBox(
                      height: isWide
                          ? AppSpacing.xxl
                          : AppSpacing.lg),
                  _buildLogoutSection(context, isWide),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String email,
      String role, bool isWide) {

    final c = context.palette;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
          isWide ? AppSpacing.xxl : AppSpacing.lg),
      color: c.surface,
      child: Column(
        children: [
          CircleAvatar(
            radius: isWide ? 50 : 40,
            backgroundColor: c.surfaceAlt,
            backgroundImage: const AssetImage('assets/images/profil.jpeg'),
          ),
          SizedBox(
              height: isWide ? AppSpacing.lg : AppSpacing.md),
          Text(name,
              style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 22 : 20,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary)),
          SizedBox(height: AppSpacing.xs),
          Text(email,
              style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 16 : 14,
                  color: c.textSecondary)),
          SizedBox(
              height:
                  isWide ? AppSpacing.lg : AppSpacing.md),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: isWide ? 16 : 12,
                vertical: isWide ? 8 : 6),
            decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.support_agent,
                    size: isWide ? 18 : 16, color: const Color(0xFF1E40AF)),
                const SizedBox(width: 4),
                Text(role,
                    style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 14 : 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E40AF))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStats(BuildContext context, bool isWide) {

    final c = context.palette;
    final stats = [
      {'label': 'Tugas', 'value': '45', 'icon': Icons.assignment_outlined},
      {'label': 'Selesai', 'value': '38', 'icon': Icons.check_circle_outline},
      {
        'label': 'Avg Time',
        'value': '2.1 jam',
        'icon': Icons.schedule_outlined
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: isWide ? AppSpacing.xxl : 0),
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? AppSpacing.xl : AppSpacing.lg,
          vertical: AppSpacing.lg),
      color: c.surface,
      child: Row(
        children: stats.map((s) {
          return Expanded(
            child: Column(
              children: [
                Icon(s['icon'] as IconData,
                    color: const Color(0xFF3B82F6),
                    size: isWide ? 24 : 20),
                const SizedBox(height: 4),
                Text(s['value'] as String,
                    style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 18 : 16,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary)),
                Text(s['label'] as String,
                    style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 12 : 11,
                        color: c.textSecondary)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context, String name, String email, String role, String nip,
      String dept, bool isWide) {

    final c = context.palette;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: isWide ? AppSpacing.xxl : 0),
      padding: EdgeInsets.all(
          isWide ? AppSpacing.xl : AppSpacing.lg),
      color: c.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Akun',
              style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary)),
          SizedBox(
              height: isWide ? AppSpacing.lg : AppSpacing.md),
          _InfoRow(label: 'Nama Lengkap', value: name, isWide: isWide),
          _InfoRow(label: 'Email', value: email, isWide: isWide),
          _InfoRow(label: 'Role', value: role, isWide: isWide),
          _InfoRow(label: 'NIP', value: nip, isWide: isWide),
          _InfoRow(label: 'Departemen', value: dept, isWide: isWide),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
      BuildContext context, List<Map<String, dynamic>> menuItems, bool isWide) {
    final c = context.palette;
    return Container(
      color: c.surface,
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          return Column(
            children: [
              ListTile(
                leading: Icon(item['icon'] as IconData,
                    color: c.textSecondary,
                    size: isWide ? 26 : 24),
                title: Text(item['title'] as String,
                    style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 17 : 16,
                        color: c.textPrimary)),
                trailing: Icon(Icons.chevron_right,
                    color: c.textSecondary),
                onTap: item['onTap'] as VoidCallback,
              ),
              if (index < menuItems.length - 1)
                Divider(
                    height: 1,
                    indent: isWide ? 72 : 56,
                    color: c.divider),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, bool isWide) {

    final c = context.palette;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: isWide ? AppSpacing.xxl : 0),
      padding: EdgeInsets.all(
          isWide ? AppSpacing.xl : AppSpacing.lg),
      color: c.surface,
      child: ListTile(
        leading: Icon(Icons.logout,
            color: c.error, size: isWide ? 26 : 24),
        title: Text('Keluar',
            style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 17 : 16, color: c.error)),
        onTap: () => _showLogoutDialog(context, isWide),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Fitur segera hadir'),
          behavior: SnackBarBehavior.floating),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isWide) {

    final c = context.palette;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(isWide ? 20 : AppRadius.lg)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: isWide ? 80 : 64,
                height: isWide ? 80 : 64,
                decoration: BoxDecoration(
                    color: c.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle),
                child: Icon(Icons.logout,
                    size: isWide ? 40 : 32, color: c.error)),
            SizedBox(
                height: isWide
                    ? AppSpacing.xl
                    : AppSpacing.lg),
            Text('Keluar?',
                style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary)),
            SizedBox(height: AppSpacing.sm),
            Text('Apakah Anda yakin ingin keluar dari akun Helpdesk?',
                style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: 14, color: c.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppRadius.md))),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      try {
                        await AuthService().signOut();
                      } catch (_) {}
                      navigator.pushNamedAndRemoveUntil(
                        '/login', (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: c.error,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppRadius.md))),
                    child: const Text('Keluar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isWide;

  const _InfoRow(
      {required this.label, required this.value, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 15 : 14, color: c.textSecondary)),
          Text(value,
              style: TextStyle(fontFamily: 'Plus Jakarta', fontSize: isWide ? 15 : 14,
                  fontWeight: FontWeight.w500,
                  color: c.textPrimary)),
        ],
      ),
    );
  }
}
