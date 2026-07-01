import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/models/ticket.dart';
import '../../../../../core/services/ticket_service.dart';
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
  final _ticketService = TicketService();
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

  List<Ticket> _tasks = [];

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
    try {
      final tasks = await _ticketService.getAssignedToMe();
      if (!mounted) return;
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  List<Ticket> get _filteredTasks {
    var filtered = List<Ticket>.from(_tasks);
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((t) =>
              t.title.toLowerCase().contains(query) ||
              t.ticketNumber.toLowerCase().contains(query) ||
              (t.creatorName ?? '').toLowerCase().contains(query))
          .toList();
    }
    if (_selectedFilter != 'semua') {
      filtered = filtered
          .where((t) => t.status.value == _selectedFilter)
          .toList();
    }
    switch (_sortOption) {
      case SortOption.tanggalTerbaru:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.tanggalTerlama:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.prioritasTinggi:
        const order = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
        filtered.sort((a, b) =>
            (order[a.priority.value] ?? 1).compareTo(order[b.priority.value] ?? 1));
        break;
      case SortOption.prioritasRendah:
        const order = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
        filtered.sort((a, b) =>
            (order[b.priority.value] ?? 1).compareTo(order[a.priority.value] ?? 1));
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
            ticketId: task.ticketNumber,
            title: task.title,
            category: task.categoryName ?? '',
            status: task.status.value,
            priority: task.priority.value,
            date: _timeAgo(task.createdAt),
            createdBy: task.creatorName ?? '',
            onTap: () => Navigator.pushNamed(
              context,
              '/helpdesk/task-detail',
              arguments: {'id': task.id},
            ),
            onStart: task.status == TicketStatus.signedAssigned
                ? () => _showStartTaskDialog(task)
                : null,
            onResolve: task.status == TicketStatus.inProgress
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

  void _showStartTaskDialog(Ticket task) {
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
          'Mulai kerjakan tiket ${task.ticketNumber}?\n\nStatus akan berubah menjadi "In Progress".',
          style: AppTextStyles.body(c),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _ticketService.startTicket(task.id);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mulai kerjakan ${task.ticketNumber}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _loadInitialData();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal: $e'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
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

  void _showResolveTaskDialog(BuildContext context, Ticket task) {
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
                'Tiket: ${task.ticketNumber}',
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
            onPressed: () async {
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
              try {
                await _ticketService.resolveTicket(task.id);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tiket ${task.ticketNumber} selesai'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                _loadInitialData();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal: $e'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
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
