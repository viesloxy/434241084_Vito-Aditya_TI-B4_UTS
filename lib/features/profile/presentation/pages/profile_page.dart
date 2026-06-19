import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/app_palette.dart';

/// Profile Page ala FlutterShop — header card (avatar + name + role badge)
/// + section info (key-value) + section menu (ListTile) + logout.
/// Avatar pakai dummy `assets/images/profil.jpeg`.
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 7.9 (List Items).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    // Mock user data
    const userName = 'John Doe';
    const userEmail = 'john.doe@university.ac.id';
    const userRole = 'Mahasiswa';
    const userNim = '12345678';
    const userJurusan = 'Informatika';

    final menuItems = [
      {'icon': Icons.edit_outlined, 'title': 'Edit Profil', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.lock_outlined, 'title': 'Ubah Password', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.palette_outlined, 'title': 'Tampilan', 'onTap': () => Navigator.pushNamed(context, '/settings/theme')},
      {'icon': Icons.notifications_outlined, 'title': 'Pengaturan Notifikasi', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.language_outlined, 'title': 'Bahasa', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.info_outlined, 'title': 'Tentang Aplikasi', 'onTap': () => _showComingSoon(context)},
      {'icon': Icons.privacy_tip_outlined, 'title': 'Kebijakan Privasi', 'onTap': () => _showComingSoon(context)},
    ];

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        title: Text('Profil', style: AppTextStyles.h4(c)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: c.textPrimary),
            onPressed: () => _showComingSoon(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== Header: Avatar + Name + Role =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              color: c.surface,
              child: Column(
                children: [
                  // Avatar dari profil.jpeg (dummy)
                  GestureDetector(
                    onTap: () => _showComingSoon(context),
                    child: Stack(
                      children: [
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
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: c.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: c.surface, width: 2),
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

                  const SizedBox(height: AppSpacing.md),

                  Text(userName, style: AppTextStyles.h3(c)),

                  const SizedBox(height: AppSpacing.xs),

                  Text(userEmail, style: AppTextStyles.body(c).copyWith(color: c.textSecondary)),

                  const SizedBox(height: AppSpacing.md),

                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: c.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      userRole,
                      style: AppTextStyles.overline(c).copyWith(color: c.primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ===== Info Section =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              color: c.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informasi Akun', style: AppTextStyles.h4(c)),
                  const SizedBox(height: AppSpacing.md),
                  _InfoRow(label: 'Nama Lengkap', value: userName),
                  _InfoRow(label: 'Email', value: userEmail),
                  _InfoRow(label: 'Role', value: userRole),
                  _InfoRow(label: 'NIM/NIP', value: userNim),
                  _InfoRow(label: 'Jurusan/Unit', value: userJurusan),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ===== Menu Section (List ala FlutterShop divider_list_tile) =====
            Container(
              color: c.surface,
              child: Column(
                children: List.generate(menuItems.length, (index) {
                  final item = menuItems[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          item['icon'] as IconData,
                          color: c.textSecondary,
                          size: 24,
                        ),
                        title: Text(
                          item['title'] as String,
                          style: AppTextStyles.body(c).copyWith(color: c.textPrimary),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: c.textTertiary,
                          size: 20,
                        ),
                        onTap: item['onTap'] as VoidCallback,
                      ),
                      if (index < menuItems.length - 1)
                        Divider(height: 1, indent: 56, color: c.divider),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // ===== Logout =====
            Container(
              width: double.infinity,
              color: c.surface,
              child: ListTile(
                leading: Icon(Icons.logout, color: c.error, size: 24),
                title: Text(
                  'Keluar',
                  style: AppTextStyles.body(c).copyWith(color: c.error),
                ),
                onTap: () => _showLogoutDialog(context),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
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
            Text(
              'Apakah Anda yakin ingin keluar dari akun ini?',
              style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
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
          Text(
            value,
            style: AppTextStyles.body(c).copyWith(
              color: c.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
