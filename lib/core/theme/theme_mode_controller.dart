import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// ThemeMode controller — singleton berbasis [ValueNotifier] agar
/// [MaterialApp] bisa rebuild ketika user mengganti mode.
///
/// Pakai:
/// ```dart
/// final controller = ThemeModeController.instance;
/// // ...
/// themeMode: controller.mode,
/// ```
///
/// Toggle:
/// ```dart
/// controller.setMode(ThemeMode.dark);
/// ```
class ThemeModeController {
  ThemeModeController._();

  static final ThemeModeController instance = ThemeModeController._();

  final ValueNotifier<ThemeMode> _notifier = ValueNotifier<ThemeMode>(
    ThemeMode.system,
  );

  /// Stream-like listener untuk rebuild MaterialApp.
  ValueListenable<ThemeMode> get listenable => _notifier;

  /// Mode aktif.
  ThemeMode get mode => _notifier.value;

  /// Set mode baru.
  void setMode(ThemeMode mode) {
    _notifier.value = mode;
  }

  /// Cycle ke mode berikutnya (light → dark → system → light).
  void cycle() {
    switch (_notifier.value) {
      case ThemeMode.light:
        _notifier.value = ThemeMode.dark;
      case ThemeMode.dark:
        _notifier.value = ThemeMode.system;
      case ThemeMode.system:
        _notifier.value = ThemeMode.light;
    }
  }
}
