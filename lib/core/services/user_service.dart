import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Update profil user (nama, telepon, departemen)
  Future<AppUser> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? department,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (department != null) updates['department'] = department;

    final data = await _client
        .from('users')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return AppUser.fromJson(data);
  }

  /// Get semua user (admin only, difilter RLS)
  Future<List<AppUser>> getAllUsers({String? role, bool? isActive}) async {
    var query = _client.from('users').select();

    if (role != null) query = query.eq('role', role);
    if (isActive != null) query = query.eq('is_active', isActive);

    final data = await (query as dynamic).order('full_name', ascending: true);
    return (data as List).map((json) => AppUser.fromJson(json)).toList();
  }

  /// Toggle status aktif user (admin only)
  Future<void> setUserActive(String userId, {required bool isActive}) async {
    await _client
        .from('users')
        .update({'is_active': isActive})
        .eq('id', userId);
  }

  /// Update role user (admin only)
  Future<void> setUserRole(String userId, String role) async {
    await _client
        .from('users')
        .update({'role': role})
        .eq('id', userId);
  }
}
