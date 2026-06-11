import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data
    const userName = 'John Doe';
    const userEmail = 'john.doe@university.ac.id';
    const userRole = 'Mahasiswa';
    const userNim = '12345678';
    const userJurusan = 'Informatika';

    final menuItems = [
      {'icon': Icons.edit_outlined, 'title': 'Edit Profil', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.lock_outlined, 'title': 'Ubah Password', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.notifications_outlined, 'title': 'Pengaturan Notifikasi', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.language_outlined, 'title': 'Bahasa', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.info_outlined, 'title': 'Tentang Aplikasi', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.privacy_tip_outlined, 'title': 'Kebijakan Privasi', 'onTap': () => _showComingSoon(context)},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
            onPressed: () => _showComingSoon(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacing2xl),
              color: AppColors.surface,
              child: Column(
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: () => _showComingSoon(context),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            userName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surface, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Name
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingXs),

                  // Email
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userRole,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacingLg),

            // Info Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Akun',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  _InfoRow(label: 'Nama Lengkap', value: userName),
                  _InfoRow(label: 'Email', value: userEmail),
                  _InfoRow(label: 'Role', value: userRole),
                  _InfoRow(label: 'NIM/NIP', value: userNim),
                  _InfoRow(label: 'Jurusan/Unit', value: userJurusan),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacingLg),

            // Menu Section
            Container(
              color: AppColors.surface,
              child: Column(
                children: List.generate(menuItems.length, (index) {
                  final item = menuItems[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(item['icon'] as IconData, color: AppColors.textSecondary),
                        title: Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                        onTap: item['onTap'] as VoidCallback,
                      ),
                      if (index < menuItems.length - 1)
                        const Divider(height: 1, indent: 56, color: AppColors.divider),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: AppConstants.spacingLg),

            // Logout Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              color: AppColors.surface,
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  'Keluar',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.error,
                  ),
                ),
                onTap: () => _showLogoutDialog(context),
              ),
            ),

            const SizedBox(height: AppConstants.spacing2xl),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur segera hadir'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            const Text(
              'Keluar?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            const Text(
              'Apakah Anda yakin ingin keluar dari akun ini?',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
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
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                    ),
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
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                    ),
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

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
