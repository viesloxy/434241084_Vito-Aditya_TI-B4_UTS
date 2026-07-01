import 'package:flutter/material.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/models/comment.dart';
import '../../../../../core/models/ticket.dart';
import '../../../../../core/services/app_state.dart';
import '../../../../../core/services/comment_service.dart';
import '../../../../../core/services/ticket_service.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../../../../shared/widgets/category_badge.dart';
import '../../../../../core/theme/app_palette.dart';

enum DetailPageState { loading, loaded, error }

/// Halaman detail tiket untuk Helpdesk.
/// Helpdesk hanya bisa: mulai kerjakan & selesaikan.
class HelpdeskTaskDetailPage extends StatefulWidget {
  const HelpdeskTaskDetailPage({super.key});

  @override
  State<HelpdeskTaskDetailPage> createState() => _HelpdeskTaskDetailPageState();
}

class _HelpdeskTaskDetailPageState extends State<HelpdeskTaskDetailPage> {
  final _commentController = TextEditingController();
  final _ticketService = TicketService();
  final _commentService = CommentService();
  static const int _maxCharacters = 500;

  DetailPageState _state = DetailPageState.loading;
  Ticket? _ticket;
  List<Comment> _comments = [];
  bool _isSendingComment = false;
  String? _ticketId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ticketId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        _ticketId = args['id']?.toString();
      }
      _loadData();
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_ticketId == null) {
      setState(() => _state = DetailPageState.error);
      return;
    }
    setState(() => _state = DetailPageState.loading);
    try {
      final results = await Future.wait([
        _ticketService.getTicketById(_ticketId!),
        _commentService.getComments(_ticketId!, hideInternal: true),
      ]);
      final ticket = results[0] as Ticket?;
      final comments = results[1] as List<Comment>;

      if (!mounted) return;
      if (ticket == null) {
        setState(() => _state = DetailPageState.error);
        return;
      }
      setState(() {
        _ticket = ticket;
        _comments = comments;
        _state = DetailPageState.loaded;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = DetailPageState.error);
    }
  }

  int get _characterCount => _commentController.text.length;

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${dt.day.toString().padLeft(2, '0')} '
        '${months[dt.month - 1]} ${dt.year}, '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar:
          _state == DetailPageState.loaded ? _buildCommentInput(context) : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final c = context.palette;
    return AppBar(
      backgroundColor: c.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: c.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        _ticket?.ticketNumber ?? '#TK-0000',
        style: AppTextStyles.h4(c),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    final c = context.palette;
    switch (_state) {
      case DetailPageState.loading:
        return Center(child: CircularProgressIndicator(color: c.primary));
      case DetailPageState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: c.textTertiary),
              const SizedBox(height: AppSpacing.lg),
              Text('Gagal memuat detail tiket', style: AppTextStyles.body(c)),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: _loadData, child: const Text('Coba Lagi')),
            ],
          ),
        );
      case DetailPageState.loaded:
        final t = _ticket!;
        return RefreshIndicator(
          onRefresh: _loadData,
          color: c.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskHeader(context, t),
                const SizedBox(height: AppSpacing.xl),
                _buildStatusTimeline(context, t),
                const SizedBox(height: AppSpacing.xl),
                _buildTaskDetails(context, t),
                const SizedBox(height: AppSpacing.xl),
                _buildDescriptionSection(context, t),
                const SizedBox(height: AppSpacing.xl),
                _buildConversationSection(context),
                const SizedBox(height: AppSpacing.xl),
                _buildActionButton(context, t),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildTaskHeader(BuildContext context, Ticket t) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.title, style: AppTextStyles.h3(c)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (t.categoryName != null) CategoryBadge(category: t.categoryName!),
              StatusBadge(status: t.status.value),
              _buildPriorityBadge(context, t.priority.value),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: c.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Dibuat: ${_timeAgo(t.createdAt)}',
                style: AppTextStyles.caption(c).copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context, String priority) {
    final c = context.palette;
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (priority.toLowerCase()) {
      case 'tinggi':
        bg = c.priorityHighBg;
        fg = c.priorityHighText;
        label = 'Tinggi';
        icon = Icons.keyboard_double_arrow_up;
        break;
      case 'rendah':
        bg = c.priorityLowBg;
        fg = c.priorityLowText;
        label = 'Rendah';
        icon = Icons.keyboard_double_arrow_down;
        break;
      default:
        bg = c.priorityMedBg;
        fg = c.priorityMedText;
        label = 'Sedang';
        icon = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: fg,
                  fontFamily: 'Plus Jakarta')),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, Ticket t) {
    final c = context.palette;
    final statusOrder = [
      TicketStatus.submitted,
      TicketStatus.signedAssigned,
      TicketStatus.inProgress,
      TicketStatus.resolved,
      TicketStatus.closed,
    ];
    final labels = ['Submitted', 'Ditugaskan', 'In Progress', 'Resolved', 'Closed'];
    final currentIndex = statusOrder.indexOf(t.status);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Timeline Status', style: AppTextStyles.h4(c)),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(statusOrder.length, (i) {
            final isCompleted = i < currentIndex && t.status != TicketStatus.rejected;
            final isActive = i == currentIndex;
            final isLast = i == statusOrder.length - 1;
            String date = '-';
            if (isCompleted || isActive) {
              if (i == 0) date = _formatDate(t.createdAt);
              else if (i == 3 && t.resolvedAt != null) date = _formatDate(t.resolvedAt!);
              else if (i == 4 && t.closedAt != null) date = _formatDate(t.closedAt!);
              else date = _formatDate(t.updatedAt);
            }
            return _TimelineItem(
              title: labels[i],
              date: date,
              isCompleted: isCompleted,
              isActive: isActive,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTaskDetails(BuildContext context, Ticket t) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Tiket', style: AppTextStyles.h4(c)),
          const SizedBox(height: AppSpacing.md),
          _buildDetailRow(context, 'Pembuat', t.creatorName ?? 'Unknown', Icons.person_outline),
          _buildDetailRow(context, 'Prioritas', _priorityLabel(t.priority.value), Icons.flag_outlined),
          _buildDetailRow(context, 'Tanggal Dibuat', _formatDate(t.createdAt), Icons.calendar_today_outlined),
          if (t.location != null && t.location!.isNotEmpty)
            _buildDetailRow(context, 'Lokasi', t.location!, Icons.location_on_outlined),
        ],
      ),
    );
  }

  String _priorityLabel(String value) {
    switch (value) {
      case 'tinggi': return 'Tinggi';
      case 'rendah': return 'Rendah';
      default: return 'Sedang';
    }
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon) {
    final c = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c.textSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption(c).copyWith(color: c.textSecondary)),
                Text(value, style: AppTextStyles.body(c)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, Ticket t) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deskripsi', style: AppTextStyles.h4(c)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            t.description.isEmpty ? 'Tidak ada deskripsi' : t.description,
            style: AppTextStyles.body(c).copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationSection(BuildContext context) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Percakapan (${_comments.length})', style: AppTextStyles.h4(c)),
          const SizedBox(height: AppSpacing.md),
          if (_comments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Belum ada percakapan',
                  style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
                ),
              ),
            )
          else
            ..._comments.map((comment) => _buildChatBubble(context, comment)),
        ],
      ),
    );
  }

  Widget _buildChatBubble(BuildContext context, Comment comment) {
    final c = context.palette;
    final currentUserId = AppState.instance.currentUser?.id;
    final isMe = comment.userId == currentUserId;
    final sender = comment.userName ?? 'Unknown';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isMe ? c.primary : c.surfaceAlt,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Text(
                sender,
                style: AppTextStyles.overline(c).copyWith(
                  color: c.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              comment.message,
              style: AppTextStyles.body(c).copyWith(
                color: isMe ? c.textOnPrimary : c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _timeAgo(comment.createdAt),
              style: AppTextStyles.overline(c).copyWith(
                fontSize: 10,
                color: isMe ? c.textOnPrimary : c.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, Ticket t) {
    final c = context.palette;
    if (t.status == TicketStatus.signedAssigned) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showStartTaskDialog(),
          icon: const Icon(Icons.play_arrow, size: 20),
          label: const Text('Mulai Kerjakan'),
        ),
      );
    }
    if (t.status == TicketStatus.inProgress) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showResolveTaskDialog(context),
          icon: const Icon(Icons.check_circle, size: 18),
          label: const Text('Selesaikan Tiket'),
          style: ElevatedButton.styleFrom(
            backgroundColor: c.success,
            foregroundColor: Colors.white,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16, color: c.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              t.status == TicketStatus.resolved
                  ? 'Tiket sudah selesai. Menunggu konfirmasi Admin.'
                  : 'Tiket sudah ditutup (final).',
              style: AppTextStyles.caption(c).copyWith(color: c.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    final c = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      maxLines: 3,
                      minLines: 1,
                      maxLength: _maxCharacters,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        filled: true,
                        fillColor: c.inputFill,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm + 2,
                        ),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _isSendingComment
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send,
                            color: _commentController.text.isEmpty
                                ? c.textTertiary
                                : c.primary,
                          ),
                          onPressed: _commentController.text.isEmpty
                              ? null
                              : _sendComment,
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$_characterCount/$_maxCharacters',
                    style: AppTextStyles.overline(c).copyWith(
                      fontSize: 11,
                      color: _characterCount > _maxCharacters
                          ? c.error
                          : c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _ticket == null) return;
    setState(() => _isSendingComment = true);
    try {
      final comment = await _commentService.addComment(
        ticketId: _ticket!.id,
        message: text,
      );
      if (!mounted) return;
      _commentController.clear();
      setState(() {
        _comments.add(comment);
        _isSendingComment = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSendingComment = false);
      _showSnackBar('Gagal mengirim: $e');
    }
  }

  void _showStartTaskDialog() {
    final c = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Row(
          children: [
            Icon(Icons.play_arrow, color: c.primary),
            const SizedBox(width: AppSpacing.sm),
            Text('Mulai Kerjakan', style: AppTextStyles.h4(c)),
          ],
        ),
        content: Text(
          'Mulai kerjakan tiket ${_ticket?.ticketNumber}?\n\nStatus akan berubah menjadi "In Progress".',
          style: AppTextStyles.body(c),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _ticketService.startTicket(_ticket!.id);
                _showSnackBar('Status: In Progress');
                _loadData();
              } catch (e) {
                _showSnackBar('Gagal: $e');
              }
            },
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }

  void _showResolveTaskDialog(BuildContext context) {
    final c = context.palette;
    final noteController = TextEditingController();
    bool problemSolved = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: c.success),
              const SizedBox(width: AppSpacing.sm),
              Text('Selesaikan Tiket', style: AppTextStyles.h4(c)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  value: problemSolved,
                  onChanged: (v) => setDialogState(() => problemSolved = v ?? false),
                  title: Text('Saya sudah mengerjakan masalah', style: AppTextStyles.caption(c)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Catatan penyelesaian (min. 10 karakter)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: (problemSolved && noteController.text.trim().length >= 10)
                  ? () async {
                      Navigator.pop(ctx);
                      try {
                        await _ticketService.resolveTicket(_ticket!.id);
                        _showSnackBar('Tiket selesai! Menunggu konfirmasi Admin.');
                        _loadData();
                      } catch (e) {
                        _showSnackBar('Gagal: $e');
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: c.success),
              child: const Text('Selesaikan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
        margin: const EdgeInsets.all(AppSpacing.lg),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.date,
    required this.isCompleted,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? c.success
                    : (isActive ? c.primary : c.surface),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? c.success
                      : (isActive ? c.primary : c.border),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(Icons.check, size: 14, color: c.textOnPrimary)
                  : (isActive
                      ? Icon(Icons.circle, size: 8, color: c.textOnPrimary)
                      : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? c.success : c.border,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body(c).copyWith(
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isCompleted || isActive ? c.textPrimary : c.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: AppTextStyles.caption(c).copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
