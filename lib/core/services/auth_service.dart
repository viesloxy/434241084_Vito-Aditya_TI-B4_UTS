import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../models/app_user.dart';

/// Service untuk authentication (login, register, logout, session)
class AuthService {
  final sb.SupabaseClient _client = sb.Supabase.instance.client;

  /// Get current authenticated session
  sb.Session? get currentSession => _client.auth.currentSession;

  /// Get current user dari Supabase Auth
  sb.User? get currentAuthUser => _client.auth.currentUser;

  /// Sign in dengan email & password
  /// Mengembalikan AppUser (profile dari tabel users)
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Login gagal: User tidak ditemukan');
    }

    // Fetch profile dari tabel users
    return await getUserProfile(response.user!.id);
  }

  /// Register user baru
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'user',
    String? phone,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
      },
    );

    if (response.user == null) {
      throw Exception('Registrasi gagal');
    }

    // Insert ke tabel public.users
    final userData = await _client.from('users').insert({
      'id': response.user!.id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'phone': phone,
    }).select().single();

    return AppUser.fromJson(userData);
  }

  /// Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get user profile dari tabel public.users
  Future<AppUser> getUserProfile(String userId) async {
    final data = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    return AppUser.fromJson(data);
  }

  /// Kirim email reset password (FR-004)
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'eticketing://reset-password',
    );
  }

  /// Stream auth state changes (untuk listener global)
  Stream<sb.AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
