import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../widgets/admin_ticket_card.dart';
import '../../../widgets/empty_state.dart';

enum SortOption { tanggalTerbaru, tanggalTerlama, prioritasTinggi, prioritasRendah }

/// Admin Ticket List ala FlutterShop — search + filter chips + sort bar + list.
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 8.
class AdminTicketListPage extends StatefulWidget {
  const AdminTicketListPage({super.key});

  @override
  State<AdminTicketListPage> createState() => _AdminTicketListPageState();
}

class _AdminTicketListPageState extends State<AdminTicketListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 300);

  String _selectedFilter = 'semua';
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isSearchVisible = false;
  bool _isSelectionMode = false;

  SortOption _sortOption = SortOption.tanggalTerbaru;
  final Set<int> _selectedTickets = {};

  final List<Map<String, dynamic>> _filters = [
    {'name': 'Semua', 'value': 'semua'},
    {'name': 'Submitted', 'value': 'submitted'},
    {'name': 'Ditugaskan', 'value': 'signed_assigned'},
    {'name': 'In Progress', 'value': 'in_progress'},
    {'name': 'Resolved', 'value': 'resolved'},
    {'name': 'Closed', 'value': 'closed'},
    {'name': 'Ditolak', 'value': 'rejected'},
  ];

  List<Map<String, dynamic>> _tickets = [];
  int _currentPage = 0;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _tickets = _getMockTickets(page: 0, pageSize: _pageSize);
        _currentPage = 0;
        _hasMore = _tickets.length >= _pageSize;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      final newTickets = _getMockTickets(page: _currentPage + 1, pageSize: _pageSize);
      setState(() {
        _tickets.addAll(newTickets);
        _currentPage++;
        _hasMore = newTickets.length >= _pageSize;
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  List<Map<String, dynamic>> _getMockTickets({required int page, required int pageSize}) {
    final allTickets = [
      {'ticketId': '#TK-2024-001', 'title': 'Permintaan reset password email kampus', 'description': 'Tidak bisa login ke email kampus', 'category': 'Teknologi', 'status': 'submitted', 'priority': 'tinggi', 'date': '5 menit yang lalu', 'assignedTo': null, 'createdBy': 'Ahmad Rizki'},
      {'ticketId': '#TK-2024-002', 'title': 'Jadwal ujian semester genap 2024', 'description': 'Mohon info jadwal ujian', 'category': 'Akademik', 'status': 'signed_assigned', 'priority': 'sedang', 'date': '15 menit yang lalu', 'assignedTo': 'John Helpdesk', 'createdBy': 'Budi Santoso'},
      {'ticketId': '#TK-2024-003', 'title': 'Kerusakan AC di ruang kelas L201', 'description': 'AC tidak dingin', 'category': 'Fasilitas', 'status': 'in_progress', 'priority': 'rendah', 'date': '30 menit yang lalu', 'assignedTo': 'Sarah Helpdesk', 'createdBy': 'Dewi Lestari'},
      {'ticketId': '#TK-2024-004', 'title': 'Pembayaran UKT semester baru', 'description': 'Konfirmasi pembayaran UKT', 'category': 'Keuangan', 'status': 'resolved', 'priority': 'sedang', 'date': '1 jam yang lalu', 'assignedTo': 'Budi Helpdesk', 'createdBy': 'Eko Prasetyo'},
      {'ticketId': '#TK-2024-005', 'title': 'Peminjaman ruangan lab komputer', 'description': 'Butuh lab untuk praktikum', 'category': 'Akademik', 'status': 'in_progress', 'priority': 'tinggi', 'date': '2 jam yang lalu', 'assignedTo': 'John Helpdesk', 'createdBy': 'Fajar Nugroho'},
      {'ticketId': '#TK-2024-006', 'title': 'Masalah koneksi internet di asrama', 'description': 'Internet lambat sekali', 'category': 'Teknologi', 'status': 'signed_assigned', 'priority': 'sedang', 'date': '3 jam yang lalu', 'assignedTo': 'John Helpdesk', 'createdBy': 'Gita Permata'},
      {'ticketId': '#TK-2024-007', 'title': 'Permintaan ATK untuk mengajar', 'description': 'Butuh spidol dan kapur', 'category': 'Fasilitas', 'status': 'in_progress', 'priority': 'rendah', 'date': '4 jam yang lalu', 'assignedTo': 'Sarah Helpdesk', 'createdBy': 'Hendra Wijaya'},
      {'ticketId': '#TK-2024-008', 'title': 'Konfirmasi biaya semester tambahan', 'description': 'Biaya tambahan semester 5', 'category': 'Keuangan', 'status': 'signed_assigned', 'priority': 'sedang', 'date': '5 jam yang lalu', 'assignedTo': 'Budi Helpdesk', 'createdBy': 'Indah Sari'},
      {'ticketId': '#TK-2024-009', 'title': 'Jadwal kuliah pengganti', 'description': 'Kuliah pengganti matkul Basis Data', 'category': 'Akademik', 'status': 'closed', 'priority': 'rendah', 'date': '6 jam yang lalu', 'assignedTo': 'John Helpdesk', 'createdBy': 'Joko Widodo'},
      {'ticketId': '#TK-2024-010', 'title': 'Perbaikan proyektor ruang 301', 'description': 'Proyektor mati total', 'category': 'Teknologi', 'status': 'rejected', 'priority': 'sedang', 'date': '7 jam yang lalu', 'assignedTo': null, 'createdBy': 'Karla Suci'},
    ];
    final start = page * pageSize;
    final end = start + pageSize;
    if (start >= allTickets.length) return [];
    return allTickets.sublist(start, end > allTickets.length ? allTickets.length : end);
  }

  List<Map<String, dynamic>> get _filteredTickets {
    var filtered = _tickets;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((t) =>
        t['title'].toString().toLowerCase().contains(query) ||
        t['ticketId'].toString().toLowerCase().contains(query) ||
        t['description'].toString().toLowerCase().contains(query) ||
        t['createdBy'].toString().toLowerCase().contains(query)
      ).toList();
    }

    if (_selectedFilter != 'semua') {
      filtered = filtered.where((t) => t['status'] == _selectedFilter).toList();
    }

    filtered = List.from(filtered);
    switch (_sortOption) {
      case SortOption.tanggalTerbaru:
        break;
      case SortOption.tanggalTerlama:
        filtered = filtered.reversed.toList();
        break;
      case SortOption.prioritasTinggi:
        filtered.sort((a, b) {
          final priorityOrder = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
          return (priorityOrder[a['priority']] ?? 1)
              .compareTo(priorityOrder[b['priority']] ?? 1);
        });
        break;
      case SortOption.prioritasRendah:
        filtered.sort((a, b) {
          final priorityOrder = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
          return (priorityOrder[b['priority']] ?? 1)
              .compareTo(priorityOrder[a['priority']] ?? 1);
        });
        break;
    }
    return filtered;
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) _selectedTickets.clear();
    });
  }

  void _toggleTicketSelection(int index) {
    setState(() {
      if (_selectedTickets.contains(index)) {
        _selectedTickets.remove(index);
      } else {
        _selectedTickets.add(index);
      }
    });
  }

  void _selectAll() {
    setState(() {
      for (int i = 0; i < _filteredTickets.length; i++) {
        _selectedTickets.add(i);
      }
    });
  }

  void _showBulkActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.select_all, color: AppColors.primary),
              title: const Text('Pilih Semua'),
              onTap: () {
                Navigator.pop(ctx);
                _selectAll();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: AppColors.primary),
              title: const Text('Assign ke Helpdesk'),
              onTap: () {
                Navigator.pop(ctx);
                _showAssignDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Hapus Terpilih'),
              onTap: () {
                Navigator.pop(ctx);
                _deleteSelected();
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showAssignDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Assign ke Helpdesk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text('John Helpdesk'),
              subtitle: const Text('5 tiket aktif'),
              onTap: () {
                Navigator.pop(ctx);
                _snack('Tiket ditugaskan ke John Helpdesk');
                _toggleSelectionMode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text('Sarah Helpdesk'),
              subtitle: const Text('3 tiket aktif'),
              onTap: () {
                Navigator.pop(ctx);
                _snack('Tiket ditugaskan ke Sarah Helpdesk');
                _toggleSelectionMode();
              },
            ),
            const ListTile(
              leading: Icon(Icons.person, color: AppColors.textTertiary),
              title: Text('Budi Helpdesk'),
              subtitle: Text('0 tiket aktif (Cuti)'),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tiket'),
        content: Text('Hapus ${_selectedTickets.length} tiket yang dipilih?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _snack('${_selectedTickets.length} tiket dihapus');
              _toggleSelectionMode();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showSortDropdown() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Urutkan', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),
            for (final opt in SortOption.values)
              RadioListTile<SortOption>(
                title: Text(_sortLabel(opt)),
                value: opt,
                groupValue: _sortOption,
                onChanged: (value) {
                  setState(() => _sortOption = value!);
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  String _sortLabel(SortOption opt) {
    switch (opt) {
      case SortOption.tanggalTerbaru:
        return 'Tanggal (Terbaru)';
      case SortOption.tanggalTerlama:
        return 'Tanggal (Terlama)';
      case SortOption.prioritasTinggi:
        return 'Prioritas (Tertinggi)';
      case SortOption.prioritasRendah:
        return 'Prioritas (Terendah)';
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(isWide),
          body: Column(
            children: [
              _buildFilterChips(isWide),
              _buildSortBar(isWide),
              Expanded(
                child: _filteredTickets.isEmpty && !_isLoading
                    ? _buildEmptyState()
                    : _buildTicketList(isWide),
              ),
            ],
          ),
          bottomNavigationBar: _isSelectionMode ? _buildSelectionBar() : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(bool isWide) {
    if (_isSelectionMode) {
      return AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _toggleSelectionMode,
        ),
        title: Text(
          '${_selectedTickets.length} dipilih',
          style: const TextStyle(color: Colors.white, fontFamily: 'Plus Jakarta'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showBulkActionSheet,
          ),
        ],
      );
    }

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: _isSearchVisible
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari tiket...',
                border: InputBorder.none,
                hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              onChanged: (_) => _debouncer.run(() => setState(() {})),
            )
          : Text('Daftar Tiket', style: AppTextStyles.h4),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isSearchVisible ? Icons.close : Icons.search,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            setState(() {
              _isSearchVisible = !_isSearchVisible;
              if (!_isSearchVisible) _searchController.clear();
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
          onPressed: () => _showFilterModal(context),
        ),
      ],
    );
  }

  Widget _buildFilterChips(bool isWide) {
    return Container(
      color: AppColors.surface,
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
                onTap: () => setState(() => _selectedFilter = filter['value'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 20 : 16,
                    vertical: isWide ? 10 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    filter['name'] as String,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSortBar(bool isWide) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Text(
            '${_filteredTickets.length} tiket',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _showSortDropdown,
            icon: const Icon(Icons.sort, size: 18, color: AppColors.primary),
            label: Text(
              _sortLabel(_sortOption).split('(').first.trim(),
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList(bool isWide) {
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _filteredTickets.length + (_hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          if (index >= _filteredTickets.length) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: _isLoading ? const CircularProgressIndicator() : const SizedBox(),
              ),
            );
          }
          final ticket = _filteredTickets[index];
          return AdminTicketCard(
            ticketId: ticket['ticketId'] as String,
            title: ticket['title'] as String,
            category: ticket['category'] as String,
            status: ticket['status'] as String,
            priority: ticket['priority'] as String,
            date: ticket['date'] as String,
            assignedTo: ticket['assignedTo'] != null ? ticket['assignedTo'] as String : null,
            isSelected: _selectedTickets.contains(index),
            onTap: () {
              if (_isSelectionMode) {
                _toggleTicketSelection(index);
              } else {
                Navigator.pushNamed(context, '/admin/ticket-detail', arguments: ticket);
              }
            },
            onLongPress: () {
              if (!_isSelectionMode) {
                _toggleSelectionMode();
                _toggleTicketSelection(index);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      title: 'Tidak Ada Tiket',
      message: 'Tiket yang sesuai filter akan muncul di sini',
      icon: Icons.description_outlined,
      onRefresh: () {
        setState(() {
          _selectedFilter = 'semua';
          _searchController.clear();
        });
      },
    );
  }

  Widget _buildSelectionBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSelectionButton(Icons.select_all, 'Pilih Semua', _selectAll),
            _buildSelectionButton(Icons.person_add, 'Assign Helpdesk', _showAssignDialog),
            _buildSelectionButton(Icons.delete, 'Hapus', _deleteSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Tiket', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),
            Text('Status', style: AppTextStyles.label),
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
                    Navigator.pop(ctx);
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontFamily: 'Plus Jakarta',
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
                  Navigator.pop(ctx);
                },
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

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
