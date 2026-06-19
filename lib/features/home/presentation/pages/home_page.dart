import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/stat_card.dart';
import '../widgets/category_card.dart';
import '../widgets/ticket_card.dart';
import '../../../../core/theme/app_palette.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    const userName = 'John Doe';
    const userInitial = 'JD';

    final stats = [
      {'title': 'Total Tiket', 'count': 12, 'icon': Icons.description_outlined, 'color': c.primary},
      {'title': 'Belum Ditangani', 'count': 3, 'icon': Icons.access_time, 'color': const Color(0xFFF59E0B)},
      {'title': 'Sedang Diproses', 'count': 5, 'icon': Icons.refresh, 'color': const Color(0xFF3B82F6)},
      {'title': 'Selesai', 'count': 4, 'icon': Icons.check_circle_outline, 'color': c.success},
    ];

    final categories = [
      {'category': 'Akademik', 'count': 5, 'icon': Icons.menu_book_outlined, 'bgColor': const Color(0xFFFEF3C7), 'textColor': const Color(0xFF92400E)},
      {'category': 'Teknologi', 'count': 3, 'icon': Icons.laptop_mac, 'bgColor': const Color(0xFFDBEAFE), 'textColor': const Color(0xFF1E40AF)},
      {'category': 'Fasilitas', 'count': 2, 'icon': Icons.business_outlined, 'bgColor': const Color(0xFFFCE7F3), 'textColor': const Color(0xFF9D174D)},
      {'category': 'Keuangan', 'count': 1, 'icon': Icons.credit_card_outlined, 'bgColor': const Color(0xFFD1FAE5), 'textColor': const Color(0xFF065F46)},
      {'category': 'Lainnya', 'count': 1, 'icon': Icons.more_horiz, 'bgColor': const Color(0xFFE5E7EB), 'textColor': const Color(0xFF374151)},
    ];

    final recentTickets = [
      {'ticketId': '#TK-2024-001', 'title': 'Permintaan reset password email kampus', 'category': 'Teknologi', 'status': 'diproses', 'date': '2 jam yang lalu'},
      {'ticketId': '#TK-2024-002', 'title': 'Jadwal ujian semester genap', 'category': 'Akademik', 'status': 'ditangani', 'date': '5 jam yang lalu'},
      {'ticketId': '#TK-2024-003', 'title': 'Kerusakan AC di ruang kelas', 'category': 'Fasilitas', 'status': 'selesai', 'date': '1 hari yang lalu'},
    ];

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat datang,', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: c.textSecondary)),
                        const SizedBox(height: 2),
                        Text(userName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: c.textPrimary)),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigate to notifications tab via MainScaffold
                            Navigator.pushNamed(context, '/notifications');
                          },
                          child: Stack(
                            children: [
                              IconButton(icon: Icon(Icons.notifications_outlined, color: c.textPrimary), onPressed: null),
                              Positioned(right: 8, top: 8, child: CircleAvatar(radius: 4, backgroundColor: c.error)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(radius: 18, backgroundColor: c.primary, child: Text(userInitial, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                // Quick Stats
                Text('Statistik Tiket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary)),
                const SizedBox(height: AppConstants.spacingMd),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: AppConstants.spacingMd, mainAxisSpacing: AppConstants.spacingMd, childAspectRatio: 1.3),
                  itemCount: stats.length,
                  itemBuilder: (context, index) => StatCard(title: stats[index]['title'] as String, count: stats[index]['count'] as int, icon: stats[index]['icon'] as IconData, color: stats[index]['color'] as Color),
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                // Quick Action
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/create-ticket');
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [c.primary, c.primaryHover], begin: Alignment.centerLeft, end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                        SizedBox(width: AppConstants.spacingSm),
                        Text('Buat Tiket Baru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                // Kategori
                Text('Kategori Tiket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary)),
                const SizedBox(height: AppConstants.spacingMd),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: AppConstants.spacingSm),
                      child: CategoryCard(
                        category: cat['category'] as String,
                        count: cat['count'] as int,
                        icon: cat['icon'] as IconData,
                        backgroundColor: cat['bgColor'] as Color,
                        textColor: cat['textColor'] as Color,
                        onTap: () {},
                      ),
                    )).toList(),
                  ),
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                // Tiket Terbaru
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tiket Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.textPrimary)),
                    TextButton(
                      onPressed: () {
                        // Navigate to ticket history tab
                        Navigator.pushNamed(context, '/tickets');
                      },
                      child: Text('Lihat Semua', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingMd),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTickets.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppConstants.spacingMd),
                  itemBuilder: (context, index) => TicketCard(
                    ticketId: recentTickets[index]['ticketId'] as String,
                    title: recentTickets[index]['title'] as String,
                    category: recentTickets[index]['category'] as String,
                    status: recentTickets[index]['status'] as String,
                    date: recentTickets[index]['date'] as String,
                    onTap: () {
                      Navigator.pushNamed(context, '/ticket-detail', arguments: recentTickets[index]);
                    },
                  ),
                ),

                const SizedBox(height: AppConstants.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
