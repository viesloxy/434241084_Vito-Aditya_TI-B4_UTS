import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/app_palette.dart';

/// Profile Page User ala FlutterShop — ListView, DividerListTile, SVG icons.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _userName = 'John Doe';
  static const _userEmail = 'john.doe@university.ac.id';
  static const _userRole = 'Mahasiswa';
  static const _userNim = '12345678';
  static const _userJurusan = 'Informatika';

  static const _menuItems = [
    {'svgAsset': 'assets/icons/Edit Square.svg', 'title': 'Edit Profil', 'route': null},
    {'svgAsset': 'assets/icons/Lock.svg', 'title': 'Ubah Password', 'route': null},
    {'svgAsset': 'assets/icons/Setting.svg', 'title': 'Tampilan', 'route': '/settings/theme'},
    {'svgAsset': 'assets/icons/Notification.svg', 'title': 'Pengaturan Notifikasi', 'route': null},
    {'svgAsset': 'assets/icons/Language.svg', 'title': 'Bahasa', 'route': null},
    {'svgAsset': 'assets/icons/info.svg', 'title': 'Tentang Aplikasi', 'route': null},
    {'svgAsset': 'assets/icons/Help.svg', 'title': 'Kebijakan Privasi', 'route': null},
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        title: Text('Profil', style: AppTextStyles.h4(c)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Edit Square.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
            ),
            onPressed: () => _showComingSoon(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          // ── Avatar header ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xxl),
            color: c.surface,
            child: Column(
              children: [
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
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/Camera-Bold.svg',
                              width: 14,
                              height: 14,
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(_userName, style: AppTextStyles.h3(c)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _userEmail,
                  style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    _userRole,
                    style: AppTextStyles.overline(c).copyWith(color: c.primary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Info Section ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            color: c.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Informasi Akun', style: AppTextStyles.h4(c)),
                const SizedBox(height: AppSpacing.md),
                _InfoRow(label: 'Nama Lengkap', value: _userName),
                _InfoRow(label: 'Email', value: _userEmail),
                _InfoRow(label: 'Role', value: _userRole),
                _InfoRow(label: 'NIM/NIP', value: _userNim),
                _InfoRow(label: 'Jurusan/Unit', value: _userJurusan),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Menu Section ─────────────────────────────────────────────
          Container(
            color: c.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
                  child: Text(
                    'Pengaturan',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                ...List.generate(_menuItems.length, (index) {
                  final item = _menuItems[index];
                  final isLast = index == _menuItems.length - 1;
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                        minLeadingWidth: 24,
                        leading: SvgPicture.asset(
                          item['svgAsset'] as String,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                              c.textPrimary, BlendMode.srcIn),
                        ),
                        title: Text(
                          item['title'] as String,
                          style: AppTextStyles.body(c)
                              .copyWith(color: c.textPrimary),
                        ),
                        trailing: SvgPicture.asset(
                          'assets/icons/miniRight.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                              c.textTertiary, BlendMode.srcIn),
                        ),
                        onTap: () {
                          final route = item['route'];
                          if (route != null) {
                            Navigator.pushNamed(context, route);
                          } else {
                            _showComingSoon(context);
                          }
                        },
                      ),
                      if (!isLast)
                        Divider(height: 1, color: c.divider),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Logout ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: c.surface,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
              minLeadingWidth: 24,
              leading: SvgPicture.asset(
                'assets/icons/Logout.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(c.error, BlendMode.srcIn),
              ),
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
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Logout.svg',
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(c.error, BlendMode.srcIn),
                ),
              ),
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
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(AppRadius.md)),
                    ),
                  ),
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
                        '/login', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.error,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(AppRadius.md)),
                    ),
                    elevation: 0,
                  ),
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
          Text(
            label,
            style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
          ),
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
