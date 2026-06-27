import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/stat_card.dart';
import '../widgets/category_card.dart';
import '../widgets/ticket_card.dart';
import '../../../../core/theme/app_palette.dart';

/// Home Page User ala FlutterShop — CustomScrollView + Sliver sections.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _stats = [
    {'title': 'Total Tiket', 'count': 12, 'svgAsset': 'assets/icons/Order.svg'},
    {'title': 'Belum Ditangani', 'count': 3, 'svgAsset': 'assets/icons/Clock.svg'},
    {'title': 'Sedang Diproses', 'count': 5, 'svgAsset': 'assets/icons/Loading.svg'},
    {'title': 'Selesai', 'count': 4, 'svgAsset': 'assets/icons/Doublecheck.svg'},
  ];

  static const _categories = [
    {'category': 'Akademik', 'count': 5, 'svgAsset': 'assets/icons/Order.svg', 'value': 'akademik'},
    {'category': 'Teknologi', 'count': 3, 'svgAsset': 'assets/icons/Setting.svg', 'value': 'teknologi'},
    {'category': 'Fasilitas', 'count': 2, 'svgAsset': 'assets/icons/Stores.svg', 'value': 'fasilitas'},
    {'category': 'Keuangan', 'count': 1, 'svgAsset': 'assets/icons/Cash.svg', 'value': 'keuangan'},
    {'category': 'Lainnya', 'count': 1, 'svgAsset': 'assets/icons/Category.svg', 'value': 'lainnya'},
  ];

  static const _recentTickets = [
    {
      'ticketId': '#TK-2024-001',
      'title': 'Permintaan reset password email kampus',
      'category': 'Teknologi',
      'status': 'diproses',
      'date': '2 jam yang lalu',
    },
    {
      'ticketId': '#TK-2024-002',
      'title': 'Jadwal ujian semester genap',
      'category': 'Akademik',
      'status': 'ditangani',
      'date': '5 jam yang lalu',
    },
    {
      'ticketId': '#TK-2024-003',
      'title': 'Kerusakan AC di ruang kelas',
      'category': 'Fasilitas',
      'status': 'selesai',
      'date': '1 hari yang lalu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async =>
              await Future.delayed(const Duration(seconds: 1)),
          color: c.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── Header ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _buildHeader(context),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // ── Stats grid ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        title: 'Statistik Tiket',
                        onTap: () =>
                            Navigator.pushNamed(context, '/tickets'),
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
                        itemBuilder: (context, index) => StatCard(
                          title: _stats[index]['title'] as String,
                          count: _stats[index]['count'] as int,
                          svgAsset: _stats[index]['svgAsset'] as String,
                          onTap: () =>
                              Navigator.pushNamed(context, '/tickets'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // ── Quick action ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/create-ticket'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md),
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(AppRadius.md)),
                        ),
                        elevation: 0,
                      ),
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
                          const Text(
                            'Buat Tiket Baru',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // ── Kategori ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: c.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(title: 'Kategori Tiket'),
                      const SizedBox(height: AppSpacing.md),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories
                              .map((cat) => Padding(
                                    padding: const EdgeInsets.only(
                                        right: AppSpacing.sm),
                                    child: CategoryCard(
                                      category: cat['category'] as String,
                                      count: cat['count'] as int,
                                      svgAsset: cat['svgAsset'] as String,
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        '/tickets',
                                        arguments: {
                                          'filter': cat['value']
                                        },
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // ── Tiket Terbaru header ──────────────────────────────────
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

              // ── Tiket Terbaru list ────────────────────────────────────
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
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
                      ticketId:
                          _recentTickets[index]['ticketId'] as String,
                      title: _recentTickets[index]['title'] as String,
                      category:
                          _recentTickets[index]['category'] as String,
                      status: _recentTickets[index]['status'] as String,
                      date: _recentTickets[index]['date'] as String,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/ticket-detail',
                        arguments: _recentTickets[index],
                      ),
                    ),
                  ),
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
            Text('John Doe', style: AppTextStyles.h4(c)),
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
                    colorFilter:
                        ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/notifications'),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: c.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 18,
                backgroundColor: c.primary,
                child: const Text(
                  'JD',
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
