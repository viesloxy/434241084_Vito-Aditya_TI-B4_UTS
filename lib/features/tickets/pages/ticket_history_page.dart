import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/category_badge.dart';
import '../../../core/theme/app_palette.dart';

class TicketHistoryPage extends StatefulWidget {
  const TicketHistoryPage({super.key});

  @override
  State<TicketHistoryPage> createState() => _TicketHistoryPageState();
}

class _TicketHistoryPageState extends State<TicketHistoryPage> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'semua';
  bool _isSearchVisible = false;

  final List<Map<String, dynamic>> _filters = [
    {'name': 'Semua', 'value': 'semua'},
    {'name': 'Baru', 'value': 'baru'},
    {'name': 'Ditangani', 'value': 'ditangani'},
    {'name': 'Diproses', 'value': 'diproses'},
    {'name': 'Selesai', 'value': 'selesai'},
  ];

  final List<Map<String, dynamic>> _tickets = [
    {
      'ticketId': '#TK-2024-001',
      'title': 'Permintaan reset password email kampus',
      'category': 'Teknologi',
      'status': 'diproses',
      'date': '21 Jan 2024, 10:00',
    },
    {
      'ticketId': '#TK-2024-002',
      'title': 'Jadwal ujian semester genap',
      'category': 'Akademik',
      'status': 'ditangani',
      'date': '20 Jan 2024, 14:30',
    },
    {
      'ticketId': '#TK-2024-003',
      'title': 'Kerusakan AC di ruang kelas',
      'category': 'Fasilitas',
      'status': 'selesai',
      'date': '19 Jan 2024, 09:15',
    },
    {
      'ticketId': '#TK-2024-004',
      'title': 'Pembayaran UKT semester baru',
      'category': 'Keuangan',
      'status': 'baru',
      'date': '22 Jan 2024, 08:45',
    },
    {
      'ticketId': '#TK-2024-005',
      'title': 'Permintaan pinjam ruangan lab komputer',
      'category': 'Akademik',
      'status': 'diproses',
      'date': '18 Jan 2024, 16:20',
    },
    {
      'ticketId': '#TK-2024-006',
      'title': 'Masalah koneksi internet di asrama',
      'category': 'Teknologi',
      'status': 'ditangani',
      'date': '17 Jan 2024, 11:00',
    },
  ];

  List<Map<String, dynamic>> get _filteredTickets {
    var filtered = _tickets;
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((t) =>
              t['title']
                  .toString()
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              t['ticketId']
                  .toString()
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }
    if (_selectedFilter != 'semua') {
      filtered =
          filtered.where((t) => t['status'] == _selectedFilter).toList();
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        title: _isSearchVisible
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Cari tiket...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: c.textSecondary),
                ),
                style: AppTextStyles.body(c),
                onChanged: (_) => setState(() {}),
              )
            : Text('Tiket Saya', style: AppTextStyles.h4(c)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              _isSearchVisible
                  ? 'assets/icons/Close.svg'
                  : 'assets/icons/Search.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
            ),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) _searchController.clear();
              });
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Filter.svg',
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
            ),
            onPressed: () => _showFilterModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: c.surface,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter['value'];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedFilter = filter['value'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? c.primary : c.background,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                              color: isSelected ? c.primary : c.border),
                        ),
                        child: Text(
                          filter['name'] as String,
                          style: AppTextStyles.bodySm(c).copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected ? Colors.white : c.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Ticket list
          Expanded(
            child: _filteredTickets.isEmpty
                ? _buildEmptyState(context)
                : RefreshIndicator(
                    onRefresh: () async =>
                        await Future.delayed(const Duration(seconds: 1)),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: _filteredTickets.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final ticket = _filteredTickets[index];
                        return _TicketListItem(
                          ticketId: ticket['ticketId'] as String,
                          title: ticket['title'] as String,
                          category: ticket['category'] as String,
                          status: ticket['status'] as String,
                          date: ticket['date'] as String,
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/ticket-detail',
                            arguments: ticket,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final c = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/Order.svg',
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Belum Ada Tiket',
              style: AppTextStyles.h4(c),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tiket yang Anda buat akan muncul di sini',
              style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl, vertical: AppSpacing.md),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppRadius.md)),
                ),
                elevation: 0,
              ),
              child: const Text('Buat Tiket Baru'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    final c = context.palette;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Tiket', style: AppTextStyles.h4(c)),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Status',
              style:
                  AppTextStyles.body(c).copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter['value'];
                return ChoiceChip(
                  label: Text(filter['name'] as String),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedFilter = filter['value'] as String);
                    Navigator.pop(context);
                  },
                  selectedColor: c.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : c.textPrimary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _selectedFilter = 'semua');
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppRadius.md)),
                  ),
                ),
                child: const Text('Reset Filter'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _TicketListItem extends StatelessWidget {
  final String ticketId;
  final String title;
  final String category;
  final String status;
  final String date;
  final VoidCallback onTap;

  const _TicketListItem({
    required this.ticketId,
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: c.border, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticketId,
                    style: AppTextStyles.caption(c).copyWith(
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    style: AppTextStyles.body(c).copyWith(
                      fontWeight: FontWeight.w500,
                      color: c.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      CategoryBadge(category: category),
                      const SizedBox(width: AppSpacing.sm),
                      StatusBadge(status: status),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    date,
                    style: AppTextStyles.caption(c)
                        .copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SvgPicture.asset(
              'assets/icons/miniRight.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
