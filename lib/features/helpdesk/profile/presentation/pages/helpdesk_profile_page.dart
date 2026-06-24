import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/theme/app_palette.dart';

/// Helpdesk Profile ala FlutterShop — ListView, DividerListTile, SVG icons.
class HelpdeskProfilePage extends StatelessWidget {
  const HelpdeskProfilePage({super.key});

  static const _name = 'John Helpdesk';
  static const _email = 'john.h@university.ac.id';
  static const _nip = '1987654321';
  static const _dept = 'IT Support';

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
      ),
      body: ListView(
        children: [
          // ── Profile card ──────────────────────────────────────────────
          Container(
            color: c.surface,
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  leading: const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/profil.jpeg'),
                  ),
                  title: Text(
                    _name,
                    style: AppTextStyles.bodyLg(c)
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _email,
                    style:
                        AppTextStyles.bodySm(c).copyWith(color: c.textSecondary),
                  ),
                  trailing: SvgPicture.asset(
                    'assets/icons/miniRight.svg',
                    width: 16,
                    height: 16,
                    colorFilter:
                        ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
                  ),
                  onTap: () {},
                ),
                Divider(height: 1, color: c.divider),
                // Role badge + NIP
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: c.primaryLight,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          'Helpdesk',
                          style: AppTextStyles.caption(c).copyWith(
                            color: c.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'NIP: $_nip',
                        style: AppTextStyles.caption(c)
                            .copyWith(color: c.textSecondary),
                      ),
                      const Spacer(),
                      Text(
                        _dept,
                        style: AppTextStyles.caption(c)
                            .copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Mini stats ────────────────────────────────────────────────
          Container(
            color: c.surface,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Row(
              children: [
                _MiniStat(
                    svgAsset: 'assets/icons/Order.svg',
                    value: '45',
                    label: 'Tugas'),
                _Divider(),
                _MiniStat(
                    svgAsset: 'assets/icons/Doublecheck.svg',
                    value: '38',
                    label: 'Selesai'),
                _Divider(),
                _MiniStat(
                    svgAsset: 'assets/icons/Clock.svg',
                    value: '2.1j',
                    label: 'Avg Time'),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Menu section ──────────────────────────────────────────────
          Container(
            color: c.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
                  child: Text(
                    'Akun',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                _DividerMenuTile(
                  svgAsset: 'assets/icons/Order.svg',
                  title: 'Statistik Lengkap',
                  onTap: () => _showComingSoon(context),
                ),
                _DividerMenuTile(
                  svgAsset: 'assets/icons/Setting.svg',
                  title: 'Preferensi Kerja',
                  onTap: () => _showComingSoon(context),
                ),
                _DividerMenuTile(
                  svgAsset: 'assets/icons/Lock.svg',
                  title: 'Ubah Password',
                  onTap: () => _showComingSoon(context),
                ),
                _DividerMenuTile(
                  svgAsset: 'assets/icons/Notification.svg',
                  title: 'Pengaturan Notifikasi',
                  onTap: () => _showComingSoon(context),
                ),
                _DividerMenuTile(
                  svgAsset: 'assets/icons/info.svg',
                  title: 'Tentang Aplikasi',
                  onTap: () => _showComingSoon(context),
                  showDivider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Logout ────────────────────────────────────────────────────
          Container(
            color: c.surface,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: c.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/Logout.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(c.error, BlendMode.srcIn),
                  ),
                ),
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
      const SnackBar(
        content: Text('Fitur segera hadir'),
        behavior: SnackBarBehavior.floating,
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
            Text('Keluar?', style: AppTextStyles.h4(c)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Apakah Anda yakin ingin keluar dari akun Helpdesk?',
              style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
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
                        '/login',
                        (route) => false,
                      );
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
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String svgAsset;
  final String value;
  final String label;

  const _MiniStat({
    required this.svgAsset,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Expanded(
      child: Column(
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.bodyLg(c)
                .copyWith(fontWeight: FontWeight.w700, color: c.textPrimary),
          ),
          Text(
            label,
            style: AppTextStyles.caption(c).copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(width: 1, height: 40, color: c.divider);
  }
}

class _DividerMenuTile extends StatelessWidget {
  final String svgAsset;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const _DividerMenuTile({
    required this.svgAsset,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          leading: Container(
            width: 36,
            height: 36,
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
          title: Text(title, style: AppTextStyles.body(c)),
          trailing: SvgPicture.asset(
            'assets/icons/miniRight.svg',
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
          ),
          onTap: onTap,
        ),
        if (showDivider) Divider(height: 1, indent: 68, color: c.divider),
      ],
    );
  }
}
