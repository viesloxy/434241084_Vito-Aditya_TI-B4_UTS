/// Enum untuk status tiket
/// Workflow: submitted -> signed_assigned -> in_progress -> resolved -> closed
enum TicketStatus {
  submitted('submitted', 'Submitted', 'Tiket baru, belum di-assign'),
  signedAssigned('signed_assigned', 'Signed/Assigned', 'Sudah di-assign ke Helpdesk'),
  inProgress('in_progress', 'In Progress', 'Sedang dikerjakan Helpdesk'),
  resolved('resolved', 'Resolved', 'Sudah selesai, menunggu konfirmasi'),
  closed('closed', 'Closed', 'Sudah di-close (final)'),
  rejected('rejected', 'Rejected', 'Ditolak');

  final String value;
  final String label;
  final String description;
  const TicketStatus(this.value, this.label, this.description);

  static TicketStatus fromString(String? value) {
    return TicketStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => TicketStatus.submitted,
    );
  }
}

/// Enum untuk prioritas tiket
enum TicketPriority {
  rendah('rendah', 'Rendah'),
  sedang('sedang', 'Sedang'),
  tinggi('tinggi', 'Tinggi');

  final String value;
  final String label;
  const TicketPriority(this.value, this.label);

  static TicketPriority fromString(String? value) {
    return TicketPriority.values.firstWhere(
      (p) => p.value == value,
      orElse: () => TicketPriority.sedang,
    );
  }
}

/// Model untuk tiket
class Ticket {
  final String id;
  final String ticketNumber;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final String categoryId;
  final String createdBy;
  final String? assignedTo;
  final String? location;
  final DateTime? resolvedAt;
  final DateTime? closedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relasi (optional, untuk query dengan join)
  final String? categoryName;
  final String? categoryColor;
  final String? categoryIcon;
  final String? creatorName;
  final String? assigneeName;
  final String? assigneeAvatar;

  Ticket({
    required this.id,
    required this.ticketNumber,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.categoryId,
    required this.createdBy,
    this.assignedTo,
    this.location,
    this.resolvedAt,
    this.closedAt,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
    this.categoryColor,
    this.categoryIcon,
    this.creatorName,
    this.assigneeName,
    this.assigneeAvatar,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    // Parse relasi jika ada (dari Supabase join)
    String? categoryName;
    String? categoryColor;
    String? categoryIcon;
    String? creatorName;
    String? assigneeName;
    String? assigneeAvatar;

    if (json['category'] != null && json['category'] is Map) {
      final cat = json['category'] as Map<String, dynamic>;
      categoryName = cat['name'] as String?;
      categoryColor = cat['color'] as String?;
      categoryIcon = cat['icon'] as String?;
    }

    if (json['creator'] != null && json['creator'] is Map) {
      creatorName = (json['creator'] as Map<String, dynamic>)['full_name'] as String?;
    }

    if (json['assignee'] != null && json['assignee'] is Map) {
      final a = json['assignee'] as Map<String, dynamic>;
      assigneeName = a['full_name'] as String?;
      assigneeAvatar = a['avatar_url'] as String?;
    }

    return Ticket(
      id: json['id'] as String,
      ticketNumber: json['ticket_number'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: TicketStatus.fromString(json['status'] as String?),
      priority: TicketPriority.fromString(json['priority'] as String?),
      categoryId: json['category_id'] as String,
      createdBy: json['created_by'] as String,
      assignedTo: json['assigned_to'] as String?,
      location: json['location'] as String?,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      closedAt: json['closed_at'] != null
          ? DateTime.parse(json['closed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      categoryName: categoryName,
      categoryColor: categoryColor,
      categoryIcon: categoryIcon,
      creatorName: creatorName,
      assigneeName: assigneeName,
      assigneeAvatar: assigneeAvatar,
    );
  }
}

/// Model untuk kategori tiket
class Category {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );
  }
}
