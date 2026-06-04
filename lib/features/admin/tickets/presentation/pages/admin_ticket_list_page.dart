import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../widgets/admin_ticket_card.dart';

enum SortOption { tanggalTerbaru, tanggalTerlama, prioritasTinggi, prioritasRendah }

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

  // Filter sesuai workflow 3 role (5 status + ditolak)
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  List<Map<String, dynamic>> _getMockTickets({required int page, required int pageSize}) {
    // Mock data dengan status sesuai workflow 3 role
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

    // Search filter (with debounce in UI, instant in logic)
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((t) =>
        t['title'].toString().toLowerCase().contains(query) ||
        t['ticketId'].toString().toLowerCase().contains(query) ||
        t['description'].toString().toLowerCase().contains(query) ||
        t['createdBy'].toString().toLowerCase().contains(query)
      ).toList();
    }

    // Status filter
    if (_selectedFilter != 'semua') {
      filtered = filtered.where((t) => t['status'] == _selectedFilter).toList();
    }

    // Sort
    filtered = List.from(filtered);
    switch (_sortOption) {
      case SortOption.tanggalTerbaru:
        // Already in order
        break;
      case SortOption.tanggalTerlama:
        filtered = filtered.reversed.toList();
        break;
      case SortOption.prioritasTinggi:
        filtered.sort((a, b) {
          final priorityOrder = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
          return (priorityOrder[a['priority']] ?? 1).compareTo(priorityOrder[b['priority']] ?? 1);
        });
        break;
      case SortOption.prioritasRendah:
        filtered.sort((a, b) {
          final priorityOrder = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
          return (priorityOrder[b['priority']] ?? 1).compareTo(priorityOrder[a['priority']] ?? 1);
        });
        break;
    }

    return filtered;
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedTickets.clear();
      }
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
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
            // Catatan: Bulk action "Tandai Selesai" sudah dihapus karena
            // setelah revisi 3 role, Admin TIDAK bisa langsung menandai
            // tiket selesai. Itu adalah tugas Helpdesk.
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Hapus Terpilih'),
              onTap: () {
                Navigator.pop(ctx);
                _deleteSelected();
              },
            ),
            const SizedBox(height: AppConstants.spacingLg),
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
              leading: const Icon(Icons.person, color: Color(0xFF3B82F6)),
              title: const Text('John Helpdesk'),
              subtitle: const Text('5 tiket aktif'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tiket ditugaskan ke John Helpdesk')),
                );
                _toggleSelectionMode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF3B82F6)),
              title: const Text('Sarah Helpdesk'),
              subtitle: const Text('3 tiket aktif'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tiket ditugaskan ke Sarah Helpdesk')),
                );
                _toggleSelectionMode();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF3B82F6)),
              title: const Text('Budi Helpdesk'),
              subtitle: const Text('0 tiket aktif (Cuti)'),
              enabled: false,
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }

  // Method ini sudah tidak relevan karena Admin tidak bisa
  // "Tandai Selesai" tiket secara langsung. Itu tugas Helpdesk.
  // void _markSelectedAsDone() { ... }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tiket'),
        content: Text('Hapus ${_selectedTickets.length} tiket yang dipilih?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${_selectedTickets.length} tiket dihapus')),
              );
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Urutkan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppConstants.spacingLg),
            RadioListTile<SortOption>(
              title: const Text('Tanggal (Terbaru)'),
              value: SortOption.tanggalTerbaru,
              groupValue: _sortOption,
              onChanged: (value) {
                setState(() => _sortOption = value!);
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<SortOption>(
              title: const Text('Tanggal (Terlama)'),
              value: SortOption.tanggalTerlama,
              groupValue: _sortOption,
              onChanged: (value) {
                setState(() => _sortOption = value!);
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<SortOption>(
              title: const Text('Prioritas (Tertinggi)'),
              value: SortOption.prioritasTinggi,
              groupValue: _sortOption,
              onChanged: (value) {
                setState(() => _sortOption = value!);
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<SortOption>(
              title: const Text('Prioritas (Terendah)'),
              value: SortOption.prioritasRendah,
              groupValue: _sortOption,
              onChanged: (value) {
                setState(() => _sortOption = value!);
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: AppConstants.spacingLg),
          ],
        ),
      ),
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
        title: Text('${_selectedTickets.length} dipilih', style: const TextStyle(color: Colors.white)),
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
                hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: isWide ? 18 : 16),
              ),
              style: TextStyle(fontSize: isWide ? 18 : 16, color: AppColors.textPrimary),
              onChanged: (_) {
                _debouncer.run(() {
                  setState(() {});
                });
              },
            )
          : Text(
              'Daftar Tiket',
              style: TextStyle(fontSize: isWide ? 20 : 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(_isSearchVisible ? Icons.close : Icons.search, color: AppColors.textPrimary),
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
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? AppConstants.spacingXl : AppConstants.spacingLg,
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
                onTap: () => setState(() => _selectedFilter = filter['value'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 16, vertical: isWide ? 10 : 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                  ),
                  child: Text(
                    filter['name'] as String,
                    style: TextStyle(
                      fontSize: isWide ? 14 : 13,
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
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? AppConstants.spacingXl : AppConstants.spacingLg,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          Text(
            '${_filteredTickets.length} tiket',
            style: TextStyle(
              fontSize: isWide ? 14 : 12,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _showSortDropdown,
            icon: Icon(Icons.sort, size: isWide ? 20 : 18, color: AppColors.primary),
            label: Text(
              _getSortLabel(),
              style: TextStyle(fontSize: isWide ? 14 : 12, color: AppColors.primary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.list, color: AppColors.textSecondary),
            onPressed: () {},
            tooltip: 'Tampilan daftar',
          ),
        ],
      ),
    );
  }

  String _getSortLabel() {
    switch (_sortOption) {
      case SortOption.tanggalTerbaru:
        return 'Terbaru';
      case SortOption.tanggalTerlama:
        return 'Terlama';
      case SortOption.prioritasTinggi:
        return 'Prioritas Tinggi';
      case SortOption.prioritasRendah:
        return 'Prioritas Rendah';
    }
  }

  Widget _buildTicketList(bool isWide) {
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
        itemCount: _filteredTickets.length + (_hasMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
        itemBuilder: (context, index) {
          if (index >= _filteredTickets.length) {
            return Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Center(child: _isLoading ? const CircularProgressIndicator() : const SizedBox()),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacing2xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: AppConstants.spacingLg),
            const Text('Tidak Ada Tiket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: AppConstants.spacingSm),
            const Text('Tiket yang sesuai filter akan muncul di sini', style: TextStyle(fontSize: 14, color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: AppConstants.spacing2xl),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'semua';
                  _searchController.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
              ),
              child: const Text('Reset Filter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionBar() {
    // Tombol "Selesai" dihapus karena Admin tidak bisa tandai selesai
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
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
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter Tiket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: AppConstants.spacingLg),
            const Text('Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            const SizedBox(height: AppConstants.spacingMd),
            Wrap(
              spacing: AppConstants.spacingSm,
              runSpacing: AppConstants.spacingSm,
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
                  labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.spacing2xl),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _selectedFilter = 'semua');
                  Navigator.pop(ctx);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
                ),
                child: const Text('Reset Filter'),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
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
