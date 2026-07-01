/// Model untuk komentar tiket (public & internal note)
class Comment {
  final String id;
  final String ticketId;
  final String userId;
  final String message;
  final bool isInternal;
  final DateTime createdAt;

  // Relasi dari join
  final String? userName;
  final String? userRole;
  final String? userAvatar;

  Comment({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.message,
    required this.isInternal,
    required this.createdAt,
    this.userName,
    this.userRole,
    this.userAvatar,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    String? userName;
    String? userRole;
    String? userAvatar;

    if (json['user'] != null && json['user'] is Map) {
      final u = json['user'] as Map<String, dynamic>;
      userName = u['full_name'] as String?;
      userRole = u['role'] as String?;
      userAvatar = u['avatar_url'] as String?;
    }

    return Comment(
      id: json['id'] as String,
      ticketId: json['ticket_id'] as String,
      userId: json['user_id'] as String,
      message: json['message'] as String,
      isInternal: json['is_internal'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      userName: userName,
      userRole: userRole,
      userAvatar: userAvatar,
    );
  }
}
