import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_max_width.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../widgets/admin_stat_card.dart';
import '../../../widgets/admin_category_chip.dart';
import '../../../widgets/admin_ticket_card.dart';
import '../../../widgets/loading_skeleton.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';

enum DashboardState { loading, loaded, empty, error }

/// Admin Dashboard ala FlutterShop — full-bleed (AppMaxWidth.infinite).
/// Section pattern: header → stats grid → categories → recent tickets.
/// Semua aksen pakai `AppColors.primary` (flat 2D, no decorative colors).
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 8.
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  DashboardState _state = DashboardState.loading;

  final List<Map<String, dynamic>> _stats = [
    {'title': 'Total Tiket', 'count': 156, 'icon': Icons.description_outlined},
    {'title': 'Tiket Baru', 'count': 23, 'icon': Icons.fiber_new},
    {'title': 'Sedang Diproses', 'count': 45, 'icon': Icons.pending_outlined},
    {'title': 'Selesai', 'count': 88, 'icon': Icons.check_circle_outline},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'category': 'Akademik', 'count': 45, 'icon': Icons.menu_book_outlined},
    {'category': 'Teknologi', 'count': 38, 'icon': Icons.computer},
    {'category': 'Fasilitas', 'count': 28, 'icon': Icons.business_outlined},
    {'category': 'Keuangan', 'count': 15, 'icon': Icons.account_balance_wallet_outlined},
    {'category': 'Lainnya', 'count': 30, 'icon': Icons.more_horiz},
  ];

  final List<Map<String, dynamic>> _recentTickets = [
    {'ticketId': '#TK-2024-001', 'title': 'Permintaan reset password email kampus', 'category': 'Teknologi', 'status': 'submitted', 'priority': 'tinggi', 'date': '5 menit yang lalu', 'assignedTo': null, 'createdBy': 'Ahmad Rizki'},
    {'ticketId': '#TK-2024-002', 'title': 'Jadwal ujian semester genap 2024', 'category': 'Akademik', 'status': 'signed_assigned', 'priority': 'sedang', 'date': '15 menit yang lalu', 'assignedTo': 'John Helpdesk', 'createdBy': 'Budi Santoso'},
    {'ticketId': '#TK-2024-003', 'title': 'Kerusakan AC di ruang kelas L201', 'category': 'Fasilitas', 'status': 'in_progress', 'priority': 'rendah', 'date': '30 menit yang lalu', 'assignedTo': 'Sarah Helpdesk', 'createdBy': 'Dewi Lestari'},
    {'ticketId': '#TK-2024-004', 'title': 'Tagihan UKT semester genap', 'category': 'Keuangan', 'status': 'resolved', 'priority': 'sedang', 'date': '1 jam yang lalu', 'assignedTo': 'Budi Helpdesk', 'createdBy': 'Eko Prasetyo'},
    {'ticketId': '#TK-2024-005', 'title': 'Permintaan akses perpustakaan digital', 'category': 'Akademik', 'status': 'in_progress', 'priority': 'tinggi', 'date': '2 jam yang lalu', 'assignedTo': 'John Helpdesk', 'createdBy': 'Fajar Nugroho'},
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
    const adminName = 'Sarah Admin';
    const adminRole = 'Administrator';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg), // defaultPadding = 16
            child: CenteredContent(
              maxWidth: AppMaxWidth.infinite, // full-bleed ala FlutterShop
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, adminName, adminRole),
                  const SizedBox(height: AppSpacing.xxl), // section break 24
                  _buildStatsSection(context),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildCategoriesSection(context),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildRecentTicketsSection(context),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String adminName, String adminRole) {
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
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      adminName,
                      style: AppTextStyles.h2,
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
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      adminRole,
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.primary,
                        fontSize: 10,
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
              icon: const Icon(Icons.search, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            // Avatar dengan profil.jpeg (dummy)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/images/profil.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final crossAxisCount = isWide ? 4 : 2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Statistik Tiket', style: AppTextStyles.h4),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/admin/tickets'),
                  child: Text(
                    'Lihat Semua',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: isWide ? 1.2 : 1.3,
              ),
              itemCount: _stats.length,
              itemBuilder: (context, index) => AdminStatCard(
                title: _stats[index]['title'] as String,
                count: _stats[index]['count'] as int,
                icon: _stats[index]['icon'] as IconData,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/admin/tickets',
                  arguments: {'filter': _stats[index]['title']},
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kategori Tiket', style: AppTextStyles.h4),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/admin/tickets'),
              child: Text(
                'Kelola',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories
                .map((cat) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: AdminCategoryChip(
                        category: cat['category'] as String,
                        count: cat['count'] as int,
                        icon: cat['icon'] as IconData,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/admin/tickets',
                          arguments: {'category': cat['category']},
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTicketsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tiket Terbaru', style: AppTextStyles.h4),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/admin/tickets'),
              child: Text(
                'Lihat Semua',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTicketsContent(),
      ],
    );
  }

  Widget _buildTicketsContent() {
    switch (_state) {
      case DashboardState.loading:
        return const LoadingSkeleton(itemCount: 5);
      case DashboardState.empty:
        return EmptyState(
          title: 'Belum ada tiket',
          message: 'Tiket yang masuk akan ditampilkan di sini',
          onRefresh: _loadData,
          icon: Icons.inbox_outlined,
        );
      case DashboardState.error:
        return ErrorState(
          message: 'Gagal memuat data tiket',
          onRetry: _loadData,
        );
      case DashboardState.loaded:
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentTickets.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => AdminTicketCard(
            ticketId: _recentTickets[index]['ticketId'] as String,
            title: _recentTickets[index]['title'] as String,
            category: _recentTickets[index]['category'] as String,
            status: _recentTickets[index]['status'] as String,
            priority: _recentTickets[index]['priority'] as String,
            date: _recentTickets[index]['date'] as String,
            assignedTo: _recentTickets[index]['assignedTo'] != null
                ? _recentTickets[index]['assignedTo'] as String
                : null,
            onTap: () => Navigator.pushNamed(
              context,
              '/admin/ticket-detail',
              arguments: _recentTickets[index],
            ),
          ),
        );
    }
  }
}
