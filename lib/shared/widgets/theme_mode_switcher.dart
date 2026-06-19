import 'package:flutter/material.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/theme_mode_controller.dart';

/// Tile untuk mengganti ThemeMode: light / dark / system.
///
/// Menampilkan icon + label sesuai mode aktif. Tap untuk cycle.
class ThemeModeSwitcher extends StatelessWidget {
  const ThemeModeSwitcher({super.key});

  IconData _iconFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
      case ThemeMode.system:
        return Icons.brightness_auto_outlined;
    }
  }

  String _labelFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Mode Terang';
      case ThemeMode.dark:
        return 'Mode Gelap';
      case ThemeMode.system:
        return 'Ikuti Sistem';
    }
  }

  String _subtitleFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Tampilan selalu terang';
      case ThemeMode.dark:
        return 'Tampilan selalu gelap';
      case ThemeMode.system:
        return 'Mengikuti pengaturan perangkat';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final controller = ThemeModeController.instance;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller.listenable,
      builder: (context, mode, _) {
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_iconFor(mode), color: c.primary, size: 22),
          ),
          title: Text(
            _labelFor(mode),
            style: TextStyle(
              fontFamily: 'Plus Jakarta',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
          subtitle: Text(
            _subtitleFor(mode),
            style: TextStyle(
              fontFamily: 'Plus Jakarta',
              fontSize: 12,
              color: c.textSecondary,
            ),
          ),
          trailing: Wrap(
            spacing: 6,
            children: [
              _modeButton(context, c, mode, ThemeMode.light, Icons.light_mode),
              _modeButton(
                context,
                c,
                mode,
                ThemeMode.dark,
                Icons.dark_mode,
              ),
              _modeButton(
                context,
                c,
                mode,
                ThemeMode.system,
                Icons.brightness_auto,
              ),
            ],
          ),
          onTap: () {
            // No-op default; tap tidak cycle — user pilih via trailing buttons
          },
        );
      },
    );
  }

  Widget _modeButton(
    BuildContext context,
    AppPalette c,
    ThemeMode current,
    ThemeMode target,
    IconData icon,
  ) {
    final isActive = current == target;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => ThemeModeController.instance.setMode(target),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? c.primary : c.surfaceAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? c.primary : c.border,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? c.textOnPrimary : c.textSecondary,
        ),
      ),
    );
  }
}
