import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ticket.dart';

/// Service untuk operasi CRUD tiket
/// Sudah respect RLS (filtered otomatis sesuai role user)
class TicketService {
  final SupabaseClient _client = Supabase.instance.client;

  // ============================================
  // READ OPERATIONS
  // ============================================

  /// Get tiket dengan filter
  /// User: hanya tiket sendiri (RLS)
  /// Helpdesk: tiket assigned + submitted (RLS)
  /// Admin: semua tiket (RLS)
  Future<List<Ticket>> getTickets({
    TicketStatus? status,
    String? categoryId,
    String? assignedTo,
    int limit = 50,
    int offset = 0,
  }) async {
    // Build query dengan chain method
    PostgrestFilterBuilder query = _client
        .from('tickets')
        .select('''
          *,
          category:categories(name, color, icon),
          creator:users!tickets_created_by_fkey(full_name),
          assignee:users!tickets_assigned_to_fkey(full_name, avatar_url)
        ''');

    if (status != null) {
      query = query.eq('status', status.value);
    }
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    if (assignedTo != null) {
      query = query.eq('assigned_to', assignedTo);
    }

    final data = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List).map((json) => Ticket.fromJson(json)).toList();
  }

  /// Get detail tiket by ID
  Future<Ticket?> getTicketById(String id) async {
    try {
      final data = await _client
          .from('tickets')
          .select('''
            *,
            category:categories(name, color, icon),
            creator:users!tickets_created_by_fkey(full_name),
            assignee:users!tickets_assigned_to_fkey(full_name, avatar_url)
          ''')
          .eq('id', id)
          .single();

      return Ticket.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Get tiket milik user saat ini
  Future<List<Ticket>> getMyTickets({TicketStatus? status}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    PostgrestFilterBuilder query = _client
        .from('tickets')
        .select('*, category:categories(name, color, icon)')
        .eq('created_by', userId);

    if (status != null) {
      query = query.eq('status', status.value);
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List).map((json) => Ticket.fromJson(json)).toList();
  }

  /// Get tiket yang di-assign ke user saat ini (Helpdesk)
  Future<List<Ticket>> getAssignedToMe({TicketStatus? status}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    PostgrestFilterBuilder query = _client
        .from('tickets')
        .select('''
          *,
          category:categories(name, color, icon),
          creator:users!tickets_created_by_fkey(full_name)
        ''')
        .eq('assigned_to', userId);

    if (status != null) {
      query = query.eq('status', status.value);
    }

    final data = await query.order('created_at', ascending: false);
    return (data as List).map((json) => Ticket.fromJson(json)).toList();
  }

  /// Get tiket yang masih submitted (antrian Admin)
  Future<List<Ticket>> getSubmittedTickets() async {
    final data = await _client
        .from('tickets')
        .select('''
          *,
          category:categories(name, color, icon),
          creator:users!tickets_created_by_fkey(full_name)
        ''')
        .eq('status', 'submitted')
        .order('created_at', ascending: false);

    return (data as List).map((json) => Ticket.fromJson(json)).toList();
  }

  // ============================================
  // CREATE OPERATIONS
  // ============================================

  /// Create tiket baru (User only)
  Future<Ticket> createTicket({
    required String title,
    required String description,
    required String categoryId,
    required TicketPriority priority,
    String? location,
  }) async {
    final data = await _client
        .from('tickets')
        .insert({
          'title': title,
          'description': description,
          'category_id': categoryId,
          'priority': priority.value,
          'location': location,
          'status': 'submitted',
        })
        .select('''
          *,
          category:categories(name, color, icon)
        ''')
        .single();

    return Ticket.fromJson(data);
  }

  // ============================================
  // UPDATE OPERATIONS (role-specific via RLS)
  // ============================================

  /// Admin: assign tiket ke Helpdesk
  Future<void> assignTicket({
    required String ticketId,
    required String helpdeskId,
  }) async {
    await _client
        .from('tickets')
        .update({
          'status': 'signed_assigned',
          'assigned_to': helpdeskId,
        })
        .eq('id', ticketId);
  }

  /// Admin: cancel assignment
  Future<void> unassignTicket(String ticketId) async {
    await _client
        .from('tickets')
        .update({
          'status': 'submitted',
          'assigned_to': null,
        })
        .eq('id', ticketId);
  }

  /// Helpdesk: mulai kerjakan
  Future<void> startTicket(String ticketId) async {
    await _client
        .from('tickets')
        .update({'status': 'in_progress'})
        .eq('id', ticketId);
  }

  /// Helpdesk: selesaikan tiket
  Future<void> resolveTicket(String ticketId) async {
    await _client
        .from('tickets')
        .update({
          'status': 'resolved',
          'resolved_at': DateTime.now().toIso8601String(),
        })
        .eq('id', ticketId);
  }

  /// Admin: close tiket (QC)
  Future<void> closeTicket(String ticketId) async {
    await _client
        .from('tickets')
        .update({
          'status': 'closed',
          'closed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', ticketId);
  }

  /// Admin: reject tiket
  Future<void> rejectTicket(String ticketId) async {
    await _client
        .from('tickets')
        .update({
          'status': 'rejected',
          'assigned_to': null,
        })
        .eq('id', ticketId);
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Get stats untuk current user (role-aware)
  Future<Map<String, int>> getStats() async {
    final result = await _client.rpc('get_my_ticket_stats');
    return Map<String, int>.from(result as Map);
  }

  /// Get all helpdesk users (untuk assignment)
  Future<List<Map<String, dynamic>>> getHelpdesks() async {
    final data = await _client
        .from('users')
        .select('id, full_name, department, avatar_url')
        .eq('role', 'helpdesk')
        .eq('is_active', true)
        .order('full_name');

    return List<Map<String, dynamic>>.from(data);
  }

  /// Get categories
  Future<List<Category>> getCategories() async {
    final data = await _client
        .from('categories')
        .select()
        .eq('is_active', true)
        .order('name');

    return (data as List).map((json) => Category.fromJson(json)).toList();
  }
}
