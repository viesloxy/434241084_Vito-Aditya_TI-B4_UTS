import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment.dart';

class CommentService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Ambil komentar untuk tiket tertentu.
  /// User biasa tidak mendapat internal notes (dikontrol RLS/filter).
  Future<List<Comment>> getComments(String ticketId, {bool hideInternal = false}) async {
    PostgrestFilterBuilder query = _client
        .from('ticket_comments')
        .select('*, user:users(full_name, role, avatar_url)')
        .eq('ticket_id', ticketId);

    if (hideInternal) {
      query = query.eq('is_internal', false);
    }

    final data = await (query as dynamic).order('created_at', ascending: true);
    return (data as List).map((json) => Comment.fromJson(json)).toList();
  }

  /// Tambah komentar baru
  Future<Comment> addComment({
    required String ticketId,
    required String message,
    bool isInternal = false,
  }) async {
    final data = await _client
        .from('ticket_comments')
        .insert({
          'ticket_id': ticketId,
          'message': message,
          'is_internal': isInternal,
        })
        .select('*, user:users(full_name, role, avatar_url)')
        .single();

    return Comment.fromJson(data);
  }

  /// Stream real-time komentar
  Stream<List<Comment>> streamComments(String ticketId) {
    return _client
        .from('ticket_comments')
        .stream(primaryKey: ['id'])
        .eq('ticket_id', ticketId)
        .order('created_at', ascending: true)
        .map((rows) => rows.map((json) => Comment.fromJson(json)).toList());
  }
}
