import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/models/ticket.dart';
import '../../../../../core/services/app_state.dart';
import '../../../../../core/services/ticket_service.dart';
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
  final _ticketService = TicketService();
  DashboardState _state = DashboardState.loading;
  String? _errorMessage;

  List<Map<String, dynamic>> _stats = [
    {'title': 'Tugas Total', 'count': 0, 'svgAsset': 'assets/icons/Order.svg'},
    {'title': 'Tugas Baru', 'count': 0, 'svgAsset': 'assets/icons/Notification.svg'},
    {'title': 'In Progress', 'count': 0, 'svgAsset': 'assets/icons/Loading.svg'},
    {'title': 'Selesai', 'count': 0, 'svgAsset': 'assets/icons/Doublecheck.svg'},
  ];

  List<Ticket> _activeTasks = [];
  List<Ticket> _resolvedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _state = DashboardState.loading);
    try {
      final userId = AppState.instance.currentUser?.id;
      final results = await Future.wait([
        _ticketService.getAssignedToMe(),
        if (userId != null)
          _ticketService.getStatsDirect(assignedTo: userId)
        else
          Future.value(<String, int>{}),
      ]);
      final allTasks = results[0] as List<Ticket>;
      final rawStats = results[1] as Map<String, int>;

      final active = allTasks
          .where((t) =>
              t.status == TicketStatus.signedAssigned ||
              t.status == TicketStatus.inProgress)
          .toList();
      final resolved = allTasks
          .where((t) => t.status == TicketStatus.resolved)
          .toList();

      int total = 0;
      for (final v in rawStats.values) total += v;

      if (!mounted) return;
      setState(() {
        _stats = [
          {'title': 'Tugas Total', 'count': total, 'svgAsset': 'assets/icons/Order.svg'},
          {'title': 'Tugas Baru', 'count': rawStats['signed_assigned'] ?? 0, 'svgAsset': 'assets/icons/Notification.svg'},
          {'title': 'In Progress', 'count': rawStats['in_progress'] ?? 0, 'svgAsset': 'assets/icons/Loading.svg'},
          {'title': 'Selesai', 'count': rawStats['resolved'] ?? 0, 'svgAsset': 'assets/icons/Doublecheck.svg'},
        ];
        _activeTasks = active;
        _resolvedTasks = resolved;
        _state = (active.isEmpty && resolved.isEmpty)
            ? DashboardState.empty
            : DashboardState.loaded;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _state = DashboardState.error;
      });
    }
  }

  Future<void> _refreshData() => _loadData();

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
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
                          ticketId: task.ticketNumber,
                          title: task.title,
                          category: task.categoryName ?? '',
                          status: task.status.value,
                          priority: task.priority.value,
                          date: _timeAgo(task.createdAt),
                          createdBy: task.creatorName ?? '',
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/helpdesk/task-detail',
                            arguments: {'id': task.id},
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
                  AppState.instance.currentUser?.fullName ?? 'Helpdesk',
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
                child: Text(
                  _initials(AppState.instance.currentUser?.fullName),
                  style: const TextStyle(
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
                  ticketId: task.ticketNumber,
                  title: task.title,
                  category: task.categoryName ?? '',
                  status: task.status.value,
                  priority: task.priority.value,
                  date: _timeAgo(task.createdAt),
                  createdBy: task.creatorName ?? '',
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/helpdesk/task-detail',
                    arguments: {'id': task.id},
                  ),
                  onStart: task.status == TicketStatus.signedAssigned
                      ? () => _handleStartTask(task)
                      : null,
                  onResolve: task.status == TicketStatus.inProgress
                      ? () => _handleResolveTask(task)
                      : null,
                ),
              );
            },
            childCount: _activeTasks.length,
          ),
        );
    }
  }

  Future<void> _handleStartTask(Ticket task) async {
    final c = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Text('Mulai Kerjakan', style: AppTextStyles.h4(c)),
        content: Text(
          'Mulai kerjakan tiket ${task.ticketNumber}?\n\nStatus akan berubah menjadi "In Progress".',
          style: AppTextStyles.body(c),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Mulai')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _ticketService.startTicket(task.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tiket ${task.ticketNumber} dimulai'), behavior: SnackBarBehavior.floating),
      );
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _handleResolveTask(Ticket task) async {
    final c = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Text('Selesaikan Tiket', style: AppTextStyles.h4(c)),
        content: Text(
          'Tandai tiket ${task.ticketNumber} sebagai selesai?',
          style: AppTextStyles.body(c),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: c.success, elevation: 0),
            child: const Text('Selesaikan'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _ticketService.resolveTicket(task.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tiket ${task.ticketNumber} selesai'), behavior: SnackBarBehavior.floating),
      );
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return 'H';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
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
