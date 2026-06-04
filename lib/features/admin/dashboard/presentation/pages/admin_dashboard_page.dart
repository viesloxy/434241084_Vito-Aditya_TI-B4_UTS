import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../widgets/admin_stat_card.dart';
import '../../../widgets/admin_category_chip.dart';
import '../../../widgets/admin_ticket_card.dart';
import '../../../widgets/loading_skeleton.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';

enum DashboardState { loading, loaded, empty, error }

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  DashboardState _state = DashboardState.loading;

  final List<Map<String, dynamic>> _stats = [
    {'title': 'Total Tiket', 'count': 156, 'icon': Icons.description_outlined, 'color': AppColors.primary},
    {'title': 'Tiket Baru', 'count': 23, 'icon': Icons.fiber_new, 'color': const Color(0xFFF59E0B)},
    {'title': 'Sedang Diproses', 'count': 45, 'icon': Icons.pending, 'color': const Color(0xFF3B82F6)},
    {'title': 'Selesai', 'count': 88, 'icon': Icons.check_circle_outline, 'color': AppColors.success},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'category': 'Akademik', 'count': 45, 'icon': Icons.menu_book_outlined, 'bgColor': const Color(0xFFFEF3C7), 'textColor': const Color(0xFF92400E)},
    {'category': 'Teknologi', 'count': 38, 'icon': Icons.computer, 'bgColor': const Color(0xFFDBEAFE), 'textColor': const Color(0xFF1E40AF)},
    {'category': 'Fasilitas', 'count': 28, 'icon': Icons.business_outlined, 'bgColor': const Color(0xFFFCE7F3), 'textColor': const Color(0xFF9D174D)},
    {'category': 'Keuangan', 'count': 15, 'icon': Icons.account_balance_wallet_outlined, 'bgColor': const Color(0xFFD1FAE5), 'textColor': const Color(0xFF065F46)},
    {'category': 'Lainnya', 'count': 30, 'icon': Icons.more_horiz, 'bgColor': const Color(0xFFE5E7EB), 'textColor': const Color(0xFF374151)},
  ];

  // Mock recent tickets - menggunakan status sesuai workflow 3 role
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
    if (_recentTickets.isEmpty) {
      setState(() => _state = DashboardState.empty);
    } else {
      setState(() => _state = DashboardState.loaded);
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_recentTickets.isEmpty) {
      setState(() => _state = DashboardState.empty);
    } else {
      setState(() => _state = DashboardState.loaded);
    }
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, adminName, adminRole, constraints.maxWidth),
                    SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
                    _buildStatsSection(context, _stats, isWide),
                    SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
                    _buildCategoriesSection(context, _categories),
                    SizedBox(height: isWide ? AppConstants.spacing2xl : AppConstants.spacingXl),
                    _buildRecentTicketsSection(context),
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

  Widget _buildHeader(BuildContext context, String adminName, String adminRole, double maxWidth) {
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
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      adminName,
                      style: TextStyle(
                        fontSize: maxWidth > 360 ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      adminRole,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
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
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: isWide ? 18 : 16,
                backgroundColor: AppColors.primary,
                child: const Text('SA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, List<Map<String, dynamic>> stats, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Statistik Tiket',
              style: TextStyle(fontSize: isWide ? 18 : 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/admin/tickets'),
              child: Text('Lihat Semua', style: TextStyle(fontSize: isWide ? 15 : 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
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
          itemBuilder: (context, index) => AdminStatCard(
            title: stats[index]['title'] as String,
            count: stats[index]['count'] as int,
            icon: stats[index]['icon'] as IconData,
            color: stats[index]['color'] as Color,
            onTap: () => Navigator.pushNamed(context, '/admin/tickets', arguments: {'filter': stats[index]['title']}),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context, List<Map<String, dynamic>> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kategori Tiket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/admin/tickets'),
              child: const Text('Kelola', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) => Padding(
              padding: const EdgeInsets.only(right: AppConstants.spacingSm),
              child: AdminCategoryChip(
                category: cat['category'] as String,
                count: cat['count'] as int,
                icon: cat['icon'] as IconData,
                backgroundColor: cat['bgColor'] as Color,
                textColor: cat['textColor'] as Color,
                onTap: () => Navigator.pushNamed(context, '/admin/tickets', arguments: {'category': cat['category']}),
              ),
            )).toList(),
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
            const Text('Tiket Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/admin/tickets'),
              child: const Text('Lihat Semua', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
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
          separatorBuilder: (context, index) => const SizedBox(height: AppConstants.spacingMd),
          itemBuilder: (context, index) => AdminTicketCard(
            ticketId: _recentTickets[index]['ticketId'] as String,
            title: _recentTickets[index]['title'] as String,
            category: _recentTickets[index]['category'] as String,
            status: _recentTickets[index]['status'] as String,
            priority: _recentTickets[index]['priority'] as String,
            date: _recentTickets[index]['date'] as String,
            assignedTo: _recentTickets[index]['assignedTo'] != null ? _recentTickets[index]['assignedTo'] as String : null,
            onTap: () => Navigator.pushNamed(context, '/admin/ticket-detail', arguments: _recentTickets[index]),
          ),
        );
    }
  }
}