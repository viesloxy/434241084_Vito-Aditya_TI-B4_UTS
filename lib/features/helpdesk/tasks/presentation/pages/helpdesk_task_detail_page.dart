import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../shared/widgets/status_badge.dart';
import '../../../../../shared/widgets/category_badge.dart';

enum DetailPageState { loading, loaded, error }

/// Halaman detail tiket untuk Helpdesk.
/// Berbeda dari AdminTicketDetailPage: Helpdesk HANYA bisa
/// 1) Mulai Kerjakan (Signed/Assigned → In Progress)
/// 2) Selesaikan (In Progress → Resolved)
/// Tidak bisa assign, close, atau ubah tiket yang bukan assigned.
class HelpdeskTaskDetailPage extends StatefulWidget {
  final Map<String, dynamic>? ticketData;

  const HelpdeskTaskDetailPage({super.key, this.ticketData});

  @override
  State<HelpdeskTaskDetailPage> createState() => _HelpdeskTaskDetailPageState();
}

class _HelpdeskTaskDetailPageState extends State<HelpdeskTaskDetailPage> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  static const int _maxCharacters = 500;

  DetailPageState _state = DetailPageState.loading;

  Map<String, dynamic> _taskData = {};

  final List<Map<String, dynamic>> _statusTimeline = [
    {'status': 'Submitted', 'date': '21 Jan 2024, 10:00', 'isCompleted': true, 'isActive': false},
    {'status': 'Signed/Assigned', 'date': '21 Jan 2024, 10:15', 'isCompleted': true, 'isActive': false},
    {'status': 'In Progress', 'date': '-', 'isCompleted': false, 'isActive': false},
    {'status': 'Resolved', 'date': '-', 'isCompleted': false, 'isActive': false},
    {'status': 'Closed', 'date': '-', 'isCompleted': false, 'isActive': false},
  ];

  final List<Map<String, dynamic>> _conversations = [
    {
      'sender': 'John Helpdesk',
      'role': 'helpdesk',
      'message': 'Sedang saya cek dulu, mohon tunggu.',
      'time': '21 Jan 2024, 10:30',
      'isMe': true,
    },
    {
      'sender': 'Ahmad Rizki',
      'role': 'user',
      'message': 'Baik terima kasih, saya tunggu.',
      'time': '21 Jan 2024, 11:00',
      'isMe': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _taskData = widget.ticketData ?? {};
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
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _state = DetailPageState.loaded;
        // Update timeline sesuai status
        _updateTimelineForStatus();
      });
    }
  }

  void _updateTimelineForStatus() {
    final status = _taskData['status'] as String? ?? 'signed_assigned';
    final statusIndex = {
      'submitted': 0,
      'signed_assigned': 1,
      'in_progress': 2,
      'resolved': 3,
      'closed': 4,
    }[status] ?? 1;

    for (int i = 0; i < _statusTimeline.length; i++) {
      _statusTimeline[i]['isCompleted'] = i <= statusIndex;
      _statusTimeline[i]['isActive'] = i == statusIndex;
    }
  }

  int get _characterCount => _commentController.text.length;

  String _getString(String key, String defaultValue) {
    final value = _taskData[key];
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
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context)),
      title: Text(
        _getString('ticketId', '#TK-0000'),
        style: TextStyle(
            fontSize: isWide ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      ),
      centerTitle: true,
      actions: [
        IconButton(
            icon: const Icon(Icons.report_outlined,
                color: AppColors.textPrimary),
            onPressed: () => _showReportDialog(),
            tooltip: 'Lapor ke Admin'),
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
              const Icon(Icons.error_outline,
                  size: 64, color: AppColors.error),
              const SizedBox(height: AppConstants.spacingLg),
              const Text('Gagal memuat detail tugas'),
              const SizedBox(height: AppConstants.spacingMd),
              ElevatedButton(
                  onPressed: _loadData, child: const Text('Coba Lagi')),
            ],
          ),
        );
      case DetailPageState.loaded:
        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.all(
              isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaskHeader(isWide),
              SizedBox(
                  height:
                      isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
              _buildStatusTimeline(isWide),
              SizedBox(
                  height:
                      isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
              _buildTaskDetails(isWide),
              SizedBox(
                  height:
                      isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
              _buildDescriptionSection(isWide),
              SizedBox(
                  height:
                      isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
              _buildConversationSection(isWide),
              SizedBox(
                  height:
                      isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
              _buildActionButton(isWide),
              const SizedBox(height: AppConstants.spacingLg),
            ],
          ),
        );
    }
  }

  Widget _buildTaskHeader(bool isWide) {
    final title = _getString('title', 'Judul tidak tersedia');
    final category = _getString('category', 'Lainnya');
    final status = _getString('status', 'signed_assigned');
    final priority = _getString('priority', 'sedang');
    final date = _getString('date', '-');

    return Container(
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: isWide ? 20 : 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          SizedBox(
              height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          Wrap(
            spacing: AppConstants.spacingSm,
            runSpacing: AppConstants.spacingSm,
            children: [
              CategoryBadge(category: category),
              StatusBadge(status: status),
              _buildPriorityBadge(priority),
            ],
          ),
          SizedBox(
              height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          Row(
            children: [
              const Icon(Icons.access_time,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('Di-assign: $date',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
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
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(bool isWide) {
    return Container(
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Timeline Status',
              style: TextStyle(
                  fontSize: isWide ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          SizedBox(
              height:
                  isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
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

  Widget _buildTaskDetails(bool isWide) {
    final createdBy = _getString('createdBy', 'Unknown');
    final email = '${createdBy.toLowerCase().replaceAll(' ', '.')}@student.ac.id';
    final priority = _getString('priority', 'sedang');
    final date = _getString('date', '-');

    return Container(
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Tugas',
              style: TextStyle(
                  fontSize: isWide ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          SizedBox(
              height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          _buildDetailRow(
              'Pembuat', createdBy, Icons.person_outline, false, isWide),
          _buildDetailRow('Email', email, Icons.email_outlined, false, isWide),
          _buildDetailRow(
              'Prioritas', priority, Icons.flag_outlined, false, isWide),
          _buildDetailRow(
              'Tanggal Di-assign', date, Icons.calendar_today_outlined, false, isWide),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon,
      bool isEditable, bool isWide) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                Text(value,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(bool isWide) {
    final description = _getString(
        'description',
        'Tidak bisa login ke email kampus saya sejak kemarin. Sudah mencoba reset password tetapi tidak menerima email reset. Mohon bantuannya untuk reset password email saya.');

    return Container(
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deskripsi',
              style: TextStyle(
                  fontSize: isWide ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          SizedBox(
              height: isWide ? AppConstants.spacingSm : 4),
          Text(
            description,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationSection(bool isWide) {
    return Container(
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Percakapan',
              style: TextStyle(
                  fontSize: isWide ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          SizedBox(
              height: isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
          if (_conversations.isEmpty)
            const Center(
                child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Belum ada percakapan',
                        style: TextStyle(color: AppColors.textSecondary))))
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
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF3B82F6) : AppColors.background,
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
                  Text(sender,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B82F6))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Text('User',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E40AF))),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            Text(message,
                style: TextStyle(
                    fontSize: 14,
                    color: isMe ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(time,
                style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(bool isWide) {
    final status = _getString('status', 'signed_assigned');

    if (status == 'signed_assigned') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showStartTaskDialog(),
          icon: const Icon(Icons.play_arrow, size: 20),
          label: const Text('Mulai Kerjakan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
          ),
        ),
      );
    } else if (status == 'in_progress') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showUploadProofDialog(),
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Upload Bukti'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium)),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showResolveTaskDialog(),
              icon: const Icon(Icons.check_circle, size: 18),
              label: const Text('Selesaikan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium)),
              ),
            ),
          ),
        ],
      );
    } else {
      // resolved / closed - read only
      return Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline,
                size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                status == 'resolved'
                    ? 'Tiket sudah selesai. Menunggu konfirmasi User.'
                    : 'Tiket sudah ditutup.',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCommentInput(bool isWide) {
    return Container(
      padding: EdgeInsets.all(
          isWide ? AppConstants.spacingMd : AppConstants.spacingSm),
      decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border))),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.attach_file,
                        color: AppColors.textSecondary),
                    onPressed: () => _showSnackBar('Pilih lampiran')),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    maxLines: 3,
                    minLines: 1,
                    maxLength: _maxCharacters,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusLarge),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: isWide ? 16 : 12,
                          vertical: isWide ? 12 : 10),
                      counterText: '',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingXs),
                IconButton(
                  icon: Icon(Icons.send,
                      color: _commentController.text.isEmpty
                          ? AppColors.textSecondary
                          : const Color(0xFF3B82F6)),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('$_characterCount/$_maxCharacters',
                      style: TextStyle(
                          fontSize: 11,
                          color: _characterCount > _maxCharacters
                              ? AppColors.error
                              : AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStartTaskDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        title: const Row(
          children: [
            Icon(Icons.play_arrow, color: Color(0xFF3B82F6)),
            SizedBox(width: 8),
            Text('Mulai Kerjakan'),
          ],
        ),
        content: const Text(
          'Status akan berubah menjadi "In Progress".',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _taskData['status'] = 'in_progress';
                _updateTimelineForStatus();
              });
              _showSnackBar('Status: In Progress');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6)),
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }

  void _showUploadProofDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        title: const Row(
          children: [
            Icon(Icons.upload_file, color: Color(0xFF3B82F6)),
            SizedBox(width: 8),
            Text('Upload Bukti'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih sumber file:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFF3B82F6)),
              title: Text('Kamera'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Color(0xFF3B82F6)),
              title: Text('Galeri'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.folder, color: Color(0xFF3B82F6)),
              title: Text('File'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
        ],
      ),
    );
  }

  void _showResolveTaskDialog() {
    final noteController = TextEditingController();
    bool problemSolved = false;
    bool proofUploaded = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success),
              SizedBox(width: 8),
              Text('Selesaikan Tiket'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  value: problemSolved,
                  onChanged: (v) =>
                      setDialogState(() => problemSolved = v ?? false),
                  title: const Text('Saya sudah mengerjakan masalah',
                      style: TextStyle(fontSize: 13)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                CheckboxListTile(
                  value: proofUploaded,
                  onChanged: (v) =>
                      setDialogState(() => proofUploaded = v ?? false),
                  title: const Text('Saya sudah upload bukti',
                      style: TextStyle(fontSize: 13)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Catatan penyelesaian',
                    hintText: 'Jelaskan hasil kerja...',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
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
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: (problemSolved &&
                      proofUploaded &&
                      noteController.text.trim().length >= 10)
                  ? () {
                      Navigator.pop(ctx);
                      setState(() {
                        _taskData['status'] = 'resolved';
                        _updateTimelineForStatus();
                      });
                      _showSnackBar('Tiket selesai! Menunggu konfirmasi User');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success),
              child: const Text('Selesaikan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    final issueController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        title: const Row(
          children: [
            Icon(Icons.report_outlined, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Lapor ke Admin'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Jelaskan masalah yang Anda hadapi:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: issueController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Misal: Butuh bantuan spesialis IT',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (issueController.text.trim().length < 10) {
                _showSnackBar('Deskripsi minimal 10 karakter');
                return;
              }
              Navigator.pop(ctx);
              _showSnackBar('Laporan terkirim ke Admin');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning),
            child: const Text('Kirim'),
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
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.radiusMedium)),
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
  const _TimelineItem(
      {required this.title,
      required this.date,
      required this.isCompleted,
      required this.isActive,
      required this.isLast});

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
                color: isCompleted
                    ? AppColors.success
                    : (isActive ? const Color(0xFF3B82F6) : AppColors.background),
                shape: BoxShape.circle,
                border: Border.all(
                    color: isCompleted
                        ? AppColors.success
                        : (isActive
                            ? const Color(0xFF3B82F6)
                            : AppColors.border),
                    width: 2),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : (isActive
                      ? const Icon(Icons.circle, size: 8, color: Colors.white)
                      : null),
            ),
            if (!isLast)
              Container(
                  width: 2,
                  height: 40,
                  color: isCompleted ? AppColors.success : AppColors.border),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(date,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
