import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/models/ticket.dart';
import '../../../../../core/services/app_state.dart';
import '../../../../../core/services/ticket_service.dart';
import '../../../widgets/admin_stat_card.dart';
import '../../../widgets/admin_ticket_card.dart';
import '../../../widgets/loading_skeleton.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';
import '../../../../../core/theme/app_palette.dart';

enum DashboardState { loading, loaded, empty, error }

/// Admin Dashboard ala FlutterShop.
///
/// Layout: CustomScrollView + SliverToBoxAdapter per section.
/// Section gap: `SliverPadding(vertical: defaultPadding * 1.5 = 24)`.
/// Section header: Padding(h:16, v:24) + Row(Text + TextButton "Lihat Semua").
/// Tidak ada decorative container / colored section — flat white.
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _ticketService = TicketService();
  DashboardState _state = DashboardState.loading;
  String? _errorMessage;

  List<Map<String, dynamic>> _stats = [
    {'title': 'Total Tiket', 'count': 0, 'svgAsset': 'assets/icons/Order.svg'},
    {'title': 'Tiket Baru', 'count': 0, 'svgAsset': 'assets/icons/Notification.svg'},
    {'title': 'Sedang Diproses', 'count': 0, 'svgAsset': 'assets/icons/Loading.svg'},
    {'title': 'Selesai', 'count': 0, 'svgAsset': 'assets/icons/Doublecheck.svg'},
  ];

  List<Ticket> _recentTickets = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _state = DashboardState.loading);
    try {
      final results = await Future.wait([
        _ticketService.getStatsDirect(),
        _ticketService.getTickets(limit: 10),
      ]);
      final rawStats = results[0] as Map<String, int>;
      final tickets = results[1] as List<Ticket>;

      int total = 0;
      for (final v in rawStats.values) total += v;

      if (!mounted) return;
      setState(() {
        _stats = [
          {'title': 'Total Tiket', 'count': total, 'svgAsset': 'assets/icons/Order.svg'},
          {'title': 'Tiket Baru', 'count': rawStats['submitted'] ?? 0, 'svgAsset': 'assets/icons/Notification.svg'},
          {'title': 'Sedang Diproses', 'count': rawStats['in_progress'] ?? 0, 'svgAsset': 'assets/icons/Loading.svg'},
          {'title': 'Selesai', 'count': rawStats['closed'] ?? 0, 'svgAsset': 'assets/icons/Doublecheck.svg'},
        ];
        _recentTickets = tickets;
        _state = tickets.isEmpty ? DashboardState.empty : DashboardState.loaded;
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
              // ===== Header =====
              SliverToBoxAdapter(child: _buildHeader(context)),

              // ===== Stats: section header =====
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Statistik Tiket',
                  actionLabel: 'Lihat Semua',
                  onAction: () =>
                      Navigator.pushNamed(context, '/admin/tickets'),
                ),
              ),

              // ===== Stats: grid =====
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.3,
                  children: _stats.map((s) {
                    return AdminStatCard(
                      title: s['title'] as String,
                      count: s['count'] as int,
                      svgAsset: s['svgAsset'] as String,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/admin/tickets',
                        arguments: {'filter': s['title']},
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ===== Recent Tickets: section header =====
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Tiket Terbaru',
                  actionLabel: 'Lihat Semua',
                  onAction: () =>
                      Navigator.pushNamed(context, '/admin/tickets'),
                ),
              ),

              // ===== Recent Tickets: list =====
              _buildTicketsSliver(context),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final c = context.palette;
    final adminName = AppState.instance.currentUser?.fullName ?? 'Admin';
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      child: Row(
        children: [
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang,',
                  style: AppTextStyles.body(c)
                      .copyWith(color: c.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        adminName,
                        style: AppTextStyles.h2(c),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: c.primaryLight,
                        borderRadius:
                            BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'Admin',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: c.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Search icon
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Search.svg',
              width: 24,
              height: 24,
              colorFilter:
                  ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: c.border, width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/images/profil.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsSliver(BuildContext context) {
    switch (_state) {
      case DashboardState.loading:
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: LoadingSkeleton(itemCount: 3),
          ),
        );
      case DashboardState.empty:
        return SliverToBoxAdapter(
          child: EmptyState(
            title: 'Belum ada tiket',
            message: 'Tiket yang masuk akan ditampilkan di sini',
            onRefresh: _loadData,
            svgAsset: 'assets/icons/Order.svg',
          ),
        );
      case DashboardState.error:
        return SliverToBoxAdapter(
          child: ErrorState(
            message: 'Gagal memuat data tiket',
            onRetry: _loadData,
          ),
        );
      case DashboardState.loaded:
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index.isOdd) {
                  return const SizedBox(height: AppSpacing.md);
                }
                final i = index ~/ 2;
                final ticket = _recentTickets[i];
                return AdminTicketCard(
                  ticketId: ticket.ticketNumber,
                  title: ticket.title,
                  category: ticket.categoryName ?? '',
                  status: ticket.status.value,
                  priority: ticket.priority.value,
                  date: _timeAgo(ticket.createdAt),
                  assignedTo: ticket.assigneeName,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/admin/ticket-detail',
                    arguments: {'id': ticket.id},
                  ),
                );
              },
              childCount: _recentTickets.length * 2 - 1,
            ),
          ),
        );
    }
  }
}

// ===== Section Header (ala FlutterShop section title row) =====
class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Padding(
      // defaultPadding horizontal + defaultPadding * 1.5 vertical (ala FlutterShop)
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxl, // 24 = defaultPadding * 1.5
        AppSpacing.lg,
        AppSpacing.md,  // 12
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel,
              style: TextStyle(
                fontFamily: 'Plus Jakarta',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: c.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
