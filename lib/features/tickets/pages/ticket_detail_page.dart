import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/category_badge.dart';
import '../../../core/theme/app_palette.dart';

class TicketDetailPage extends StatefulWidget {
  final Map<String, dynamic>? ticketData;

  const TicketDetailPage({super.key, this.ticketData});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  final _commentController = TextEditingController();
  bool _isSending = false;

  // Mock ticket data
  final Map<String, dynamic> _ticket = {
    'ticketId': '#TK-2024-001',
    'title': 'Permintaan reset password email kampus',
    'category': 'Teknologi',
    'status': 'diproses',
    'priority': 'sedang',
    'createdAt': '21 Jan 2024, 10:00',
    'assignedTo': 'John Doe (Staff IT)',
    'description': 'Saya tidak dapat login ke email kampus saya sejak kemarin. Sudah mencoba reset password tetapi tidak menerima email reset. Mohon bantuannya untuk reset password email saya.',
    'attachments': ['Screenshot_2024.png'],
  };

  final List<Map<String, dynamic>> _comments = [
    {
      'sender': 'staff',
      'name': 'John Doe',
      'message': 'Terima kasih telah membuat tiket. Kami sedang memproses permintaan Anda.',
      'time': '21 Jan 2024, 10:15',
    },
    {
      'sender': 'user',
      'name': 'Anda',
      'message': 'Baik, terima kasih atas bantuannya.',
      'time': '21 Jan 2024, 10:30',
    },
    {
      'sender': 'staff',
      'name': 'John Doe',
      'message': 'Kami telah mereset password Anda. Silakan coba login dengan password baru yang sudah kami kirim ke nomor HP terdaftar.',
      'time': '21 Jan 2024, 11:00',
    },
  ];

  final List<Map<String, dynamic>> _statusTimeline = [
    {'status': 'Tiket Dibuat', 'time': '21 Jan 2024, 10:00', 'isCompleted': true},
    {'status': 'Ditangani', 'time': '21 Jan 2024, 10:15', 'isCompleted': true},
    {'status': 'Diproses', 'time': '21 Jan 2024, 11:00', 'isCompleted': true},
    {'status': 'Selesai', 'time': '-', 'isCompleted': false},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isSending = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _comments.add({
            'sender': 'user',
            'name': 'Anda',
            'message': _commentController.text.trim(),
            'time': 'Baru saja',
          });
          _commentController.clear();
          _isSending = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final priorityColor = _getPriorityColor(context, _ticket['priority']);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _ticket['ticketId'],
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: c.textPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: c.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: c.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ticket Info Card
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                      boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 3, offset: Offset(0, 1))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _ticket['title'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.textPrimary),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        Row(
                          children: [
                            CategoryBadge(category: _ticket['category']),
                            const SizedBox(width: AppConstants.spacingSm),
                            StatusBadge(status: _ticket['status']),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Status Timeline
                  Text(
                    'Status Tiket',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Column(
                      children: List.generate(_statusTimeline.length, (index) {
                        final item = _statusTimeline[index];
                        return Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: item['isCompleted'] ? c.success : c.border,
                                    shape: BoxShape.circle,
                                  ),
                                  child: item['isCompleted']
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : null,
                                ),
                                if (index < _statusTimeline.length - 1)
                                  Container(
                                    width: 2,
                                    height: 30,
                                    color: _statusTimeline[index + 1]['isCompleted'] ? c.success : c.border,
                                  ),
                              ],
                            ),
                            const SizedBox(width: AppConstants.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['status'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: item['isCompleted'] ? FontWeight.w600 : FontWeight.w400,
                                      color: item['isCompleted'] ? c.textPrimary : c.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    item['time'],
                                    style: TextStyle(fontSize: 12, color: c.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Info Details
                  Text(
                    'Detail Tiket',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(label: 'Tanggal Dibuat', value: _ticket['createdAt']),
                        _DetailRow(label: 'Kategori', value: _ticket['category']),
                        _DetailRow(
                          label: 'Prioritas',
                          value: _ticket['priority'],
                          valueColor: priorityColor,
                        ),
                        _DetailRow(label: 'Penanggung Jawab', value: _ticket['assignedTo']),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Description
                  Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Text(
                      _ticket['description'],
                      style: TextStyle(fontSize: 14, height: 1.5, color: c.textPrimary),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Attachment
                  Text(
                    'Lampiran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: c.primaryLight,
                            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                          ),
                          child: Icon(Icons.image, color: c.primary),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _ticket['attachments'][0],
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.textPrimary),
                              ),
                              Text(
                                '1.2 MB',
                                style: TextStyle(fontSize: 12, color: c.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.download_outlined, color: c.primary),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Comments Section
                  Text(
                    'Percakapan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),

                  if (_comments.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.spacing2xl),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: c.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppConstants.spacingMd),
                          Text(
                            'Belum ada percakapan',
                            style: TextStyle(fontSize: 14, color: c.textSecondary),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      separatorBuilder: (context, index) => const SizedBox(height: AppConstants.spacingMd),
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        final isUser = comment['sender'] == 'user';
                        return _CommentBubble(
                          name: comment['name'],
                          message: comment['message'],
                          time: comment['time'],
                          isUser: isUser,
                        );
                      },
                    ),

                  const SizedBox(height: AppConstants.spacingLg),
                ],
              ),
            ),
          ),

          // Comment Input
          Container(
            padding: EdgeInsets.fromLTRB(
              AppConstants.spacingLg,
              AppConstants.spacingMd,
              AppConstants.spacingLg,
              AppConstants.spacingMd + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: c.surface,
              boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 3, offset: Offset(0, -1))],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: c.textSecondary),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.background,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Ketik pesan...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      style: const TextStyle(fontSize: 14),
                      enabled: !_isSending,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSm),
                _isSending
                    ? const SizedBox(
                        width: 44,
                        height: 44,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: Icon(Icons.send, color: c.primary),
                        onPressed: _sendComment,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(BuildContext context, String priority) {

    final c = context.palette;
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return const Color(0xFFEF4444);
      case 'sedang':
        return const Color(0xFFF59E0B);
      case 'rendah':
        return const Color(0xFF10B981);
      default:
        return c.textPrimary;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: c.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentBubble extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool isUser;

  const _CommentBubble({
    required this.name,
    required this.message,
    required this.time,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          CircleAvatar(
            radius: 16,
            backgroundColor: c.textSecondary,
            child: Text(
              name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isUser ? c.primary : c.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              boxShadow: isUser ? null : const [BoxShadow(color: Color(0x14000000), blurRadius: 2, offset: Offset(0, 1))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isUser ? Colors.white.withValues(alpha: 0.8) : c.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: isUser ? Colors.white : c.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isUser ? Colors.white.withValues(alpha: 0.6) : c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: AppConstants.spacingSm),
          CircleAvatar(
            radius: 16,
            backgroundColor: c.primary,
            child: Text(
              name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join(),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }
}
