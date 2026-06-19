import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
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
    {'ticketId': '#TK-2024-001', 'title': 'Permintaan reset password email kampus', 'category': 'Teknologi', 'status': 'diproses', 'date': '21 Jan 2024, 10:00'},
    {'ticketId': '#TK-2024-002', 'title': 'Jadwal ujian semester genap', 'category': 'Akademik', 'status': 'ditangani', 'date': '20 Jan 2024, 14:30'},
    {'ticketId': '#TK-2024-003', 'title': 'Kerusakan AC di ruang kelas', 'category': 'Fasilitas', 'status': 'selesai', 'date': '19 Jan 2024, 09:15'},
    {'ticketId': '#TK-2024-004', 'title': 'Pembayaran UKT semester baru', 'category': 'Keuangan', 'status': 'baru', 'date': '22 Jan 2024, 08:45'},
    {'ticketId': '#TK-2024-005', 'title': 'Permintaanolar ruangan lab komputer', 'category': 'Akademik', 'status': 'diproses', 'date': '18 Jan 2024, 16:20'},
    {'ticketId': '#TK-2024-006', 'title': 'Masalah koneksi internet di asrama', 'category': 'Teknologi', 'status': 'ditangani', 'date': '17 Jan 2024, 11:00'},
  ];

  List<Map<String, dynamic>> get _filteredTickets {
    var filtered = _tickets;

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((t) =>
        t['title'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
        t['ticketId'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    // Filter by status
    if (_selectedFilter != 'semua') {
      filtered = filtered.where((t) => t['status'] == _selectedFilter).toList();
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
                style: TextStyle(fontSize: 16, color: c.textPrimary),
                onChanged: (_) => setState(() {}),
              )
            : Text(
                'Tiket Saya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.textPrimary),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search, color: c.textPrimary),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) _searchController.clear();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: c.textPrimary),
            onPressed: () {
              // Show filter modal
              _showFilterModal(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: c.surface,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
              vertical: AppConstants.spacingMd,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter['value'];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppConstants.spacingSm),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter['value']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? c.primary : c.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? c.primary : c.border),
                        ),
                        child: Text(
                          filter['name'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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

          // Ticket List
          Expanded(
            child: _filteredTickets.isEmpty
                ? _buildEmptyState(context)
                : RefreshIndicator(
                    onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      itemCount: _filteredTickets.length,
                      separatorBuilder: (context, index) => const SizedBox(height: AppConstants.spacingMd),
                      itemBuilder: (context, index) {
                        final ticket = _filteredTickets[index];
                        return _TicketListItem(
                          ticketId: ticket['ticketId'],
                          title: ticket['title'],
                          category: ticket['category'],
                          status: ticket['status'],
                          date: ticket['date'],
                          onTap: () {
                            Navigator.pushNamed(context, '/ticket-detail', arguments: ticket);
                          },
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
        padding: const EdgeInsets.all(AppConstants.spacing2xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: c.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'Belum Ada Tiket',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Tiket yang Anda buat akan muncul di sini',
              style: TextStyle(fontSize: 14, color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacing2xl),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to create ticket
              },
              icon: const Icon(Icons.add),
              label: const Text('Buat Tiket Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
              ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Tiket',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.textPrimary),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Text(
                'Status',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.textPrimary),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Wrap(
                spacing: AppConstants.spacingSm,
                runSpacing: AppConstants.spacingSm,
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter['value'];
                  return ChoiceChip(
                    label: Text(filter['name']),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter['value']);
                      Navigator.pop(context);
                    },
                    selectedColor: c.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : c.textPrimary,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppConstants.spacing2xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedFilter = 'semua');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.surface,
                    foregroundColor: c.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  child: const Text('Reset Filter'),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
            ],
          ),
        );
      },
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 3, offset: Offset(0, 1))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticketId,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: c.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Row(
                    children: [
                      CategoryBadge(category: category),
                      const SizedBox(width: AppConstants.spacingSm),
                      StatusBadge(status: status),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Icon(Icons.chevron_right, color: c.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }
}
