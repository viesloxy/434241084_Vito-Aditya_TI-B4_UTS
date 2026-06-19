import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../helpdesk/widgets/helpdesk_task_card.dart';
import '../../../../../core/theme/app_palette.dart';
// (EmptyState & LoadingSkeleton tidak digunakan di halaman ini)
// import '../../../../admin/widgets/empty_state.dart';
// import '../../../../admin/widgets/loading_skeleton.dart';

enum SortOption { tanggalTerbaru, tanggalTerlama, prioritasTinggi, prioritasRendah }

/// Halaman daftar tugas untuk Helpdesk.
/// HANYA menampilkan tiket yang di-assign ke Helpdesk yang login.
/// Berbeda dari AdminTicketListPage yang menampilkan semua tiket.
class HelpdeskTaskListPage extends StatefulWidget {
  const HelpdeskTaskListPage({super.key});

  @override
  State<HelpdeskTaskListPage> createState() => _HelpdeskTaskListPageState();
}

class _HelpdeskTaskListPageState extends State<HelpdeskTaskListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 300);

  // Filter untuk 3 status yang Helpdesk lihat (tidak ada submitted/closed/rejected)
  String _selectedFilter = 'semua';
  bool _isLoading = false;
  bool _isSearchVisible = false;

  SortOption _sortOption = SortOption.tanggalTerbaru;

  final List<Map<String, dynamic>> _filters = [
    {'name': 'Semua', 'value': 'semua'},
    {'name': 'Ditugaskan', 'value': 'signed_assigned'},
    {'name': 'Diproses', 'value': 'in_progress'},
    {'name': 'Selesai', 'value': 'resolved'},
  ];

  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
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
        _tasks = _getMockTasks();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getMockTasks() {
    return [
      {
        'ticketId': '#TK-2024-001',
        'title': 'Permintaan reset password email kampus',
        'description': 'Tidak bisa login ke email kampus',
        'category': 'Teknologi',
        'status': 'signed_assigned',
        'priority': 'tinggi',
        'date': '5 menit yang lalu',
        'createdBy': 'Ahmad Rizki',
      },
      {
        'ticketId': '#TK-2024-003',
        'title': 'Kerusakan AC di ruang kelas L201',
        'description': 'AC tidak dingin',
        'category': 'Fasilitas',
        'status': 'in_progress',
        'priority': 'sedang',
        'date': '30 menit yang lalu',
        'createdBy': 'Dewi Lestari',
      },
      {
        'ticketId': '#TK-2024-005',
        'title': 'Permintaan akses perpustakaan digital',
        'description': 'Butuh akses e-library',
        'category': 'Akademik',
        'status': 'signed_assigned',
        'priority': 'tinggi',
        'date': '2 jam yang lalu',
        'createdBy': 'Fajar Nugroho',
      },
      {
        'ticketId': '#TK-2024-006',
        'title': 'Masalah koneksi internet di asrama',
        'description': 'Internet lambat sekali',
        'category': 'Teknologi',
        'status': 'in_progress',
        'priority': 'sedang',
        'date': '3 jam yang lalu',
        'createdBy': 'Gita Permata',
      },
      {
        'ticketId': '#TK-2024-002',
        'title': 'Jadwal ujian semester genap 2024',
        'description': 'Mohon info jadwal ujian',
        'category': 'Akademik',
        'status': 'resolved',
        'priority': 'sedang',
        'date': '1 hari yang lalu',
        'createdBy': 'Budi Santoso',
        'resolutionNote': 'Sudah diupdate di website akademik.',
      },
      {
        'ticketId': '#TK-2024-004',
        'title': 'Pembayaran UKT semester baru',
        'description': 'Konfirmasi pembayaran UKT',
        'category': 'Keuangan',
        'status': 'resolved',
        'priority': 'sedang',
        'date': '1 hari yang lalu',
        'createdBy': 'Eko Prasetyo',
        'resolutionNote': 'Sudah dikonfirmasi via WA.',
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredTasks {
    var filtered = _tasks;

    // Search filter
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

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Scaffold(
          backgroundColor: c.background,
          appBar: _buildAppBar(context, isWide),
          body: Column(
            children: [
              _buildFilterChips(context, isWide),
              _buildSortBar(context, isWide),
              Expanded(
                child: _filteredTasks.isEmpty && !_isLoading
                    ? _buildEmptyState(context)
                    : _buildTaskList(isWide),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isWide) {

    final c = context.palette;
    return AppBar(
      backgroundColor: c.surface,
      elevation: 0,
      title: _isSearchVisible
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari tugas...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: c.textSecondary,
                    fontSize: isWide ? 18 : 16),
              ),
              style: TextStyle(
                  fontSize: isWide ? 18 : 16,
                  color: c.textPrimary),
              onChanged: (_) {
                _debouncer.run(() {
                  setState(() {});
                });
              },
            )
          : Text(
              'Daftar Tugas Saya',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(_isSearchVisible ? Icons.close : Icons.search,
              color: c.textPrimary),
          onPressed: () {
            setState(() {
              _isSearchVisible = !_isSearchVisible;
              if (!_isSearchVisible) _searchController.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context, bool isWide) {

    final c = context.palette;
    return Container(
      color: c.surface,
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
                onTap: () =>
                    setState(() => _selectedFilter = filter['value'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 20 : 16,
                      vertical: isWide ? 10 : 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : c.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3B82F6)
                          : c.border,
                    ),
                  ),
                  child: Text(
                    filter['name'] as String,
                    style: TextStyle(
                      fontSize: isWide ? 14 : 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : c.textPrimary,
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

  Widget _buildSortBar(BuildContext context, bool isWide) {

    final c = context.palette;
    return Container(
      color: c.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? AppConstants.spacingXl : AppConstants.spacingLg,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          Text(
            '${_filteredTasks.length} tugas',
            style: TextStyle(
              fontSize: isWide ? 14 : 12,
              color: c.textSecondary,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _showSortDropdown,
            icon: Icon(Icons.sort,
                size: isWide ? 20 : 18, color: const Color(0xFF3B82F6)),
            label: Text(
              _getSortLabel(),
              style: TextStyle(
                  fontSize: isWide ? 14 : 12,
                  color: const Color(0xFF3B82F6)),
            ),
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

  Widget _buildTaskList(bool isWide) {
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(
            isWide ? AppConstants.spacingXl : AppConstants.spacingLg),
        itemCount: _filteredTasks.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: isWide ? AppConstants.spacingLg : AppConstants.spacingMd),
        itemBuilder: (context, index) {
          final task = _filteredTasks[index];
          return HelpdeskTaskCard(
            ticketId: task['ticketId'] as String,
            title: task['title'] as String,
            category: task['category'] as String,
            status: task['status'] as String,
            priority: task['priority'] as String,
            date: task['date'] as String,
            createdBy: task['createdBy'] as String,
            resolutionNote: task['resolutionNote'] as String?,
            onTap: () => Navigator.pushNamed(
              context,
              '/helpdesk/task-detail',
              arguments: task,
            ),
            onStart: task['status'] == 'signed_assigned'
                ? () => _showStartTaskDialog(task)
                : null,
            onResolve: task['status'] == 'in_progress'
                ? () => _showResolveTaskDialog(context, task)
                : null,
          );
        },
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
            Icon(Icons.assignment_outlined,
                size: 64,
                color: c.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: AppConstants.spacingLg),
            Text('Tidak Ada Tugas',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary)),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Tugas yang sesuai filter akan muncul di sini',
              style: TextStyle(fontSize: 14, color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacing2xl),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'semua';
                  _searchController.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium)),
              ),
              child: const Text('Reset Filter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortDropdown() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Urutkan',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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

  void _showStartTaskDialog(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        title: const Row(
          children: [
            Icon(Icons.play_arrow, color: Color(0xFF3B82F6)),
            SizedBox(width: 8),
            Text('Mulai Kerjakan'),
          ],
        ),
        content: Text(
          'Mulai kerjakan tiket ${task['ticketId']}?\n\nStatus akan berubah menjadi "In Progress".',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mulai kerjakan ${task['ticketId']}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _loadInitialData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }

  void _showResolveTaskDialog(BuildContext context, Map<String, dynamic> task) {

    final c = context.palette;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: c.success),
            SizedBox(width: 8),
            Text('Selesaikan Tiket'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tiket: ${task['ticketId']}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('Catatan penyelesaian:',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Jelaskan hasil kerja Anda...',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.trim().length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Catatan minimal 10 karakter'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tiket ${task['ticketId']} selesai'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _loadInitialData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: c.success,
            ),
            child: const Text('Selesaikan'),
          ),
        ],
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
