import 'package:flutter/foundation.dart';
import '../models/app_user.dart';

/// Singleton global state untuk menyimpan current user yang sudah login.
///
/// Gunakan `AppState.instance.currentUser` untuk membaca data user.
/// Gunakan `AppState.instance.userNotifier` untuk listen perubahan (ValueListenableBuilder).
///
/// Di-set saat:
/// - SplashPage berhasil load session
/// - LoginPage berhasil login
/// Di-clear saat logout.
class AppState {
  AppState._();
  static final AppState instance = AppState._();

  final ValueNotifier<AppUser?> userNotifier = ValueNotifier<AppUser?>(null);

  AppUser? get currentUser => userNotifier.value;

  void setUser(AppUser user) {
    userNotifier.value = user;
  }

  void clearUser() {
    userNotifier.value = null;
  }
}
