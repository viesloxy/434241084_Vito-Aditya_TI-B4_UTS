import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../helpdesk/widgets/helpdesk_task_card.dart';
import '../../../../../core/theme/app_palette.dart';

enum SortOption {
  tanggalTerbaru,
  tanggalTerlama,
  prioritasTinggi,
  prioritasRendah
}

/// Helpdesk task list — FlutterShop style, SVG icons, c.primary colors.
class HelpdeskTaskListPage extends StatefulWidget {
  const HelpdeskTaskListPage({super.key});

  @override
  State<HelpdeskTaskListPage> createState() => _HelpdeskTaskListPageState();
}

class _HelpdeskTaskListPageState extends State<HelpdeskTaskListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 300);

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
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((t) =>
              t['title'].toString().toLowerCase().contains(query) ||
              t['ticketId'].toString().toLowerCase().contains(query) ||
              t['description'].toString().toLowerCase().contains(query) ||
              t['createdBy'].toString().toLowerCase().contains(query))
          .toList();
    }
    if (_selectedFilter != 'semua') {
      filtered =
          filtered.where((t) => t['status'] == _selectedFilter).toList();
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
          const order = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
          return (order[a['priority']] ?? 1).compareTo(order[b['priority']] ?? 1);
        });
        break;
      case SortOption.prioritasRendah:
        filtered.sort((a, b) {
          const order = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
          return (order[b['priority']] ?? 1).compareTo(order[a['priority']] ?? 1);
        });
        break;
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildFilterChips(context),
          _buildSortBar(context),
          Expanded(
            child: _filteredTasks.isEmpty && !_isLoading
                ? _buildEmptyState(context)
                : _buildTaskList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
                hintStyle: TextStyle(color: c.textSecondary),
              ),
              style: AppTextStyles.body(c),
              onChanged: (_) => _debouncer.run(() => setState(() {})),
            )
          : Text('Daftar Tugas Saya', style: AppTextStyles.h4(c)),
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
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final c = context.palette;
    return Container(
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
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : c.textPrimary,
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

  Widget _buildSortBar(BuildContext context) {
    final c = context.palette;
    return Container(
      color: c.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Text(
            '${_filteredTasks.length} tugas',
            style: AppTextStyles.caption(c).copyWith(color: c.textSecondary),
          ),
          const Spacer(),
          TextButton(
            onPressed: _showSortDropdown,
            style: TextButton.styleFrom(
              foregroundColor: c.primary,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Sort.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
                ),
                const SizedBox(width: 4),
                Text(
                  _getSortLabel(),
                  style: AppTextStyles.bodySm(c).copyWith(color: c.primary),
                ),
              ],
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

  Widget _buildTaskList() {
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _filteredTasks.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
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
            Text('Tidak Ada Tugas', style: AppTextStyles.h4(c)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tugas yang sesuai filter akan muncul di sini',
              style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'semua';
                  _searchController.clear();
                });
              },
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
              child: const Text('Reset Filter'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortDropdown() {
    final c = context.palette;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Urutkan', style: AppTextStyles.h4(c)),
            const SizedBox(height: AppSpacing.lg),
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
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showStartTaskDialog(Map<String, dynamic> task) {
    final c = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Loading.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('Mulai Kerjakan', style: AppTextStyles.h4(c)),
          ],
        ),
        content: Text(
          'Mulai kerjakan tiket ${task['ticketId']}?\n\nStatus akan berubah menjadi "In Progress".',
          style: AppTextStyles.body(c),
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
              backgroundColor: c.primary,
              elevation: 0,
            ),
            child: const Text('Mulai'),
          ),
        ],
      ),
    );
  }

  void _showResolveTaskDialog(
      BuildContext context, Map<String, dynamic> task) {
    final c = context.palette;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Doublecheck.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(c.success, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('Selesaikan Tiket', style: AppTextStyles.h4(c)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiket: ${task['ticketId']}',
                style: AppTextStyles.body(c)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Catatan penyelesaian:', style: AppTextStyles.bodySm(c)),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Jelaskan hasil kerja Anda...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
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
              elevation: 0,
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
