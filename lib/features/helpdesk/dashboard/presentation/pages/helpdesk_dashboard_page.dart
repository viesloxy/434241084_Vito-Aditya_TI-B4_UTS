import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../helpdesk/widgets/helpdesk_stat_card.dart';
import '../../../../helpdesk/widgets/helpdesk_task_card.dart';
import '../../../../admin/widgets/loading_skeleton.dart';
import '../../../../admin/widgets/empty_state.dart';
import '../../../../admin/widgets/error_state.dart';
import '../../../../../core/theme/app_palette.dart';

enum DashboardState { loading, loaded, empty, error }

/// Dashboard untuk role Helpdesk.
/// Menampilkan statistik PERSONAL (tiket yang di-assign ke Helpdesk ini).
class HelpdeskDashboardPage extends StatefulWidget {
  const HelpdeskDashboardPage({super.key});

  @override
  State<HelpdeskDashboardPage> createState() => _HelpdeskDashboardPageState();
}

class _HelpdeskDashboardPageState extends State<HelpdeskDashboardPage> {
  DashboardState _state = DashboardState.loading;

  // Stats personal - hanya tiket yang di-assign ke Helpdesk ini
  List<Map<String, dynamic>> _buildStats(AppPalette c) => [
    {
      'title': 'Tugas Total',
      'count': 45,
      'icon': Icons.assignment_outlined,
      'color': c.primary,
    },
    {
      'title': 'Tugas Baru',
      'count': 5,
      'icon': Icons.fiber_new,
      'color': c.warning,
    },
    {
      'title': 'In Progress',
      'count': 2,
      'icon': Icons.pending,
      'color': c.info,
    },
    {
      'title': 'Selesai',
      'count': 38,
      'icon': Icons.check_circle_outline,
      'color': c.success,
    },
  ];

  // Tiket yang perlu dikerjakan (Signed/Assigned atau In Progress)
  final List<Map<String, dynamic>> _activeTasks = [
    {
      'ticketId': '#TK-2024-001',
      'title': 'Permintaan reset password email kampus',
      'category': 'Teknologi',
      'status': 'signed_assigned',
      'priority': 'tinggi',
      'date': '5 menit yang lalu',
      'createdBy': 'Ahmad Rizki',
    },
    {
      'ticketId': '#TK-2024-003',
      'title': 'Kerusakan AC di ruang kelas L201',
      'category': 'Fasilitas',
      'status': 'in_progress',
      'priority': 'sedang',
      'date': '30 menit yang lalu',
      'createdBy': 'Dewi Lestari',
    },
    {
      'ticketId': '#TK-2024-005',
      'title': 'Permintaan akses perpustakaan digital',
      'category': 'Akademik',
      'status': 'signed_assigned',
      'priority': 'tinggi',
      'date': '2 jam yang lalu',
      'createdBy': 'Fajar Nugroho',
    },
  ];

  // Tiket yang sudah selesai (Resolved)
  final List<Map<String, dynamic>> _resolvedTasks = [
    {
      'ticketId': '#TK-2024-004',
      'title': 'Pembayaran UKT semester baru',
      'category': 'Keuangan',
      'status': 'resolved',
      'priority': 'sedang',
      'date': '1 jam yang lalu',
      'createdBy': 'Eko Prasetyo',
      'resolutionNote': 'Sudah dikonfirmasi via WhatsApp.',
    },
    {
      'ticketId': '#TK-2024-002',
      'title': 'Jadwal ujian semester genap 2024',
      'category': 'Akademik',
      'status': 'resolved',
      'priority': 'sedang',
      'date': '3 jam yang lalu',
      'createdBy': 'Budi Santoso',
      'resolutionNote': 'Jadwal sudah diupdate di website.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _state = DashboardState.loading);
    await Future.delayed(const Duration(seconds: 1));
    if (_activeTasks.isEmpty && _resolvedTasks.isEmpty) {
      setState(() => _state = DashboardState.empty);
    } else {
      setState(() => _state = DashboardState.loaded);
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _state = _activeTasks.isEmpty && _resolvedTasks.isEmpty
            ? DashboardState.empty
            : DashboardState.loaded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    const helpdeskName = 'John Helpdesk';
    const helpdeskRole = 'Helpdesk';

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(
                    isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                        context, helpdeskName, helpdeskRole, constraints.maxWidth),
                    SizedBox(
                        height: isWide
                            ? AppConstants.spacing2xl
                            : AppConstants.spacingXl),
                    _buildStatsSection(context, _buildStats(c), isWide),
                    SizedBox(
                        height: isWide
                            ? AppConstants.spacing2xl
                            : AppConstants.spacingXl),
                    _buildActiveTasksSection(context),
                    SizedBox(
                        height: isWide
                            ? AppConstants.spacing2xl
                            : AppConstants.spacingXl),
                    _buildResolvedTasksSection(context),
                    const SizedBox(height: AppConstants.spacingLg),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String role,
      double maxWidth) {

    final c = context.palette;
    final isWide = maxWidth > 400;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang,',
                style: TextStyle(
                  fontSize: maxWidth > 360 ? 14 : 12,
                  fontWeight: FontWeight.w400,
                  color: c.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: maxWidth > 360 ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      role,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined,
                  color: c.textPrimary),
              onPressed: () {
                Navigator.pushNamed(context, '/helpdesk/notifications');
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/helpdesk/profile');
              },
              child: CircleAvatar(
                radius: isWide ? 18 : 16,
                backgroundColor: const Color(0xFF3B82F6),
                child: const Text('JH',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context,
      List<Map<String, dynamic>> stats, bool isWide) {

    final c = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Statistik Tugas Saya',
              style: TextStyle(
                  fontSize: isWide ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/helpdesk/tasks'),
              child: Text('Lihat Semua',
                  style: TextStyle(
                      fontSize: isWide ? 15 : 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF3B82F6))),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: AppConstants.spacingMd,
            mainAxisSpacing: AppConstants.spacingMd,
            childAspectRatio: isWide ? 1.2 : 1.3,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) => HelpdeskStatCard(
            title: stats[index]['title'] as String,
            count: stats[index]['count'] as int,
            icon: stats[index]['icon'] as IconData,
            color: stats[index]['color'] as Color,
            onTap: () => Navigator.pushNamed(context, '/helpdesk/tasks',
                arguments: {'filter': stats[index]['title']}),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveTasksSection(BuildContext context) {

    final c = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tugas yang Perlu Dikerjakan',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary)),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/helpdesk/tasks'),
              child: const Text('Lihat Semua',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3B82F6))),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),
        _buildActiveContent(),
      ],
    );
  }

  Widget _buildActiveContent() {
    switch (_state) {
      case DashboardState.loading:
        return const LoadingSkeleton(itemCount: 3);
      case DashboardState.empty:
        return EmptyState(
          title: 'Tidak ada tugas',
          message: 'Anda belum memiliki tiket yang perlu dikerjakan',
          onRefresh: _loadData,
          icon: Icons.assignment_outlined,
        );
      case DashboardState.error:
        return ErrorState(
          message: 'Gagal memuat data tugas',
          onRetry: _loadData,
        );
      case DashboardState.loaded:
        if (_activeTasks.isEmpty) {
          return EmptyState(
            title: 'Tidak ada tugas aktif',
            message: 'Semua tiket sudah selesai. Hebat!',
            onRefresh: _loadData,
            icon: Icons.task_alt,
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _activeTasks.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppConstants.spacingMd),
          itemBuilder: (context, index) {
            final task = _activeTasks[index];
            return HelpdeskTaskCard(
              ticketId: task['ticketId'] as String,
              title: task['title'] as String,
              category: task['category'] as String,
              status: task['status'] as String,
              priority: task['priority'] as String,
              date: task['date'] as String,
              createdBy: task['createdBy'] as String,
              onTap: () => Navigator.pushNamed(
                context,
                '/helpdesk/task-detail',
                arguments: task,
              ),
              onStart: task['status'] == 'signed_assigned'
                  ? () => _showStartTaskDialog(task)
                  : null,
              onResolve: task['status'] == 'in_progress'
                  ? () => _showResolveTaskDialog(context, task)
                  : null,
            );
          },
        );
    }
  }

  Widget _buildResolvedTasksSection(BuildContext context) {

    final c = context.palette;
    if (_state != DashboardState.loaded || _resolvedTasks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tugas Selesai',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary)),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/helpdesk/tasks'),
              child: const Text('Lihat Semua',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3B82F6))),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _resolvedTasks.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppConstants.spacingMd),
          itemBuilder: (context, index) {
            final task = _resolvedTasks[index];
            return HelpdeskTaskCard(
              ticketId: task['ticketId'] as String,
              title: task['title'] as String,
              category: task['category'] as String,
              status: task['status'] as String,
              priority: task['priority'] as String,
              date: task['date'] as String,
              createdBy: task['createdBy'] as String,
              resolutionNote: task['resolutionNote'] as String?,
              onTap: () => Navigator.pushNamed(
                context,
                '/helpdesk/task-detail',
                arguments: task,
              ),
            );
          },
        ),
      ],
    );
  }

  void _showStartTaskDialog(Map<String, dynamic> task) {
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
        content: Text(
          'Mulai kerjakan tiket ${task['ticketId']}?\n\nStatus akan berubah menjadi "In Progress".',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Mulai kerjakan ${task['ticketId']}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }

  void _showResolveTaskDialog(BuildContext context, Map<String, dynamic> task) {

    final c = context.palette;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: c.success),
            SizedBox(width: 8),
            Text('Selesaikan Tiket'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tiket: ${task['ticketId']}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('Catatan penyelesaian:',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Jelaskan hasil kerja Anda...',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                ),
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
            onPressed: () {
              if (noteController.text.trim().length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Catatan minimal 10 karakter'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tiket ${task['ticketId']} selesai'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: c.success,
            ),
            child: const Text('Selesaikan'),
          ),
        ],
      ),
    );
  }
}
