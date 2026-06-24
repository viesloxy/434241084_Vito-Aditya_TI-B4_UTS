import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../widgets/admin_stat_card.dart';
import '../../../widgets/admin_category_chip.dart';
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
  DashboardState _state = DashboardState.loading;

  final List<Map<String, dynamic>> _stats = [
    {'title': 'Total Tiket', 'count': 156, 'svgAsset': 'assets/icons/Order.svg'},
    {'title': 'Tiket Baru', 'count': 23, 'svgAsset': 'assets/icons/Notification.svg'},
    {'title': 'Sedang Diproses', 'count': 45, 'svgAsset': 'assets/icons/Loading.svg'},
    {'title': 'Selesai', 'count': 88, 'svgAsset': 'assets/icons/Doublecheck.svg'},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'category': 'Akademik', 'count': 45, 'icon': Icons.menu_book_outlined},
    {'category': 'Teknologi', 'count': 38, 'icon': Icons.computer},
    {'category': 'Fasilitas', 'count': 28, 'icon': Icons.business_outlined},
    {'category': 'Keuangan', 'count': 15, 'icon': Icons.account_balance_wallet_outlined},
    {'category': 'Lainnya', 'count': 30, 'icon': Icons.more_horiz},
  ];

  final List<Map<String, dynamic>> _recentTickets = [
    {'ticketId': '#TK-2024-001', 'title': 'Permintaan reset password email kampus', 'category': 'Teknologi', 'status': 'submitted', 'priority': 'tinggi', 'date': '5 menit lalu', 'assignedTo': null, 'createdBy': 'Ahmad Rizki'},
    {'ticketId': '#TK-2024-002', 'title': 'Jadwal ujian semester genap 2024', 'category': 'Akademik', 'status': 'signed_assigned', 'priority': 'sedang', 'date': '15 menit lalu', 'assignedTo': 'John Helpdesk', 'createdBy': 'Budi Santoso'},
    {'ticketId': '#TK-2024-003', 'title': 'Kerusakan AC di ruang kelas L201', 'category': 'Fasilitas', 'status': 'in_progress', 'priority': 'rendah', 'date': '30 menit lalu', 'assignedTo': 'Sarah Helpdesk', 'createdBy': 'Dewi Lestari'},
    {'ticketId': '#TK-2024-004', 'title': 'Tagihan UKT semester genap', 'category': 'Keuangan', 'status': 'resolved', 'priority': 'sedang', 'date': '1 jam lalu', 'assignedTo': 'Budi Helpdesk', 'createdBy': 'Eko Prasetyo'},
    {'ticketId': '#TK-2024-005', 'title': 'Permintaan akses perpustakaan digital', 'category': 'Akademik', 'status': 'in_progress', 'priority': 'tinggi', 'date': '2 jam lalu', 'assignedTo': 'John Helpdesk', 'createdBy': 'Fajar Nugroho'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _state = DashboardState.loading);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _state = _recentTickets.isEmpty
        ? DashboardState.empty
        : DashboardState.loaded);
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _state = _recentTickets.isEmpty
        ? DashboardState.empty
        : DashboardState.loaded);
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

              // ===== Categories: section header =====
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Kategori Tiket',
                  actionLabel: 'Kelola',
                  onAction: () =>
                      Navigator.pushNamed(context, '/admin/tickets'),
                ),
              ),

              // ===== Categories: horizontal chips =====
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return AdminCategoryChip(
                        category: cat['category'] as String,
                        count: cat['count'] as int,
                        icon: cat['icon'] as IconData,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/admin/tickets',
                          arguments: {'category': cat['category']},
                        ),
                      );
                    },
                  ),
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
    const adminName = 'Sarah Admin';
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
                  ticketId: ticket['ticketId'] as String,
                  title: ticket['title'] as String,
                  category: ticket['category'] as String,
                  status: ticket['status'] as String,
                  priority: ticket['priority'] as String,
                  date: ticket['date'] as String,
                  assignedTo: ticket['assignedTo'] != null
                      ? ticket['assignedTo'] as String
                      : null,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/admin/ticket-detail',
                    arguments: ticket,
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
