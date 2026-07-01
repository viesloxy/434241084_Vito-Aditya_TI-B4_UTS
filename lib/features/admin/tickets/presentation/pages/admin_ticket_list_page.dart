import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/models/ticket.dart';
import '../../../../../core/services/ticket_service.dart';
import '../../../widgets/admin_ticket_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../../../core/theme/app_palette.dart';

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
  final _ticketService = TicketService();

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

  List<Ticket> _tickets = [];
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
    try {
      final status = _selectedFilter != 'semua'
          ? TicketStatus.values.firstWhere(
              (s) => s.value == _selectedFilter,
              orElse: () => TicketStatus.submitted,
            )
          : null;
      final tickets = await _ticketService.getTickets(
        status: status,
        limit: _pageSize,
        offset: 0,
      );
      if (!mounted) return;
      setState(() {
        _tickets = tickets;
        _currentPage = 0;
        _hasMore = tickets.length >= _pageSize;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);
    try {
      final nextPage = _currentPage + 1;
      final status = _selectedFilter != 'semua'
          ? TicketStatus.values.firstWhere(
              (s) => s.value == _selectedFilter,
              orElse: () => TicketStatus.submitted,
            )
          : null;
      final newTickets = await _ticketService.getTickets(
        status: status,
        limit: _pageSize,
        offset: nextPage * _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _tickets.addAll(newTickets);
        _currentPage = nextPage;
        _hasMore = newTickets.length >= _pageSize;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }

  List<Ticket> get _filteredTickets {
    var filtered = _tickets;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(query) ||
        t.ticketNumber.toLowerCase().contains(query) ||
        t.description.toLowerCase().contains(query) ||
        (t.creatorName?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    filtered = List.from(filtered);
    switch (_sortOption) {
      case SortOption.tanggalTerbaru:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.tanggalTerlama:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.prioritasTinggi:
        filtered.sort((a, b) {
          const order = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
          return (order[a.priority.value] ?? 1)
              .compareTo(order[b.priority.value] ?? 1);
        });
        break;
      case SortOption.prioritasRendah:
        filtered.sort((a, b) {
          const order = {'tinggi': 0, 'sedang': 1, 'rendah': 2};
          return (order[b.priority.value] ?? 1)
              .compareTo(order[a.priority.value] ?? 1);
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

  void _showBulkActionSheet(BuildContext context) {

    final c = context.palette;
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
              leading: SvgPicture.asset('assets/icons/Doublecheck.svg',
                  width: 24, height: 24,
                  colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn)),
              title: const Text('Pilih Semua'),
              onTap: () {
                Navigator.pop(ctx);
                _selectAll();
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/icons/Man&Woman.svg',
                  width: 24, height: 24,
                  colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn)),
              title: const Text('Assign ke Helpdesk'),
              onTap: () {
                Navigator.pop(ctx);
                _showAssignDialog(context);
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/icons/Delete.svg',
                  width: 24, height: 24,
                  colorFilter: ColorFilter.mode(c.error, BlendMode.srcIn)),
              title: const Text('Hapus Terpilih'),
              onTap: () {
                Navigator.pop(ctx);
                _deleteSelected(context);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _showAssignDialog(BuildContext context) {

    final c = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Assign ke Helpdesk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: SvgPicture.asset('assets/icons/Profile.svg',
                  width: 24, height: 24,
                  colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn)),
              title: const Text('John Helpdesk'),
              subtitle: const Text('5 tiket aktif'),
              onTap: () {
                Navigator.pop(ctx);
                _snack('Tiket ditugaskan ke John Helpdesk');
                _toggleSelectionMode();
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/icons/Profile.svg',
                  width: 24, height: 24,
                  colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn)),
              title: const Text('Sarah Helpdesk'),
              subtitle: const Text('3 tiket aktif'),
              onTap: () {
                Navigator.pop(ctx);
                _snack('Tiket ditugaskan ke Sarah Helpdesk');
                _toggleSelectionMode();
              },
            ),
            ListTile(
              leading: SvgPicture.asset('assets/icons/Profile.svg',
                  width: 24, height: 24,
                  colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn)),
              title: Text('Budi Helpdesk'),
              subtitle: Text('0 tiket aktif (Cuti)'),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  void _deleteSelected(BuildContext context) {

    final c = context.palette;
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
            style: TextButton.styleFrom(foregroundColor: c.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showSortDropdown(BuildContext context) {
    final c = context.palette;
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
            Text('Urutkan', style: AppTextStyles.h3(c)),
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
                child: _filteredTickets.isEmpty && !_isLoading
                    ? _buildEmptyState()
                    : _buildTicketList(isWide),
              ),
            ],
          ),
          bottomNavigationBar: _isSelectionMode ? _buildSelectionBar(context) : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isWide) {

    final c = context.palette;
    if (_isSelectionMode) {
      return AppBar(
        backgroundColor: c.primary,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Close.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          onPressed: _toggleSelectionMode,
        ),
        title: Text(
          '${_selectedTickets.length} dipilih',
          style: const TextStyle(color: Colors.white, fontFamily: 'Plus Jakarta'),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/DotsV.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            onPressed: () => _showBulkActionSheet(context),
          ),
        ],
      );
    }

    return AppBar(
      backgroundColor: c.surface,
      elevation: 0,
      title: _isSearchVisible
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari tiket...',
                border: InputBorder.none,
                hintStyle: AppTextStyles.body(c).copyWith(color: c.textSecondary),
              ),
              style: AppTextStyles.body(c).copyWith(color: c.textPrimary),
              onChanged: (_) => _debouncer.run(() => setState(() {})),
            )
          : Text('Daftar Tiket', style: AppTextStyles.h4(c)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            _isSearchVisible
                ? 'assets/icons/Close.svg'
                : 'assets/icons/Search.svg',
            width: 24,
            height: 24,
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
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
          ),
          onPressed: () => _showFilterModal(context),
        ),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context, bool isWide) {

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
                onTap: () {
                  setState(() => _selectedFilter = filter['value'] as String);
                  _loadInitialData();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 20 : 16,
                    vertical: isWide ? 10 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? c.primary : c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: isSelected ? c.primary : c.border,
                    ),
                  ),
                  child: Text(
                    filter['name'] as String,
                    style: AppTextStyles.body(c).copyWith(
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
    );
  }

  Widget _buildSortBar(BuildContext context, bool isWide) {

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
            '${_filteredTickets.length} tiket',
            style: AppTextStyles.caption(c).copyWith(color: c.textSecondary),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showSortDropdown(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/Sort.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(c.primary, BlendMode.srcIn),
                ),
                const SizedBox(width: 4),
                Text(
                  _sortLabel(_sortOption).split('(').first.trim(),
                  style: AppTextStyles.caption(c).copyWith(color: c.primary),
                ),
              ],
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
            ticketId: ticket.ticketNumber,
            title: ticket.title,
            category: ticket.categoryName ?? '',
            status: ticket.status.value,
            priority: ticket.priority.value,
            date: _timeAgo(ticket.createdAt),
            assignedTo: ticket.assigneeName,
            isSelected: _selectedTickets.contains(index),
            onTap: () {
              if (_isSelectionMode) {
                _toggleTicketSelection(index);
              } else {
                Navigator.pushNamed(
                  context,
                  '/admin/ticket-detail',
                  arguments: {'id': ticket.id},
                );
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
      svgAsset: 'assets/icons/Order.svg',
      onRefresh: () {
        setState(() {
          _selectedFilter = 'semua';
          _searchController.clear();
        });
      },
    );
  }

  Widget _buildSelectionBar(BuildContext context) {
    final c = context.palette;
    return Container(
      color: c.surface,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSelectionButton(context, 'assets/icons/Doublecheck.svg', 'Pilih Semua', _selectAll),
            _buildSelectionButton(context, 'assets/icons/Man&Woman.svg', 'Assign Helpdesk', () => _showAssignDialog(context)),
            _buildSelectionButton(context, 'assets/icons/Delete.svg', 'Hapus', () => _deleteSelected(context), iconColor: c.error),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(BuildContext context, String svgAsset, String label, VoidCallback onTap, {Color? iconColor}) {
    final c = context.palette;
    final color = iconColor ?? c.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption(c).copyWith(color: color),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Tiket', style: AppTextStyles.h3(c)),
            const SizedBox(height: AppSpacing.lg),
            Text('Status', style: AppTextStyles.label(c)),
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
                    _loadInitialData();
                  },
                  selectedColor: c.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : c.textPrimary,
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
