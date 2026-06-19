import 'package:flutter/material.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/theme/app_palette.dart';

/// Admin Profile ala FlutterShop — flat 2D, header + sectioned list,
/// divider-only. Semua aksen pakai `c.primary`.
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 7.9.
class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    const adminName = 'Sarah Administrator';
    const adminEmail = 'sarah.admin@university.ac.id';
    const adminRole = 'Administrator';
    const adminNip = '12345678';

    final menuItems = [
      {'icon': Icons.people_outline, 'title': 'Manajemen User (User, Helpdesk, Admin)', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.analytics_outlined, 'title': 'Laporan & Statistik', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.category_outlined, 'title': 'Kelola Kategori', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.lock_outlined, 'title': 'Ubah Password', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.notifications_outlined, 'title': 'Pengaturan Notifikasi', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.info_outlined, 'title': 'Tentang Aplikasi', 'onTap': () => _showComingSoon(context)},
    ];

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, adminName, adminEmail, adminRole),
              const SizedBox(height: AppSpacing.lg),
              _buildAccountInfo(context, adminName, adminEmail, adminRole, adminNip),
              const SizedBox(height: AppSpacing.lg),
              _buildMenuSection(context, menuItems),
              const SizedBox(height: AppSpacing.lg),
              _buildLogoutSection(context),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String adminName, String adminEmail, String adminRole) {

    final c = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: c.surface,
      child: Column(
        children: [
          // Avatar dari profil.jpeg (dummy)
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: c.surfaceAlt,
              shape: BoxShape.circle,
              border: Border.all(color: c.border, width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/images/profil.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(adminName, style: AppTextStyles.h3(c)),
          const SizedBox(height: AppSpacing.xs),
          Text(adminEmail, style: AppTextStyles.body(c).copyWith(color: c.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
            decoration: BoxDecoration(
              color: c.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.admin_panel_settings, size: 14, color: c.primary),
                const SizedBox(width: 6),
                Text(adminRole, style: AppTextStyles.overline(c).copyWith(color: c.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(BuildContext context, String adminName, String adminEmail, String adminRole, String adminNip) {

    final c = context.palette;
    return Container(
      width: double.infinity,
      color: c.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
            child: Text('Informasi Akun', style: AppTextStyles.h4(c)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
            child: Column(
              children: [
                _InfoRow(label: 'Nama Lengkap', value: adminName),
                _InfoRow(label: 'Email', value: adminEmail),
                _InfoRow(label: 'Role', value: adminRole),
                _InfoRow(label: 'NIP', value: adminNip),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, List<Map<String, dynamic>> menuItems) {

    final c = context.palette;
    return Container(
      color: c.surface,
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          return Column(
            children: [
              ListTile(
                leading: Icon(item['icon'] as IconData, color: c.primary, size: 24),
                title: Text(item['title'] as String,
                  style: AppTextStyles.body(c).copyWith(color: c.textPrimary)),
                trailing: Icon(Icons.chevron_right, color: c.textTertiary),
                onTap: item['onTap'] as VoidCallback,
              ),
              if (index < menuItems.length - 1)
                Divider(height: 1, indent: 56, color: c.divider),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {

    final c = context.palette;
    return Container(
      width: double.infinity,
      color: c.surface,
      child: ListTile(
        leading: Icon(Icons.logout, color: c.error, size: 24),
        title: Text('Keluar', style: AppTextStyles.body(c).copyWith(color: c.error)),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur segera hadir'),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {

    final c = context.palette;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: c.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout, size: 32, color: c.error),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Keluar?', style: AppTextStyles.h3(c)),
            const SizedBox(height: AppSpacing.sm),
            Text('Apakah Anda yakin ingin keluar dari akun ini?',
              style: AppTextStyles.body(c), textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
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
                    navigator.pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: c.error),
                  child: const Text('Keluar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body(c).copyWith(color: c.textSecondary)),
          Text(value,
            style: AppTextStyles.body(c).copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w500,
            )),
        ],
      ),
    );
  }
}
