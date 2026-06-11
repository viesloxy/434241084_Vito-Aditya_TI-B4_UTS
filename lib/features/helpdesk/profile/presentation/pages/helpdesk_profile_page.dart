import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/services/auth_service.dart';

/// Halaman profil untuk role Helpdesk.
/// Berbeda dengan Admin Profile: role badge "Helpdesk" (bukan Administrator),
/// ada statistik personal, dan Work Preferences menu.
class HelpdeskProfilePage extends StatelessWidget {
  const HelpdeskProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppColors.background,
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
                          ? AppConstants.spacing2xl
                          : AppConstants.spacingLg),
                  _buildMiniStats(isWide),
                  SizedBox(
                      height: isWide
                          ? AppConstants.spacing2xl
                          : AppConstants.spacingLg),
                  _buildAccountInfo(helpdeskName, helpdeskEmail,
                      helpdeskRole, helpdeskNip, helpdeskDept, isWide),
                  SizedBox(
                      height: isWide
                          ? AppConstants.spacing2xl
                          : AppConstants.spacingLg),
                  _buildMenuSection(menuItems, isWide),
                  SizedBox(
                      height: isWide
                          ? AppConstants.spacing2xl
                          : AppConstants.spacingLg),
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

  Widget _buildHeader(BuildContext context, String name, String email,
      String role, bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacing2xl : AppConstants.spacingLg),
      color: AppColors.surface,
      child: Column(
        children: [
          CircleAvatar(
            radius: isWide ? 50 : 40,
            backgroundColor: const Color(0xFF3B82F6),
            child: Text(
                name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                style: TextStyle(
                    fontSize: isWide ? 28 : 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
          SizedBox(
              height: isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
          Text(name,
              style: TextStyle(
                  fontSize: isWide ? 22 : 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          SizedBox(height: AppConstants.spacingXs),
          Text(email,
              style: TextStyle(
                  fontSize: isWide ? 16 : 14,
                  color: AppColors.textSecondary)),
          SizedBox(
              height:
                  isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
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
                    style: TextStyle(
                        fontSize: isWide ? 14 : 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E40AF))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStats(bool isWide) {
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
          horizontal: isWide ? AppConstants.spacing2xl : 0),
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? AppConstants.spacingXl : AppConstants.spacingLg,
          vertical: AppConstants.spacingLg),
      color: AppColors.surface,
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
                    style: TextStyle(
                        fontSize: isWide ? 18 : 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text(s['label'] as String,
                    style: TextStyle(
                        fontSize: isWide ? 12 : 11,
                        color: AppColors.textSecondary)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccountInfo(String name, String email, String role, String nip,
      String dept, bool isWide) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: isWide ? AppConstants.spacing2xl : 0),
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Akun',
              style: TextStyle(
                  fontSize: isWide ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          SizedBox(
              height: isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
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
      List<Map<String, dynamic>> menuItems, bool isWide) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          return Column(
            children: [
              ListTile(
                leading: Icon(item['icon'] as IconData,
                    color: AppColors.textSecondary,
                    size: isWide ? 26 : 24),
                title: Text(item['title'] as String,
                    style: TextStyle(
                        fontSize: isWide ? 17 : 16,
                        color: AppColors.textPrimary)),
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.textSecondary),
                onTap: item['onTap'] as VoidCallback,
              ),
              if (index < menuItems.length - 1)
                Divider(
                    height: 1,
                    indent: isWide ? 72 : 56,
                    color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, bool isWide) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: isWide ? AppConstants.spacing2xl : 0),
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
      color: AppColors.surface,
      child: ListTile(
        leading: Icon(Icons.logout,
            color: AppColors.error, size: isWide ? 26 : 24),
        title: Text('Keluar',
            style: TextStyle(
                fontSize: isWide ? 17 : 16, color: AppColors.error)),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(isWide ? 20 : AppConstants.radiusLarge)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: isWide ? 80 : 64,
                height: isWide ? 80 : 64,
                decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle),
                child: Icon(Icons.logout,
                    size: isWide ? 40 : 32, color: AppColors.error)),
            SizedBox(
                height: isWide
                    ? AppConstants.spacingXl
                    : AppConstants.spacingLg),
            const Text('Keluar?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            SizedBox(height: AppConstants.spacingSm),
            const Text('Apakah Anda yakin ingin keluar dari akun Helpdesk?',
                style: TextStyle(
                    fontSize: 14, color: AppColors.textSecondary),
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
                                AppConstants.radiusMedium))),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
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
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium))),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isWide ? 15 : 14, color: AppColors.textSecondary)),
          Text(value,
              style: TextStyle(
                  fontSize: isWide ? 15 : 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
