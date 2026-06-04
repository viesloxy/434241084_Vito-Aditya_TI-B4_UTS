import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../../../../shared/widgets/category_badge.dart';

enum DetailPageState { loading, loaded, error }

class AdminTicketDetailPage extends StatefulWidget {
  final Map<String, dynamic>? ticketData;

  const AdminTicketDetailPage({super.key, this.ticketData});

  @override
  State<AdminTicketDetailPage> createState() => _AdminTicketDetailPageState();
}

class _AdminTicketDetailPageState extends State<AdminTicketDetailPage> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  static const int _maxCharacters = 500;

  DetailPageState _state = DetailPageState.loading;
  // Setelah revisi 3 role, Admin HANYA bisa assign & close.
  // Tidak ada lagi _selectedStatus dropdown di sini.
  String _selectedPriority = 'sedang';

  Map<String, dynamic> _ticketData = {};

  // Timeline 5 status (sesuai workflow 3 role)
  final List<Map<String, dynamic>> _statusTimeline = [
    {'status': 'Submitted', 'date': '21 Jan 2024, 10:00', 'isCompleted': true, 'isActive': false},
    {'status': 'Signed/Assigned', 'date': '21 Jan 2024, 10:15', 'isCompleted': true, 'isActive': false},
    {'status': 'In Progress', 'date': '-', 'isCompleted': false, 'isActive': false},
    {'status': 'Resolved', 'date': '-', 'isCompleted': false, 'isActive': false},
    {'status': 'Closed', 'date': '-', 'isCompleted': false, 'isActive': false},
  ];

  final List<Map<String, dynamic>> _conversations = [
    {'sender': 'Sarah Admin', 'role': 'staff', 'message': 'Mohon tunggu, kami sedang memproses permintaan reset password Anda.', 'time': '21 Jan 2024, 10:30', 'isMe': false},
    {'sender': 'Anda', 'role': 'staff', 'message': 'Baik terima kasih atas informasinya', 'time': '21 Jan 2024, 11:00', 'isMe': true},
    {'sender': 'Sarah Admin', 'role': 'staff', 'message': 'Password sudah direset. Silakan login dengan password baru yang telah dikirim ke email Anda.', 'time': '21 Jan 2024, 14:00', 'isMe': false},
  ];

  final List<Map<String, dynamic>> _attachments = [
    {'name': 'Screenshot_error.png', 'size': '1.2 MB', 'type': 'image'},
    {'name': 'Dokumen_Pendukung.pdf', 'size': '256 KB', 'type': 'document'},
  ];

  // Helpdesk options (untuk assign tiket)
  // Setelah revisi 3 role, Admin assign ke Helpdesk (bukan "Staff")
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
    _scrollController.dispose();
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

  // Helper methods to safely get data
  String _getString(String key, String defaultValue) {
    final value = _ticketData[key];
    if (value == null) return defaultValue;
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(isWide),
          body: _buildBody(isWide),
          bottomNavigationBar: _buildCommentInput(isWide),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(bool isWide) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => Navigator.pop(context)),
      title: Text(
        _getString('ticketId', '#TK-0000'),
        style: TextStyle(fontSize: isWide ? 18 : 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary), onPressed: () => _showSnackBar('Link berhasil disalin')),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showSnackBar('Edit tiket');
                break;
              case 'delete':
                _showDeleteConfirmation();
                break;
              case 'print':
                _showSnackBar('Cetak tiket');
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Hapus')),
            const PopupMenuItem(value: 'print', child: Text('Cetak')),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(bool isWide) {
    switch (_state) {
      case DetailPageState.loading:
        return const Center(child: CircularProgressIndicator());
      case DetailPageState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: AppConstants.spacingLg),
              const Text('Gagal memuat detail tiket'),
              const SizedBox(height: AppConstants.spacingMd),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        );
      case DetailPageState.loaded:
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTicketHeader(isWide),
                    SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
                    _buildStatusTimeline(isWide),
                    SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
                    _buildTicketDetails(isWide),
                    SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
                    _buildDescriptionSection(isWide),
                    SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
                    _buildAttachmentsSection(isWide),
                    SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
                    _buildConversationSection(isWide),
                    const SizedBox(height: AppConstants.spacing2xl),
                    _buildQuickActions(isWide),
                    const SizedBox(height: AppConstants.spacingLg),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildTicketHeader(bool isWide) {
    final title = _getString('title', 'Judul tidak tersedia');
    final category = _getString('category', 'Lainnya');
    final status = _getString('status', 'baru');
    final priority = _getString('priority', 'sedang');
    final date = _getString('date', '-');

    return Container(
      padding: EdgeInsets.all(isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: isWide ? 20 : 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          SizedBox(height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          Wrap(
            spacing: AppConstants.spacingSm,
            runSpacing: AppConstants.spacingSm,
            children: [
              CategoryBadge(category: category),
              StatusBadge(status: status),
              _buildPriorityBadge(priority),
            ],
          ),
          SizedBox(height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('Dibuat: $date', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    switch (priority.toLowerCase()) {
      case 'tinggi':
        bgColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        label = 'Tinggi';
        icon = Icons.keyboard_double_arrow_up;
        break;
      case 'sedang':
        bgColor = const Color(0xFFF59E0B).withValues(alpha: 0.1);
        textColor = const Color(0xFFF59E0B);
        label = 'Sedang';
        icon = Icons.remove;
        break;
      case 'rendah':
        bgColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        label = 'Rendah';
        icon = Icons.keyboard_double_arrow_down;
        break;
      default:
        bgColor = AppColors.textSecondary.withValues(alpha: 0.1);
        textColor = AppColors.textSecondary;
        label = priority;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Timeline Status', style: TextStyle(fontSize: isWide ? 16 : 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
          ...List.generate(_statusTimeline.length, (index) {
            final item = _statusTimeline[index];
            final isLast = index == _statusTimeline.length - 1;
            return _TimelineItem(
              title: item['status'] as String,
              date: item['date'] as String,
              isCompleted: item['isCompleted'] as bool,
              isActive: item['isActive'] as bool,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTicketDetails(bool isWide) {
    final creator = _getString('createdBy', _getString('creator', 'Unknown'));
    final email = '${creator.toLowerCase().replaceAll(' ', '.')}@student.ac.id';
    final priority = _getString('priority', 'sedang');
    final assignedTo = _getString('assignedTo', '');
    final date = _getString('date', '-');

    return Container(
      padding: EdgeInsets.all(isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Tiket', style: TextStyle(fontSize: isWide ? 16 : 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          _buildDetailRow('Pembuat', creator, Icons.person_outline, false),
          _buildDetailRow('Email', email, Icons.email_outlined, false),
          _buildDetailRow('Prioritas', priority, Icons.flag_outlined, true, onTap: () => _showPriorityDropdown()),
          _buildDetailRow('Ditugaskan', assignedTo.isEmpty ? 'Belum ditugaskan' : assignedTo, Icons.assignment_ind_outlined, true, onTap: () => _showAssignModal()),
          _buildDetailRow('Tanggal Dibuat', date, Icons.calendar_today_outlined, false),
          _buildDetailRow('Terakhir Update', date, Icons.update_outlined, false),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, bool isEditable, {VoidCallback? onTap}) {
    return InkWell(
      onTap: isEditable ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text(value, style: TextStyle(fontSize: 14, fontWeight: isEditable ? FontWeight.w500 : FontWeight.w400, color: isEditable ? AppColors.primary : AppColors.textPrimary)),
                ],
              ),
            ),
            if (isEditable) const Icon(Icons.chevron_right, size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(bool isWide) {
    final description = _getString('description', '');

    return Container(
      padding: EdgeInsets.all(isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Deskripsi', style: TextStyle(fontSize: isWide ? 16 : 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              if (description.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.copy, size: 18, color: AppColors.primary),
                  onPressed: () => _showSnackBar('Deskripsi disalin'),
                  tooltip: 'Salin deskripsi',
                ),
            ],
          ),
          SizedBox(height: isWide ? AppConstants.spacingSm : 4),
          Text(
            description.isEmpty ? 'Tidak ada deskripsi' : description,
            style: TextStyle(
              fontSize: 14,
              color: description.isEmpty ? AppColors.textSecondary : AppColors.textPrimary,
              fontStyle: description.isEmpty ? FontStyle.italic : FontStyle.normal,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lampiran', style: TextStyle(fontSize: isWide ? 16 : 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          if (_attachments.isEmpty)
            const Text('Tidak ada lampiran', style: TextStyle(fontSize: 14, color: AppColors.textSecondary))
          else
            ...List.generate(_attachments.length, (index) {
              final attachment = _attachments[index];
              return _buildAttachmentItem(attachment);
            }),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(Map<String, dynamic> attachment) {
    final isImage = attachment['type'] == 'image';
    final name = attachment['name'] as String? ?? 'file';
    final size = attachment['size'] as String? ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(isImage ? Icons.image : Icons.insert_drive_file, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(size, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.download, color: AppColors.primary), onPressed: () => _showSnackBar('Mengunduh $name')),
        ],
      ),
    );
  }

  Widget _buildConversationSection(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Percakapan', style: TextStyle(fontSize: isWide ? 16 : 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          SizedBox(height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          if (_conversations.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Belum ada percakapan', style: TextStyle(color: AppColors.textSecondary))))
          else
            ...List.generate(_conversations.length, (index) {
              final chat = _conversations[index];
              return _buildChatBubble(chat);
            }),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> chat) {
    final isMe = chat['isMe'] as bool? ?? false;
    final sender = chat['sender'] as String? ?? 'Unknown';
    final message = chat['message'] as String? ?? '';
    final time = chat['time'] as String? ?? '-';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.background,
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
              Row(
                children: [
                  Text(sender, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Staff', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            Text(message, style: TextStyle(fontSize: 14, color: isMe ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isWide) {
    final currentStatus = _getString('status', 'submitted');
    // Tentukan tombol yang tersedia sesuai status
    // Admin HANYA boleh:
    //  - Submitted: "Assign ke Helpdesk"
    //  - Signed/Assigned: "Batalkan Assignment"
    //  - Resolved: "Close Tiket" (setelah User konfirmasi)
    //  - In Progress / Closed: tidak ada tombol
    final status = _helpdeskOptions.isNotEmpty ? currentStatus : 'submitted';

    if (status == 'submitted' || status == 'baru') {
      return Container(
        padding: EdgeInsets.all(
            isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showAssignModal(),
            icon: const Icon(Icons.person_add_outlined, size: 18),
            label: const Text('Assign ke Helpdesk'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium)),
            ),
          ),
        ),
      );
    } else if (status == 'signed_assigned' || status == 'ditangani') {
      return Container(
        padding: EdgeInsets.all(
            isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showCancelAssignmentDialog(),
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text('Batalkan Assignment'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium)),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (status == 'resolved' || status == 'selesai') {
      return Container(
        padding: EdgeInsets.all(
            isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showCloseTicketDialog(),
            icon: const Icon(Icons.lock_outline, size: 18),
            label: const Text('Close Tiket (QC)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium)),
            ),
          ),
        ),
      );
    } else {
      // in_progress, closed - tidak ada tombol
      return Container(
        padding: EdgeInsets.all(
            isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        child: Row(
          children: [
            Icon(
                status == 'in_progress' || status == 'diproses'
                    ? Icons.hourglass_top_outlined
                    : Icons.lock_outline,
                size: 16,
                color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                status == 'in_progress' || status == 'diproses'
                    ? 'Helpdesk sedang mengerjakan tiket. Tidak ada aksi yang tersedia.'
                    : 'Tiket sudah ditutup (final).',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCommentInput(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
      decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file, color: AppColors.textSecondary), onPressed: () => _showSnackBar('Pilih lampiran')),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    maxLines: 3,
                    minLines: 1,
                    maxLength: _maxCharacters,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusLarge), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 12, vertical: isWide ? 12 : 10),
                      counterText: '',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingXs),
                IconButton(
                  icon: Icon(Icons.send, color: _commentController.text.isEmpty ? AppColors.textSecondary : AppColors.primary),
                  onPressed: _commentController.text.isEmpty ? null : () {
                    _showSnackBar('Pesan terkirim');
                    _commentController.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('$_characterCount/$_maxCharacters', style: TextStyle(fontSize: 11, color: _characterCount > _maxCharacters ? AppColors.error : AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriorityDropdown() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ubah Prioritas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppConstants.spacingLg),
            ...['tinggi', 'sedang', 'rendah'].map((p) => ListTile(
              leading: Icon(
                p == 'tinggi' ? Icons.keyboard_double_arrow_up : (p == 'sedang' ? Icons.remove : Icons.keyboard_double_arrow_down),
                color: p == _selectedPriority ? AppColors.primary : AppColors.textSecondary,
              ),
              title: Text(p == 'tinggi' ? 'Tinggi' : (p == 'sedang' ? 'Sedang' : 'Rendah')),
              trailing: p == _selectedPriority ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                setState(() => _selectedPriority = p);
                Navigator.pop(ctx);
                _showSnackBar('Prioritas diubah ke ${p == 'tinggi' ? 'Tinggi' : (p == 'sedang' ? 'Sedang' : 'Rendah')}');
              },
            )),
            const SizedBox(height: AppConstants.spacingLg),
          ],
        ),
      ),
    );
  }

  void _showAssignModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person_add_outlined, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Tugaskan ke Helpdesk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari helpdesk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            ...List.generate(_helpdeskOptions.length, (index) {
              final helpdesk = _helpdeskOptions[index];
              final isAvailable = helpdesk['status'] == 'available';
              final name = helpdesk['name'] as String? ?? '';
              final initial = helpdesk['initial'] as String? ?? '';
              final workload = helpdesk['workload'] as int? ?? 0;

              return ListTile(
                leading: CircleAvatar(backgroundColor: const Color(0xFF3B82F6), child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 12))),
                title: Text(name),
                subtitle: Text(
                  isAvailable ? 'Tersedia • $workload tiket aktif' : 'Cuti',
                  style: TextStyle(color: isAvailable ? AppColors.success : AppColors.textSecondary),
                ),
                trailing: !isAvailable ? const Icon(Icons.block, color: AppColors.textSecondary) : null,
                onTap: isAvailable ? () {
                  Navigator.pop(ctx);
                  setState(() {
                    _ticketData['assignedTo'] = name;
                    _ticketData['status'] = 'signed_assigned';
                  });
                  _showSnackBar('Ditugaskan ke $name');
                } : null,
              );
            }),
            SizedBox(height: MediaQuery.of(ctx).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  void _showCancelAssignmentDialog() {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Batalkan Assignment'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tiket akan dikembalikan ke status Submitted. Helpdesk saat ini tidak akan lagi melihat tiket ini.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            const Text('Alasan pembatalan:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Misal: Helpdesk berhalangan...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('Batalkan Assignment'),
          ),
        ],
      ),
    );
  }

  void _showCloseTicketDialog() {
    bool userConfirmed = false;
    bool helpdeskProof = false;
    bool qcSuitable = false;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success),
              SizedBox(width: 8),
              Text('Close Tiket (QC)'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Checklist Quality Control:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: userConfirmed,
                  onChanged: (v) => setDialogState(() => userConfirmed = v ?? false),
                  title: const Text('User sudah konfirmasi selesai', style: TextStyle(fontSize: 13)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                CheckboxListTile(
                  value: helpdeskProof,
                  onChanged: (v) => setDialogState(() => helpdeskProof = v ?? false),
                  title: const Text('Helpdesk sudah upload bukti', style: TextStyle(fontSize: 13)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                CheckboxListTile(
                  value: qcSuitable,
                  onChanged: (v) => setDialogState(() => qcSuitable = v ?? false),
                  title: const Text('Hasil kerja sesuai dengan laporan', style: TextStyle(fontSize: 13)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Catatan penutupan (opsional)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
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
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: const Text('Close Tiket'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tiket'),
        content: const Text('Apakah Anda yakin ingin menghapus tiket ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              _showSnackBar('Tiket dihapus');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium))),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;
  const _TimelineItem({required this.title, required this.date, required this.isCompleted, required this.isActive, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.success : (isActive ? AppColors.primary : AppColors.background),
                shape: BoxShape.circle,
                border: Border.all(color: isCompleted ? AppColors.success : (isActive ? AppColors.primary : AppColors.border), width: 2),
              ),
              child: isCompleted ? const Icon(Icons.check, size: 14, color: Colors.white) : (isActive ? const Icon(Icons.circle, size: 8, color: Colors.white) : null),
            ),
            if (!isLast) Container(width: 2, height: 40, color: isCompleted ? AppColors.success : AppColors.border),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
