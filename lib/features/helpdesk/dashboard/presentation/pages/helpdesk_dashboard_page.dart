import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../helpdesk/widgets/helpdesk_stat_card.dart';
import '../../../../helpdesk/widgets/helpdesk_task_card.dart';
import '../../../../admin/widgets/loading_skeleton.dart';
import '../../../../admin/widgets/empty_state.dart';
import '../../../../admin/widgets/error_state.dart';
import '../../../../../core/theme/app_palette.dart';

enum DashboardState { loading, loaded, empty, error }

/// Dashboard untuk role Helpdesk — CustomScrollView + Sliver, FlutterShop style.
class HelpdeskDashboardPage extends StatefulWidget {
  const HelpdeskDashboardPage({super.key});

  @override
  State<HelpdeskDashboardPage> createState() => _HelpdeskDashboardPageState();
}

class _HelpdeskDashboardPageState extends State<HelpdeskDashboardPage> {
  DashboardState _state = DashboardState.loading;

  static const _stats = [
    {'title': 'Tugas Total', 'count': 45, 'svgAsset': 'assets/icons/Order.svg'},
    {'title': 'Tugas Baru', 'count': 5, 'svgAsset': 'assets/icons/Notification.svg'},
    {'title': 'In Progress', 'count': 2, 'svgAsset': 'assets/icons/Loading.svg'},
    {'title': 'Selesai', 'count': 38, 'svgAsset': 'assets/icons/Doublecheck.svg'},
  ];

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
    if (mounted) {
      setState(() {
        _state = (_activeTasks.isEmpty && _resolvedTasks.isEmpty)
            ? DashboardState.empty
            : DashboardState.loaded;
      });
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _state = (_activeTasks.isEmpty && _resolvedTasks.isEmpty)
            ? DashboardState.empty
            : DashboardState.loaded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: c.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _buildHeader(context),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // Stats grid
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        title: 'Statistik Tugas Saya',
                        onTap: () =>
                            Navigator.pushNamed(context, '/helpdesk/tasks'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: _stats.length,
                        itemBuilder: (context, index) => HelpdeskStatCard(
                          title: _stats[index]['title'] as String,
                          count: _stats[index]['count'] as int,
                          svgAsset: _stats[index]['svgAsset'] as String,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/helpdesk/tasks',
                            arguments: {'filter': _stats[index]['title']},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // Active tasks
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                  child: _SectionHeader(
                    title: 'Tugas yang Perlu Dikerjakan',
                    onTap: () =>
                        Navigator.pushNamed(context, '/helpdesk/tasks'),
                  ),
                ),
              ),
              _buildActiveContent(),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // Resolved tasks
              if (_state == DashboardState.loaded && _resolvedTasks.isNotEmpty)
                ...[
                SliverToBoxAdapter(
                  child: Container(
                    color: c.surface,
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                    child: _SectionHeader(
                      title: 'Tugas Selesai',
                      onTap: () =>
                          Navigator.pushNamed(context, '/helpdesk/tasks'),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = _resolvedTasks[index];
                      return Container(
                        color: context.palette.surface,
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          index == 0 ? AppSpacing.md : 0,
                          AppSpacing.lg,
                          index == _resolvedTasks.length - 1
                              ? AppSpacing.lg
                              : AppSpacing.md,
                        ),
                        child: HelpdeskTaskCard(
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
                        ),
                      );
                    },
                    childCount: _resolvedTasks.length,
                  ),
                ),
              ],

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final c = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang,',
              style: AppTextStyles.bodySm(c).copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  'John Helpdesk',
                  style: AppTextStyles.h4(c),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'Helpdesk',
                    style: AppTextStyles.caption(c).copyWith(
                      color: c.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Notification.svg',
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, '/helpdesk/notifications'),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/helpdesk/profile'),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: c.primary,
                child: const Text(
                  'JH',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveContent() {
    switch (_state) {
      case DashboardState.loading:
        return SliverToBoxAdapter(
          child: Container(
            color: context.palette.surface,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: const LoadingSkeleton(itemCount: 3),
          ),
        );
      case DashboardState.empty:
        return SliverToBoxAdapter(
          child: Container(
            color: context.palette.surface,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: EmptyState(
              title: 'Tidak ada tugas',
              message: 'Anda belum memiliki tiket yang perlu dikerjakan',
              onRefresh: _loadData,
              svgAsset: 'assets/icons/Order.svg',
            ),
          ),
        );
      case DashboardState.error:
        return SliverToBoxAdapter(
          child: Container(
            color: context.palette.surface,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ErrorState(
              message: 'Gagal memuat data tugas',
              onRetry: _loadData,
            ),
          ),
        );
      case DashboardState.loaded:
        if (_activeTasks.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              color: context.palette.surface,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: EmptyState(
                title: 'Tidak ada tugas aktif',
                message: 'Semua tiket sudah selesai. Hebat!',
                onRefresh: _loadData,
                svgAsset: 'assets/icons/Doublecheck.svg',
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final task = _activeTasks[index];
              return Container(
                color: context.palette.surface,
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  index == 0 ? AppSpacing.md : 0,
                  AppSpacing.lg,
                  index == _activeTasks.length - 1
                      ? AppSpacing.lg
                      : AppSpacing.md,
                ),
                child: HelpdeskTaskCard(
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
                ),
              );
            },
            childCount: _activeTasks.length,
          ),
        );
    }
  }

  void _showStartTaskDialog(Map<String, dynamic> task) {
    final c = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Loading.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('Mulai Kerjakan', style: AppTextStyles.h4(c)),
          ],
        ),
        content: Text(
          'Mulai kerjakan tiket ${task['ticketId']}?\n\nStatus akan berubah menjadi "In Progress".',
          style: AppTextStyles.body(c),
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
                  content: Text('Mulai kerjakan ${task['ticketId']}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primary,
              elevation: 0,
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Doublecheck.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(c.success, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('Selesaikan Tiket', style: AppTextStyles.h4(c)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiket: ${task['ticketId']}',
                style: AppTextStyles.body(c)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Catatan penyelesaian:',
                  style: AppTextStyles.bodySm(c)),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Jelaskan hasil kerja Anda...',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.md),
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
              elevation: 0,
            ),
            child: const Text('Selesaikan'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              'Lihat Semua',
              style: AppTextStyles.bodySm(c).copyWith(
                color: c.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
