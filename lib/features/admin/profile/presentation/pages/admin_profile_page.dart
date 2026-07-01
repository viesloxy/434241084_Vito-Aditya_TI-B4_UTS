import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/services/app_state.dart';
import '../../../../../core/theme/app_palette.dart';

/// Admin Profile ala FlutterShop — body: ListView, ProfileCard ListTile,
/// section headers (Padding+Text titleSmall), DividerMenuTile per item,
/// Logout ListTile tanpa chevron di bagian bawah.
///
/// Referensi: `FlutterShop/lib/screens/profile/views/profile_screen.dart`
class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final user = AppState.instance.currentUser;
    final adminName = user?.fullName ?? 'Admin';
    final adminEmail = user?.email ?? '—';
    final adminRole = user?.role.label ?? 'Administrator';
    final adminInfo = user?.department ?? user?.phone ?? '';

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text('Profil', style: AppTextStyles.h4(c)),
      ),
      body: ListView(
        children: [
          // ===== PROFILE CARD (ala FlutterShop ProfileCard) =====
          ListTile(
            onTap: () {},
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            leading: user?.avatarUrl != null
                ? CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(user!.avatarUrl!),
                  )
                : CircleAvatar(
                    radius: 28,
                    backgroundColor: c.primary,
                    child: Text(
                      _initials(adminName),
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
            title: Text(
              adminName,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta',
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              adminEmail,
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                fontSize: 13,
                color: c.textSecondary,
              ),
            ),
            trailing: SvgPicture.asset(
              'assets/icons/miniRight.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                c.textTertiary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const Divider(height: 1),

          // ===== ROLE + INFO ROW =====
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: c.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/Setting.svg',
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        adminRole,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: c.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (adminInfo.isNotEmpty)
                  Text(
                    adminInfo,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta',
                      fontSize: 13,
                      color: c.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: c.divider),

          // ===== SECTION: MANAJEMEN =====
          _SectionHeader(title: 'Manajemen'),
          _DividerMenuTile(
            svgSrc: 'assets/icons/Man&Woman.svg',
            text: 'Kelola User',
            onTap: () => _showComingSoon(context),
          ),
          _DividerMenuTile(
            svgSrc: 'assets/icons/Order.svg',
            text: 'Laporan & Statistik',
            onTap: () => _showComingSoon(context),
          ),
          _DividerMenuTile(
            svgSrc: 'assets/icons/Category.svg',
            text: 'Kelola Kategori',
            onTap: () => _showComingSoon(context),
            isShowDivider: false,
          ),

          // ===== SECTION: PENGATURAN =====
          _SectionHeader(title: 'Pengaturan'),
          _DividerMenuTile(
            svgSrc: 'assets/icons/Lock.svg',
            text: 'Ubah Password',
            onTap: () => _showComingSoon(context),
          ),
          _DividerMenuTile(
            svgSrc: 'assets/icons/Setting.svg',
            text: 'Tampilan',
            onTap: () => Navigator.pushNamed(context, '/settings/theme'),
          ),
          _DividerMenuTile(
            svgSrc: 'assets/icons/Notification.svg',
            text: 'Pengaturan Notifikasi',
            onTap: () => _showComingSoon(context),
            isShowDivider: false,
          ),

          // ===== SECTION: BANTUAN & LAINNYA =====
          _SectionHeader(title: 'Bantuan & Lainnya'),
          _DividerMenuTile(
            svgSrc: 'assets/icons/info.svg',
            text: 'Tentang Aplikasi',
            onTap: () => _showComingSoon(context),
            isShowDivider: false,
          ),

          const SizedBox(height: AppSpacing.lg),

          // ===== LOGOUT (ala FlutterShop — ListTile saja, tanpa chevron) =====
          ListTile(
            onTap: () => _showLogoutDialog(context),
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              'assets/icons/Logout.svg',
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(c.error, BlendMode.srcIn),
            ),
            title: Text(
              'Keluar',
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                color: c.error,
                fontSize: 14,
                height: 1,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  void _showComingSoon(BuildContext context) {
    final c = context.palette;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Fitur segera hadir'),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
        backgroundColor: c.textPrimary,
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
              style: AppTextStyles.body(c),
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
                    navigator.pushNamedAndRemoveUntil(
                        '/login', (route) => false);
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

// ===== Section header ala FlutterShop (Padding + Text titleSmall) =====
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}

// ===== DividerMenuTile ala FlutterShop DividerListTile =====
class _DividerMenuTile extends StatelessWidget {
  final String svgSrc;
  final String text;
  final VoidCallback? onTap;
  final bool isShowDivider;

  const _DividerMenuTile({
    required this.svgSrc,
    required this.text,
    this.onTap,
    this.isShowDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          minLeadingWidth: 24,
          leading: SvgPicture.asset(
            svgSrc,
            height: 24,
            width: 24,
            colorFilter:
                ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
          ),
          title: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta',
              fontSize: 14,
              height: 1,
            ),
          ),
          trailing: SvgPicture.asset(
            'assets/icons/miniRight.svg',
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              c.textTertiary,
              BlendMode.srcIn,
            ),
          ),
        ),
        if (isShowDivider) const Divider(height: 1),
      ],
    );
  }
}
