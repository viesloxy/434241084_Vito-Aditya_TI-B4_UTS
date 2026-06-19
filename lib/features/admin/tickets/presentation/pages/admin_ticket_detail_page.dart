import 'package:flutter/material.dart';
import '../../../../../core/constants/app_max_width.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../../../../shared/widgets/category_badge.dart';
import '../../../../../core/theme/app_palette.dart';

enum DetailPageState { loading, loaded, error }

/// Admin Ticket Detail ala FlutterShop — flat 2D, no decorative color, all
/// accents use `c.primary`. Sectioned, full-bleed body.
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 8.4.
class AdminTicketDetailPage extends StatefulWidget {
  final Map<String, dynamic>? ticketData;

  const AdminTicketDetailPage({super.key, this.ticketData});

  @override
  State<AdminTicketDetailPage> createState() => _AdminTicketDetailPageState();
}

class _AdminTicketDetailPageState extends State<AdminTicketDetailPage> {
  final _commentController = TextEditingController();
  static const int _maxCharacters = 500;

  DetailPageState _state = DetailPageState.loading;
  String _selectedPriority = 'sedang';

  Map<String, dynamic> _ticketData = {};

  final List<Map<String, dynamic>> _statusTimeline = [
    {'status': 'Submitted', 'date': '21 Jan 2024, 10:00', 'isCompleted': true},
    {'status': 'Signed/Assigned', 'date': '21 Jan 2024, 10:15', 'isCompleted': true},
    {'status': 'In Progress', 'date': '-', 'isCompleted': false},
    {'status': 'Resolved', 'date': '-', 'isCompleted': false},
    {'status': 'Closed', 'date': '-', 'isCompleted': false},
  ];

  final List<Map<String, dynamic>> _conversations = [
    {'sender': 'Sarah Admin', 'message': 'Mohon tunggu, kami sedang memproses permintaan reset password Anda.', 'time': '21 Jan 2024, 10:30', 'isMe': false},
    {'sender': 'Anda', 'message': 'Baik terima kasih atas informasinya', 'time': '21 Jan 2024, 11:00', 'isMe': true},
    {'sender': 'Sarah Admin', 'message': 'Password sudah direset. Silakan login dengan password baru yang telah dikirim ke email Anda.', 'time': '21 Jan 2024, 14:00', 'isMe': false},
  ];

  final List<Map<String, dynamic>> _attachments = [
    {'name': 'Screenshot_error.png', 'size': '1.2 MB', 'type': 'image'},
    {'name': 'Dokumen_Pendukung.pdf', 'size': '256 KB', 'type': 'document'},
  ];

  final List<Map<String, dynamic>> _helpdeskOptions = [
    {'name': 'John Helpdesk', 'initial': 'JH', 'workload': 5, 'status': 'available'},
    {'name': 'Sarah Helpdesk', 'initial': 'SH', 'workload': 3, 'status': 'available'},
    {'name': 'Budi Helpdesk', 'initial': 'BH', 'workload': 0, 'status': 'on_leave'},
  ];

  @override
  void initState() {
    super.initState();
    _ticketData = widget.ticketData ?? {};
    _loadData();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _state = DetailPageState.loading);
    await Future.delayed(const Duration(milliseconds: 1));
    if (mounted) {
      setState(() => _state = DetailPageState.loaded);
    }
  }

  int get _characterCount => _commentController.text.length;

  String _getString(String key, String defaultValue) {
    final value = _ticketData[key];
    if (value == null) return defaultValue;
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildCommentInput(context),
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
        _getString('ticketId', '#TK-0000'),
        style: AppTextStyles.h4(c),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.share_outlined, color: c.textPrimary),
          onPressed: () => _showSnackBar('Link berhasil disalin'),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: c.textPrimary),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showSnackBar('Edit tiket');
                break;
              case 'delete':
                _showDeleteConfirmation(context);
                break;
              case 'print':
                _showSnackBar('Cetak tiket');
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Hapus')),
            PopupMenuItem(value: 'print', child: Text('Cetak')),
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
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: CenteredContent(
            maxWidth: AppMaxWidth.infinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTicketHeader(context),
                const SizedBox(height: AppSpacing.xl),
                _buildStatusTimeline(),
                const SizedBox(height: AppSpacing.xl),
                _buildTicketDetails(),
                const SizedBox(height: AppSpacing.xl),
                _buildDescriptionSection(context),
                const SizedBox(height: AppSpacing.xl),
                _buildAttachmentsSection(context),
                const SizedBox(height: AppSpacing.xl),
                _buildConversationSection(context),
                const SizedBox(height: AppSpacing.xl),
                _buildQuickActions(context),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildTicketHeader(BuildContext context) {

    final c = context.palette;
    final title = _getString('title', 'Judul tidak tersedia');
    final category = _getString('category', 'Lainnya');
    final status = _getString('status', 'baru');
    final priority = _getString('priority', 'sedang');
    final date = _getString('date', '-');

    return _Section(
      title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h3(c)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              CategoryBadge(category: category),
              StatusBadge(status: status),
              _buildPriorityBadge(context, priority),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: c.textSecondary),
              const SizedBox(width: 4),
              Text('Dibuat: $date',
                style: AppTextStyles.caption(c).copyWith(color: c.textSecondary)),
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
      case 'sedang':
      default:
        icon = Icons.remove;
        label = 'Sedang';
        bg = c.priorityMedBg;
        fg = c.priorityMedText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label,
            style: AppTextStyles.overline(c).copyWith(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            )),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return _Section(
      title: 'Timeline Status',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_statusTimeline.length, (index) {
          final item = _statusTimeline[index];
          final isLast = index == _statusTimeline.length - 1;
          return _TimelineItem(
            title: item['status'] as String,
            date: item['date'] as String,
            isCompleted: item['isCompleted'] as bool,
            isLast: isLast,
          );
        }),
      ),
    );
  }

  Widget _buildTicketDetails() {
    final creator = _getString('createdBy', _getString('creator', 'Unknown'));
    final email = '${creator.toLowerCase().replaceAll(' ', '.')}@student.ac.id';
    final priority = _getString('priority', 'sedang');
    final assignedTo = _getString('assignedTo', '');
    final date = _getString('date', '-');

    return _Section(
      title: 'Detail Tiket',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(label: 'Pembuat', value: creator, icon: Icons.person_outline, isEditable: false),
          _DetailRow(label: 'Email', value: email, icon: Icons.email_outlined, isEditable: false),
          _DetailRow(label: 'Prioritas', value: priority, icon: Icons.flag_outlined, isEditable: true, onTap: () => _showPriorityDropdown(context)),
          _DetailRow(label: 'Ditugaskan', value: assignedTo.isEmpty ? 'Belum ditugaskan' : assignedTo, icon: Icons.assignment_ind_outlined, isEditable: true, onTap: () => _showAssignModal(context)),
          _DetailRow(label: 'Tanggal Dibuat', value: date, icon: Icons.calendar_today_outlined, isEditable: false),
          _DetailRow(label: 'Terakhir Update', value: date, icon: Icons.update_outlined, isEditable: false),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {

    final c = context.palette;
    final description = _getString('description', '');

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

  Widget _buildAttachmentsSection(BuildContext context) {

    final c = context.palette;
    return _Section(
      title: 'Lampiran',
      child: _attachments.isEmpty
          ? Text('Tidak ada lampiran', style: AppTextStyles.body(c).copyWith(color: c.textSecondary))
          : Column(
              children: List.generate(_attachments.length, (index) {
                final attachment = _attachments[index];
                return _buildAttachmentItem(context, attachment);
              }),
            ),
    );
  }

  Widget _buildAttachmentItem(BuildContext context, Map<String, dynamic> attachment) {

    final c = context.palette;
    final isImage = attachment['type'] == 'image';
    final name = attachment['name'] as String? ?? 'file';
    final size = attachment['size'] as String? ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              isImage ? Icons.image : Icons.insert_drive_file,
              color: c.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.body(c).copyWith(fontWeight: FontWeight.w500)),
                Text(size, style: AppTextStyles.caption(c).copyWith(color: c.textSecondary)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, color: c.primary),
            onPressed: () => _showSnackBar('Mengunduh $name'),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationSection(BuildContext context) {

    final c = context.palette;
    return _Section(
      title: 'Percakapan',
      child: _conversations.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text('Belum ada percakapan', style: AppTextStyles.body(c).copyWith(color: c.textSecondary)),
              ),
            )
          : Column(
              children: List.generate(_conversations.length, (index) {
                final chat = _conversations[index];
                return _buildChatBubble(context, chat);
              }),
            ),
    );
  }

  Widget _buildChatBubble(BuildContext context, Map<String, dynamic> chat) {

    final c = context.palette;
    final isMe = chat['isMe'] as bool? ?? false;
    final sender = chat['sender'] as String? ?? 'Unknown';
    final message = chat['message'] as String? ?? '';
    final time = chat['time'] as String? ?? '-';

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
          border: Border.all(
            color: isMe ? c.primary : c.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Text(sender,
                style: AppTextStyles.overline(c).copyWith(
                  color: c.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )),
              const SizedBox(height: 4),
            ],
            Text(message,
              style: AppTextStyles.body(c).copyWith(
                color: isMe ? c.textOnPrimary : c.textPrimary,
              )),
            const SizedBox(height: 4),
            Text(time,
              style: AppTextStyles.overline(c).copyWith(
                fontSize: 10,
                color: isMe ? c.textOnPrimary : c.textSecondary,
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {

    final c = context.palette;
    final status = _getString('status', 'submitted');

    if (status == 'submitted' || status == 'baru') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showAssignModal(context),
          icon: const Icon(Icons.person_add_outlined, size: 18),
          label: const Text('Assign ke Helpdesk'),
        ),
      );
    }
    if (status == 'signed_assigned' || status == 'ditangani') {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showCancelAssignmentDialog(context),
          icon: const Icon(Icons.cancel_outlined, size: 18),
          label: const Text('Batalkan Assignment'),
        ),
      );
    }
    if (status == 'resolved' || status == 'selesai') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showCloseTicketDialog(context),
          icon: const Icon(Icons.lock_outline, size: 18),
          label: const Text('Close Tiket (QC)'),
        ),
      );
    }
    // in_progress / closed — info strip
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
            status == 'in_progress' || status == 'diproses'
                ? Icons.hourglass_top_outlined
                : Icons.lock_outline,
            size: 16,
            color: c.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              status == 'in_progress' || status == 'diproses'
                  ? 'Helpdesk sedang mengerjakan tiket. Tidak ada aksi yang tersedia.'
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
                  IconButton(
                    icon: Icon(Icons.attach_file, color: c.textSecondary),
                    onPressed: () => _showSnackBar('Pilih lampiran'),
                  ),
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
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: _commentController.text.isEmpty
                          ? c.textTertiary
                          : c.primary,
                    ),
                    onPressed: _commentController.text.isEmpty
                        ? null
                        : () {
                            _showSnackBar('Pesan terkirim');
                            _commentController.clear();
                            setState(() {});
                          },
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

  void _showPriorityDropdown(BuildContext context) {

    final c = context.palette;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ubah Prioritas', style: AppTextStyles.h3(c)),
            const SizedBox(height: AppSpacing.lg),
            for (final p in const ['tinggi', 'sedang', 'rendah'])
              ListTile(
                leading: Icon(
                  p == 'tinggi'
                      ? Icons.keyboard_double_arrow_up
                      : (p == 'sedang' ? Icons.remove : Icons.keyboard_double_arrow_down),
                  color: p == _selectedPriority ? c.primary : c.textSecondary,
                ),
                title: Text(p == 'tinggi' ? 'Tinggi' : (p == 'sedang' ? 'Sedang' : 'Rendah'),
                  style: AppTextStyles.body(c)),
                trailing: p == _selectedPriority
                    ? Icon(Icons.check, color: c.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedPriority = p);
                  Navigator.pop(ctx);
                  _showSnackBar(
                      'Prioritas diubah ke ${p == 'tinggi' ? 'Tinggi' : (p == 'sedang' ? 'Sedang' : 'Rendah')}');
                },
              ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
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
        padding: const EdgeInsets.all(AppSpacing.lg),
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
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari helpdesk...',
                prefixIcon: Icon(Icons.search, color: c.textSecondary),
                filled: true,
                fillColor: c.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...List.generate(_helpdeskOptions.length, (index) {
              final helpdesk = _helpdeskOptions[index];
              final isAvailable = helpdesk['status'] == 'available';
              final name = helpdesk['name'] as String? ?? '';
              final initial = helpdesk['initial'] as String? ?? '';
              final workload = helpdesk['workload'] as int? ?? 0;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: c.primary,
                  child: Text(initial,
                    style: AppTextStyles.caption(c).copyWith(
                      color: c.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    )),
                ),
                title: Text(name, style: AppTextStyles.body(c)),
                subtitle: Text(
                  isAvailable ? 'Tersedia • $workload tiket aktif' : 'Cuti',
                  style: AppTextStyles.caption(c).copyWith(
                    color: isAvailable ? c.primary : c.textSecondary,
                  ),
                ),
                trailing: !isAvailable ? Icon(Icons.block, color: c.textTertiary) : null,
                onTap: isAvailable
                    ? () {
                        Navigator.pop(ctx);
                        setState(() {
                          _ticketData['assignedTo'] = name;
                          _ticketData['status'] = 'signed_assigned';
                        });
                        _showSnackBar('Ditugaskan ke $name');
                      }
                    : null,
              );
            }),
            SizedBox(height: MediaQuery.of(ctx).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showCancelAssignmentDialog(BuildContext context) {

    final c = context.palette;
    final reasonController = TextEditingController();
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiket akan dikembalikan ke status Submitted. Helpdesk saat ini tidak akan lagi melihat tiket ini.',
              style: AppTextStyles.caption(c),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Alasan pembatalan:', style: AppTextStyles.bodySm(c).copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Misal: Helpdesk berhalangan...',
                filled: true,
                fillColor: c.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().length < 5) {
                _showSnackBar('Alasan minimal 5 karakter');
                return;
              }
              Navigator.pop(ctx);
              setState(() {
                _ticketData['assignedTo'] = null;
                _ticketData['status'] = 'submitted';
              });
              _showSnackBar('Assignment dibatalkan');
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
    final noteController = TextEditingController();

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
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Checklist Quality Control:',
                  style: AppTextStyles.bodySm(c).copyWith(fontWeight: FontWeight.w500)),
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
                  title: Text('Hasil kerja sesuai dengan laporan', style: AppTextStyles.caption(c)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Catatan penutupan (opsional)',
                    filled: true,
                    fillColor: c.inputFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              onPressed: (userConfirmed && helpdeskProof && qcSuitable)
                  ? () {
                      Navigator.pop(ctx);
                      setState(() {
                        _ticketData['status'] = 'closed';
                      });
                      _showSnackBar('Tiket ditutup (Closed)');
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

  void _showDeleteConfirmation(BuildContext context) {

    final c = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Text('Hapus Tiket', style: AppTextStyles.h4(c)),
        content: Text('Apakah Anda yakin ingin menghapus tiket ini?',
          style: AppTextStyles.body(c)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              _showSnackBar('Tiket dihapus');
            },
            style: TextButton.styleFrom(foregroundColor: c.error),
            child: const Text('Hapus'),
          ),
        ],
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

/// Section container ala FlutterShop — flat white card with border 1 px,
/// no shadow, no gradient.
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
                  Text(label, style: AppTextStyles.caption(c).copyWith(color: c.textSecondary)),
                  Text(value,
                    style: AppTextStyles.body(c).copyWith(
                      fontWeight: isEditable ? FontWeight.w500 : FontWeight.w400,
                      color: isEditable ? c.primary : c.textPrimary,
                    )),
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
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? c.primary : c.border,
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
                Text(title,
                  style: AppTextStyles.body(c).copyWith(
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? c.textPrimary : c.textSecondary,
                  )),
                const SizedBox(height: 2),
                Text(date, style: AppTextStyles.caption(c).copyWith(color: c.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
