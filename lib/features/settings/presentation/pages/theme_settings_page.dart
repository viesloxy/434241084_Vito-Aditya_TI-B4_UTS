import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../shared/widgets/theme_mode_switcher.dart';

/// Halaman pengaturan tema — pilih light / dark / system.
class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'Pengaturan Tema',
          style: TextStyle(
            fontFamily: 'Plus Jakarta',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
        backgroundColor: c.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tampilan',
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Pilih mode terang, gelap, atau ikuti sistem.',
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                fontSize: 14,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: c.border, width: 1),
              ),
              child: const ThemeModeSwitcher(),
            ),
          ],
        ),
      ),
    );
  }
}
