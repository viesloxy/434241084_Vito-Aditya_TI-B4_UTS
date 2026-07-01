import 'package:flutter/material.dart';
import '../../../../../core/constants/app_max_width.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/models/app_user.dart';
import '../../../../../core/models/comment.dart';
import '../../../../../core/models/ticket.dart';
import '../../../../../core/services/app_state.dart';
import '../../../../../core/services/comment_service.dart';
import '../../../../../core/services/ticket_service.dart';
import '../../../../../core/services/user_service.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../../../../shared/widgets/category_badge.dart';
import '../../../../../core/theme/app_palette.dart';

enum DetailPageState { loading, loaded, error }

/// Admin Ticket Detail — loads real ticket from Supabase, connects all actions.
class AdminTicketDetailPage extends StatefulWidget {
  const AdminTicketDetailPage({super.key});

  @override
  State<AdminTicketDetailPage> createState() => _AdminTicketDetailPageState();
}

class _AdminTicketDetailPageState extends State<AdminTicketDetailPage> {
  final _commentController = TextEditingController();
  final _ticketService = TicketService();
  final _commentService = CommentService();
  final _userService = UserService();
  static const int _maxCharacters = 500;

  DetailPageState _state = DetailPageState.loading;
  Ticket? _ticket;
  List<Comment> _comments = [];
  List<AppUser> _helpdeskUsers = [];
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
        _commentService.getComments(_ticketId!),
        _userService.getAllUsers(role: 'helpdesk', isActive: true),
      ]);
      final ticket = results[0] as Ticket?;
      final comments = results[1] as List<Comment>;
      final users = results[2] as List<AppUser>;

      if (!mounted) return;
      if (ticket == null) {
        setState(() => _state = DetailPageState.error);
        return;
      }
      setState(() {
        _ticket = ticket;
        _comments = comments;
        _helpdeskUsers = users;
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

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day.toString().padLeft(2, '0')} '
        '${_monthName(dt.month)} ${dt.year}, '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _monthName(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[m - 1];
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
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: c.textPrimary),
          onSelected: (value) {
            if (value == 'reject') {
              _showRejectDialog(context);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'reject', child: Text('Tolak Tiket')),
          ],
        ),
      ],
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
            child: CenteredContent(
              maxWidth: AppMaxWidth.infinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTicketHeader(context, t),
                  const SizedBox(height: AppSpacing.xl),
                  _buildStatusTimeline(t),
                  const SizedBox(height: AppSpacing.xl),
                  _buildTicketDetails(context, t),
                  const SizedBox(height: AppSpacing.xl),
                  _buildDescriptionSection(context, t),
                  const SizedBox(height: AppSpacing.xl),
                  _buildConversationSection(context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildQuickActions(context, t),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
    }
  }

  Widget _buildTicketHeader(BuildContext context, Ticket t) {
    final c = context.palette;
    return _Section(
      title: '',
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
    IconData icon;
    String label;
    Color bg;
    Color fg;
    switch (priority.toLowerCase()) {
      case 'tinggi':
        icon = Icons.keyboard_double_arrow_up;
        label = 'Tinggi';
        bg = c.priorityHighBg;
        fg = c.priorityHighText;
        break;
      case 'rendah':
        icon = Icons.keyboard_double_arrow_down;
        label = 'Rendah';
        bg = c.priorityLowBg;
        fg = c.priorityLowText;
        break;
      default:
        icon = Icons.remove;
        label = 'Sedang';
        bg = c.priorityMedBg;
        fg = c.priorityMedText;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.overline(context.palette).copyWith(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(Ticket t) {
    final statusOrder = [
      TicketStatus.submitted,
      TicketStatus.signedAssigned,
      TicketStatus.inProgress,
      TicketStatus.resolved,
      TicketStatus.closed,
    ];
    final currentIndex = statusOrder.indexOf(t.status);

    return _Section(
      title: 'Timeline Status',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(statusOrder.length, (i) {
          final isCompleted = i <= currentIndex && t.status != TicketStatus.rejected;
          final labels = ['Submitted', 'Ditugaskan', 'In Progress', 'Resolved', 'Closed'];
          return _TimelineItem(
            title: labels[i],
            date: isCompleted ? _getStatusDate(t, statusOrder[i]) : '-',
            isCompleted: isCompleted,
            isLast: i == statusOrder.length - 1,
          );
        }),
      ),
    );
  }

  String _getStatusDate(Ticket t, TicketStatus status) {
    switch (status) {
      case TicketStatus.submitted:
        return _formatDate(t.createdAt);
      case TicketStatus.resolved:
        return t.resolvedAt != null ? _formatDate(t.resolvedAt) : '-';
      case TicketStatus.closed:
        return t.closedAt != null ? _formatDate(t.closedAt) : '-';
      default:
        return _formatDate(t.updatedAt);
    }
  }

  Widget _buildTicketDetails(BuildContext context, Ticket t) {
    final creator = t.creatorName ?? 'Unknown';
    final assignedTo = t.assigneeName ?? '';

    return _Section(
      title: 'Detail Tiket',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            label: 'Pembuat',
            value: creator,
            icon: Icons.person_outline,
            isEditable: false,
          ),
          _DetailRow(
            label: 'Prioritas',
            value: _priorityLabel(t.priority.value),
            icon: Icons.flag_outlined,
            isEditable: false,
          ),
          _DetailRow(
            label: 'Ditugaskan',
            value: assignedTo.isEmpty ? 'Belum ditugaskan' : assignedTo,
            icon: Icons.assignment_ind_outlined,
            isEditable: t.status == TicketStatus.submitted || t.status == TicketStatus.signedAssigned,
            onTap: () => _showAssignModal(context),
          ),
          _DetailRow(
            label: 'Tanggal Dibuat',
            value: _formatDate(t.createdAt),
            icon: Icons.calendar_today_outlined,
            isEditable: false,
          ),
          _DetailRow(
            label: 'Terakhir Update',
            value: _formatDate(t.updatedAt),
            icon: Icons.update_outlined,
            isEditable: false,
          ),
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

  Widget _buildDescriptionSection(BuildContext context, Ticket t) {
    final c = context.palette;
    final description = t.description;
    return _Section(
      title: 'Deskripsi',
      child: Text(
        description.isEmpty ? 'Tidak ada deskripsi' : description,
        style: AppTextStyles.body(c).copyWith(
          color: description.isEmpty ? c.textSecondary : c.textPrimary,
          fontStyle: description.isEmpty ? FontStyle.italic : FontStyle.normal,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildConversationSection(BuildContext context) {
    final c = context.palette;
    return _Section(
      title: 'Percakapan (${_comments.length})',
      child: _comments.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Belum ada percakapan',
                  style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
                ),
              ),
            )
          : Column(
              children: _comments.map((c) => _buildCommentBubble(context, c)).toList(),
            ),
    );
  }

  Widget _buildCommentBubble(BuildContext context, Comment comment) {
    final c = context.palette;
    final currentUserId = AppState.instance.currentUser?.id;
    final isMe = comment.userId == currentUserId;
    final sender = comment.userName ?? 'Unknown';
    final message = comment.message;
    final time = _timeAgo(comment.createdAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: comment.isInternal
              ? c.surfaceAlt
              : (isMe ? c.primary : c.surfaceAlt),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: Border.all(
            color: isMe && !comment.isInternal ? c.primary : c.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Text(
                sender + (comment.isInternal ? ' (Internal)' : ''),
                style: AppTextStyles.overline(c).copyWith(
                  color: c.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              message,
              style: AppTextStyles.body(c).copyWith(
                color: isMe && !comment.isInternal ? c.textOnPrimary : c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: AppTextStyles.overline(c).copyWith(
                fontSize: 10,
                color: isMe && !comment.isInternal
                    ? c.textOnPrimary
                    : c.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Ticket t) {
    if (t.status == TicketStatus.submitted) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showAssignModal(context),
          icon: const Icon(Icons.person_add_outlined, size: 18),
          label: const Text('Assign ke Helpdesk'),
        ),
      );
    }
    if (t.status == TicketStatus.signedAssigned) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showCancelAssignmentDialog(context),
          icon: const Icon(Icons.cancel_outlined, size: 18),
          label: const Text('Batalkan Assignment'),
        ),
      );
    }
    if (t.status == TicketStatus.resolved) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showCloseTicketDialog(context),
          icon: const Icon(Icons.lock_outline, size: 18),
          label: const Text('Close Tiket (QC)'),
        ),
      );
    }
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Icon(
            t.status == TicketStatus.inProgress
                ? Icons.hourglass_top_outlined
                : Icons.lock_outline,
            size: 16,
            color: c.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              t.status == TicketStatus.inProgress
                  ? 'Helpdesk sedang mengerjakan tiket.'
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

  void _showAssignModal(BuildContext context) {
    final c = context.palette;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_add_outlined, color: c.primary),
                const SizedBox(width: AppSpacing.sm),
                Text('Tugaskan ke Helpdesk', style: AppTextStyles.h3(c)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (_helpdeskUsers.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Text(
                    'Tidak ada helpdesk tersedia',
                    style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
                  ),
                ),
              )
            else
              ...List.generate(_helpdeskUsers.length, (index) {
                final user = _helpdeskUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: c.primary,
                    child: Text(
                      _initials(user.fullName),
                      style: AppTextStyles.caption(c).copyWith(
                        color: c.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  title: Text(user.fullName, style: AppTextStyles.body(c)),
                  subtitle: Text(
                    user.department ?? user.email,
                    style: AppTextStyles.caption(c).copyWith(color: c.primary),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      await _ticketService.assignTicket(
                        ticketId: _ticket!.id,
                        helpdeskId: user.id,
                      );
                      _showSnackBar('Ditugaskan ke ${user.fullName}');
                      _loadData();
                    } catch (e) {
                      _showSnackBar('Gagal: $e');
                    }
                  },
                );
              }),
          ],
        ),
      ),
    );
  }

  void _showCancelAssignmentDialog(BuildContext context) {
    final c = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: c.primary),
            const SizedBox(width: AppSpacing.sm),
            Text('Batalkan Assignment', style: AppTextStyles.h4(c)),
          ],
        ),
        content: Text(
          'Tiket akan dikembalikan ke status Submitted.',
          style: AppTextStyles.caption(c),
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
                await _ticketService.unassignTicket(_ticket!.id);
                _showSnackBar('Assignment dibatalkan');
                _loadData();
              } catch (e) {
                _showSnackBar('Gagal: $e');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: c.primary),
            child: const Text('Batalkan Assignment'),
          ),
        ],
      ),
    );
  }

  void _showCloseTicketDialog(BuildContext context) {
    final c = context.palette;
    bool userConfirmed = false;
    bool helpdeskProof = false;
    bool qcSuitable = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: c.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Close Tiket (QC)', style: AppTextStyles.h4(c)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Checklist Quality Control:',
                style: AppTextStyles.bodySm(c).copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: AppSpacing.sm),
              CheckboxListTile(
                value: userConfirmed,
                onChanged: (v) => setDialogState(() => userConfirmed = v ?? false),
                title: Text('User sudah konfirmasi selesai', style: AppTextStyles.caption(c)),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              CheckboxListTile(
                value: helpdeskProof,
                onChanged: (v) => setDialogState(() => helpdeskProof = v ?? false),
                title: Text('Helpdesk sudah upload bukti', style: AppTextStyles.caption(c)),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              CheckboxListTile(
                value: qcSuitable,
                onChanged: (v) => setDialogState(() => qcSuitable = v ?? false),
                title: Text('Hasil kerja sesuai laporan', style: AppTextStyles.caption(c)),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: (userConfirmed && helpdeskProof && qcSuitable)
                  ? () async {
                      Navigator.pop(ctx);
                      try {
                        await _ticketService.closeTicket(_ticket!.id);
                        _showSnackBar('Tiket ditutup');
                        _loadData();
                      } catch (e) {
                        _showSnackBar('Gagal: $e');
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: c.primary),
              child: const Text('Close Tiket'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final c = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Text('Tolak Tiket', style: AppTextStyles.h4(c)),
        content: Text(
          'Apakah Anda yakin ingin menolak tiket ini?',
          style: AppTextStyles.body(c),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _ticketService.rejectTicket(_ticket!.id);
                _showSnackBar('Tiket ditolak');
                _loadData();
              } catch (e) {
                _showSnackBar('Gagal: $e');
              }
            },
            style: TextButton.styleFrom(foregroundColor: c.error),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
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

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(title, style: AppTextStyles.h4(c)),
            const SizedBox(height: AppSpacing.md),
          ],
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isEditable;
  final VoidCallback? onTap;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.isEditable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return InkWell(
      onTap: isEditable ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 18, color: c.textSecondary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption(c).copyWith(color: c.textSecondary),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.body(c).copyWith(
                      fontWeight: isEditable ? FontWeight.w500 : FontWeight.w400,
                      color: isEditable ? c.primary : c.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (isEditable) Icon(Icons.chevron_right, size: 20, color: c.primary),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isCompleted;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.date,
    required this.isCompleted,
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
                color: isCompleted ? c.primary : c.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? c.primary : c.border,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(Icons.check, size: 14, color: c.textOnPrimary)
                  : null,
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: isCompleted ? c.primary : c.border),
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
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? c.textPrimary : c.textSecondary,
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
