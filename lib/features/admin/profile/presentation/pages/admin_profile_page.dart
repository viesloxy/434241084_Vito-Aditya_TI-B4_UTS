import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, adminName, adminEmail, adminRole, isWide),
                  SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingLg),
                  _buildAccountInfo(adminName, adminEmail, adminRole, adminNip, isWide),
                  SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingLg),
                  _buildMenuSection(menuItems, isWide),
                  SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingLg),
                  _buildLogoutSection(context, isWide),
                  const SizedBox(height: AppConstants.spacing2xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String adminName, String adminEmail, String adminRole, bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? AppConstants.spacing2xl : AppConstants.spacingLg),
      color: AppColors.surface,
      child: Column(
        children: [
          CircleAvatar(
            radius: isWide ? 50 : 40,
            backgroundColor: AppColors.primary,
            child: Text(adminName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(), style: TextStyle(fontSize: isWide ? 28 : 24, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
          SizedBox(height: isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
          Text(adminName, style: TextStyle(fontSize: isWide ? 22 : 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: AppConstants.spacingXs),
          Text(adminEmail, style: TextStyle(fontSize: isWide ? 16 : 14, color: AppColors.textSecondary)),
          SizedBox(height: isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 12, vertical: isWide ? 8 : 6),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.admin_panel_settings, size: isWide ? 18 : 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(adminRole, style: TextStyle(fontSize: isWide ? 14 : 12, fontWeight: FontWeight.w500, color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(String adminName, String adminEmail, String adminRole, String adminNip, bool isWide) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: isWide ? AppConstants.spacing2xl : 0),
      padding: EdgeInsets.all(isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Akun', style: TextStyle(fontSize: isWide ? 18 : 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
          _InfoRow(label: 'Nama Lengkap', value: adminName, isWide: isWide),
          _InfoRow(label: 'Email', value: adminEmail, isWide: isWide),
          _InfoRow(label: 'Role', value: adminRole, isWide: isWide),
          _InfoRow(label: 'NIP', value: adminNip, isWide: isWide),
        ],
      ),
    );
  }

  Widget _buildMenuSection(List<Map<String, dynamic>> menuItems, bool isWide) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          return Column(
            children: [
              ListTile(
                leading: Icon(item['icon'] as IconData, color: AppColors.textSecondary, size: isWide ? 26 : 24),
                title: Text(item['title'] as String, style: TextStyle(fontSize: isWide ? 17 : 16, color: AppColors.textPrimary)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                onTap: item['onTap'] as VoidCallback,
              ),
              if (index < menuItems.length - 1)
                Divider(height: 1, indent: isWide ? 72 : 56, color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, bool isWide) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: isWide ? AppConstants.spacing2xl : 0),
      padding: EdgeInsets.all(isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
      color: AppColors.surface,
      child: ListTile(
        leading: Icon(Icons.logout, color: AppColors.error, size: isWide ? 26 : 24),
        title: Text('Keluar', style: TextStyle(fontSize: isWide ? 17 : 16, color: AppColors.error)),
        onTap: () => _showLogoutDialog(context, isWide),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Fitur segera hadir'), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium))),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isWide) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isWide ? 20 : AppConstants.radiusLarge)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: isWide ? 80 : 64, height: isWide ? 80 : 64, decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(Icons.logout, size: isWide ? 40 : 32, color: AppColors.error)),
            SizedBox(height: isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
            const Text('Keluar?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: AppConstants.spacingSm),
            const Text('Apakah Anda yakin ingin keluar dari akun ini?', style: TextStyle(fontSize: 14, color: AppColors.textSecondary), textAlign: TextAlign.center),
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
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium))),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium))),
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

  const _InfoRow({required this.label, required this.value, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isWide ? 15 : 14, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: isWide ? 15 : 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}