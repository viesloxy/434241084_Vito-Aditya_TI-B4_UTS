import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
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

  final Map<String, dynamic> _ticket = {
    'ticketId': '#TK-2024-001',
    'title': 'Permintaan reset password email kampus',
    'category': 'Teknologi',
    'status': 'diproses',
    'priority': 'sedang',
    'createdAt': '21 Jan 2024, 10:00',
    'assignedTo': 'John Doe (Staff IT)',
    'description':
        'Saya tidak dapat login ke email kampus saya sejak kemarin. Sudah mencoba reset password tetapi tidak menerima email reset. Mohon bantuannya untuk reset password email saya.',
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

  Color _getPriorityColor(String priority) {
    final c = context.palette;
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return c.error;
      case 'sedang':
        return c.warning;
      case 'rendah':
        return c.success;
      default:
        return c.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Arrow - Left.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _ticket['ticketId'] as String,
          style: AppTextStyles.body(c).copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Share.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/DotsV.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Ticket info card ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: c.border, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _ticket['title'] as String,
                          style: AppTextStyles.bodyLg(c)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            CategoryBadge(category: _ticket['category'] as String),
                            const SizedBox(width: AppSpacing.sm),
                            StatusBadge(status: _ticket['status'] as String),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Status Timeline ──────────────────────────────────
                  Text(
                    'Status Tiket',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: c.border, width: 1),
                    ),
                    child: Column(
                      children: List.generate(_statusTimeline.length, (index) {
                        final item = _statusTimeline[index];
                        final completed = item['isCompleted'] as bool;
                        return Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: completed ? c.success : c.border,
                                    shape: BoxShape.circle,
                                  ),
                                  child: completed
                                      ? Center(
                                          child: SvgPicture.asset(
                                            'assets/icons/Singlecheck.svg',
                                            width: 12,
                                            height: 12,
                                            colorFilter:
                                                const ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.srcIn),
                                          ),
                                        )
                                      : null,
                                ),
                                if (index < _statusTimeline.length - 1)
                                  Container(
                                    width: 2,
                                    height: 30,
                                    color: (_statusTimeline[index + 1]
                                                ['isCompleted'] as bool)
                                        ? c.success
                                        : c.border,
                                  ),
                              ],
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: index < _statusTimeline.length - 1
                                        ? 30
                                        : 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['status'] as String,
                                      style: AppTextStyles.body(c).copyWith(
                                        fontWeight: completed
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: completed
                                            ? c.textPrimary
                                            : c.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      item['time'] as String,
                                      style: AppTextStyles.caption(c)
                                          .copyWith(color: c.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Detail Tiket ─────────────────────────────────────
                  Text(
                    'Detail Tiket',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: c.border, width: 1),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(label: 'Tanggal Dibuat', value: _ticket['createdAt'] as String),
                        _DetailRow(label: 'Kategori', value: _ticket['category'] as String),
                        _DetailRow(
                          label: 'Prioritas',
                          value: _ticket['priority'] as String,
                          valueColor: _getPriorityColor(_ticket['priority'] as String),
                        ),
                        _DetailRow(label: 'Penanggung Jawab', value: _ticket['assignedTo'] as String),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Deskripsi ────────────────────────────────────────
                  Text(
                    'Deskripsi',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: c.border, width: 1),
                    ),
                    child: Text(
                      _ticket['description'] as String,
                      style: AppTextStyles.body(c).copyWith(height: 1.5),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Lampiran ─────────────────────────────────────────
                  Text(
                    'Lampiran',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: c.border, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: c.primaryLight,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/Image.svg',
                              width: 24,
                              height: 24,
                              colorFilter:
                                  ColorFilter.mode(c.primary, BlendMode.srcIn),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (_ticket['attachments'] as List)[0] as String,
                                style: AppTextStyles.body(c).copyWith(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '1.2 MB',
                                style: AppTextStyles.caption(c)
                                    .copyWith(color: c.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/Arrow - Down.svg',
                            width: 22,
                            height: 22,
                            colorFilter:
                                ColorFilter.mode(c.primary, BlendMode.srcIn),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Percakapan ───────────────────────────────────────
                  Text(
                    'Percakapan',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  if (_comments.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: c.border, width: 1),
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Message.svg',
                            width: 48,
                            height: 48,
                            colorFilter: ColorFilter.mode(
                                c.textTertiary, BlendMode.srcIn),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Belum ada percakapan',
                            style: AppTextStyles.body(c)
                                .copyWith(color: c.textSecondary),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return _CommentBubble(
                          name: comment['name'] as String,
                          message: comment['message'] as String,
                          time: comment['time'] as String,
                          isUser: comment['sender'] == 'user',
                        );
                      },
                    ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // ── Comment Input ─────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: c.surface,
              border: Border(top: BorderSide(color: c.divider, width: 1)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/Camera-add.svg',
                    width: 22,
                    height: 22,
                    colorFilter:
                        ColorFilter.mode(c.textSecondary, BlendMode.srcIn),
                  ),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.background,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: c.border, width: 1),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        hintStyle: TextStyle(color: c.textTertiary),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      style: AppTextStyles.body(c),
                      enabled: !_isSending,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
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
                        icon: SvgPicture.asset(
                          'assets/icons/Send.svg',
                          width: 22,
                          height: 22,
                          colorFilter:
                              ColorFilter.mode(c.primary, BlendMode.srcIn),
                        ),
                        onPressed: _sendComment,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
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
          Text(
            label,
            style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.body(c).copyWith(
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
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          CircleAvatar(
            radius: 16,
            backgroundColor: c.textSecondary,
            child: Text(
              name
                  .split(' ')
                  .map((n) => n.isNotEmpty ? n[0] : '')
                  .take(2)
                  .join(),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isUser ? c.primary : c.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              border: isUser
                  ? null
                  : Border.all(color: c.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.caption(c).copyWith(
                    fontWeight: FontWeight.w600,
                    color: isUser
                        ? Colors.white.withValues(alpha: 0.8)
                        : c.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppTextStyles.body(c).copyWith(
                    color: isUser ? Colors.white : c.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTextStyles.overline(c).copyWith(
                    fontSize: 10,
                    color: isUser
                        ? Colors.white.withValues(alpha: 0.6)
                        : c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: AppSpacing.sm),
          CircleAvatar(
            radius: 16,
            backgroundColor: c.primary,
            child: Text(
              name
                  .split(' ')
                  .map((n) => n.isNotEmpty ? n[0] : '')
                  .take(2)
                  .join(),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }
}
