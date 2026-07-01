import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/models/ticket.dart';
import '../../../../core/services/app_state.dart';
import '../../../../core/services/ticket_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/ticket_card.dart';
import '../../../../core/theme/app_palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ticketService = TicketService();

  bool _isLoading = true;
  String? _error;
  Map<String, int> _stats = {};
  List<Ticket> _recentTickets = [];

  static const _statConfigs = [
    {'key': 'total', 'title': 'Total Tiket', 'svgAsset': 'assets/icons/Order.svg'},
    {'key': 'submitted', 'title': 'Belum Ditangani', 'svgAsset': 'assets/icons/Clock.svg'},
    {'key': 'in_progress', 'title': 'Sedang Diproses', 'svgAsset': 'assets/icons/Loading.svg'},
    {'key': 'closed', 'title': 'Selesai', 'svgAsset': 'assets/icons/Doublecheck.svg'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _ticketService.getStats(),
        _ticketService.getMyTickets(),
      ]);
      final rawStats = results[0] as Map<String, int>;
      final tickets = results[1] as List<Ticket>;

      int total = 0;
      for (final v in rawStats.values) total += v;

      if (!mounted) return;
      setState(() {
        _stats = {...rawStats, 'total': total};
        _recentTickets = tickets.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final user = AppState.instance.currentUser;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: c.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── Header ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang,',
                            style: AppTextStyles.bodySm(c)
                                .copyWith(color: c.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(user?.fullName ?? '—', style: AppTextStyles.h4(c)),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/Notification.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                      c.textPrimary, BlendMode.srcIn),
                                ),
                                onPressed: () => Navigator.pushNamed(
                                    context, '/notifications'),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: c.primary,
                            child: Text(
                              _initials(user?.fullName),
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // ── Stats ───────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        title: 'Statistik Tiket',
                        onTap: () => Navigator.pushNamed(context, '/tickets'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (_isLoading)
                        _buildStatsPlaceholder(c)
                      else
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
                          itemCount: _statConfigs.length,
                          itemBuilder: (context, i) {
                            final cfg = _statConfigs[i];
                            return StatCard(
                              title: cfg['title'] as String,
                              count: _stats[cfg['key']] ?? 0,
                              svgAsset: cfg['svgAsset'] as String,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/tickets'),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // ── Quick action ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/create-ticket');
                        _loadData();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/Plus1.svg',
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Text('Buat Tiket Baru'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // ── Tiket Terbaru ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                  child: _SectionHeader(
                    title: 'Tiket Terbaru',
                    onTap: () => Navigator.pushNamed(context, '/tickets'),
                  ),
                ),
              ),

              if (_error != null)
                SliverToBoxAdapter(
                  child: Container(
                    color: c.surface,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'Gagal memuat tiket. Tarik untuk refresh.',
                      style: AppTextStyles.body(c)
                          .copyWith(color: c.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (_isLoading)
                SliverToBoxAdapter(
                  child: Container(
                    color: c.surface,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: CircularProgressIndicator(color: c.primary),
                    ),
                  ),
                )
              else if (_recentTickets.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    color: c.surface,
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 48, color: c.textTertiary),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Belum ada tiket',
                          style: AppTextStyles.body(c)
                              .copyWith(color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final ticket = _recentTickets[index];
                      return Container(
                        color: c.surface,
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          index == 0 ? AppSpacing.md : 0,
                          AppSpacing.lg,
                          index == _recentTickets.length - 1
                              ? AppSpacing.lg
                              : AppSpacing.md,
                        ),
                        child: TicketCard(
                          ticketId: ticket.ticketNumber,
                          title: ticket.title,
                          category: ticket.categoryName ?? '',
                          status: ticket.status.value,
                          date: _timeAgo(ticket.createdAt),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/ticket-detail',
                            arguments: {'id': ticket.id},
                          ),
                        ),
                      );
                    },
                    childCount: _recentTickets.length,
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _buildStatsPlaceholder(AppPalette c) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.3,
      children: List.generate(4, (_) => Container(
        decoration: BoxDecoration(
          color: c.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      )),
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
