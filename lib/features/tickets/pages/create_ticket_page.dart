import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/theme/app_palette.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedPriority;
  bool _isLoading = false;

  static const _categories = [
    {'name': 'Akademik', 'svgAsset': 'assets/icons/Order.svg', 'value': 'akademik'},
    {'name': 'Teknologi', 'svgAsset': 'assets/icons/Setting.svg', 'value': 'teknologi'},
    {'name': 'Fasilitas', 'svgAsset': 'assets/icons/Stores.svg', 'value': 'fasilitas'},
    {'name': 'Keuangan', 'svgAsset': 'assets/icons/Cash.svg', 'value': 'keuangan'},
    {'name': 'Lainnya', 'svgAsset': 'assets/icons/Category.svg', 'value': 'lainnya'},
  ];

  final List<Map<String, dynamic>> _priorities = [
    {'name': 'Rendah', 'value': 'rendah', 'color': const Color(0xFF10B981)},
    {'name': 'Sedang', 'value': 'sedang', 'color': const Color(0xFFF59E0B)},
    {'name': 'Tinggi', 'value': 'tinggi', 'color': const Color(0xFFEF4444)},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) return 'Judul tidak boleh kosong';
    if (value.length < 10) return 'Judul minimal 10 karakter';
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) return 'Deskripsi tidak boleh kosong';
    if (value.length < 20) return 'Deskripsi minimal 20 karakter';
    return null;
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final c = context.palette;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih kategori tiket'),
          backgroundColor: c.error,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          margin: const EdgeInsets.all(AppSpacing.lg),
        ),
      );
      return;
    }

    if (_selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih tingkat prioritas'),
          backgroundColor: c.error,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          margin: const EdgeInsets.all(AppSpacing.lg),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Doublecheck.svg',
                  width: 16,
                  height: 16,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text('Tiket berhasil dibuat!'),
              ],
            ),
            backgroundColor: c.success,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            ),
            margin: const EdgeInsets.all(AppSpacing.lg),
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context);
        });
      }
    }
  }

  void _handleClose(BuildContext context) {
    final c = context.palette;
    final hasData = _titleController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _selectedCategory != null ||
        _selectedPriority != null;

    if (hasData) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          ),
          title: Text('Batalkan Tiket?', style: AppTextStyles.h4(c)),
          content: Text('Data yang sudah diisi akan hilang.',
              style: AppTextStyles.body(c)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tetap di Halaman'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: c.error),
              child: const Text('Batalkan'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Close.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(c.textPrimary, BlendMode.srcIn),
          ),
          onPressed: () => _handleClose(context),
        ),
        title: Text('Buat Tiket Baru', style: AppTextStyles.h4(c)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Kategori ──────────────────────────────────────
                      Text(
                        'Kategori *',
                        style: AppTextStyles.body(c)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _categories.map((cat) {
                          final isSelected =
                              _selectedCategory == cat['value'];
                          return GestureDetector(
                            onTap: () => setState(
                                () => _selectedCategory = cat['value']),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: isSelected ? c.primaryLight : c.surface,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color:
                                      isSelected ? c.primary : c.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    cat['svgAsset'] as String,
                                    width: 16,
                                    height: 16,
                                    colorFilter: ColorFilter.mode(
                                      isSelected
                                          ? c.primary
                                          : c.textSecondary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat['name'] as String,
                                    style: AppTextStyles.bodySm(c).copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? c.primary
                                          : c.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      // ── Judul Field ───────────────────────────────────
                      CustomTextField(
                        controller: _titleController,
                        hintText: 'Ringkasan masalah Anda',
                        labelText: 'Judul *',
                        prefixIcon: const AppFieldPrefix(
                            svgAsset: 'assets/icons/Edit Square.svg'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: _validateTitle,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // ── Deskripsi Field ───────────────────────────────
                      CustomTextField(
                        controller: _descriptionController,
                        hintText: 'Jelaskan masalah Anda secara detail...',
                        labelText: 'Deskripsi *',
                        maxLines: 5,
                        validator: _validateDescription,
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      // ── Prioritas ─────────────────────────────────────
                      Text(
                        'Prioritas *',
                        style: AppTextStyles.body(c)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: _priorities.map((pri) {
                          final isSelected =
                              _selectedPriority == pri['value'];
                          final isLast = pri['value'] == 'tinggi';
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _selectedPriority =
                                      pri['value'] as String),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(
                                    right: isLast ? 0 : AppSpacing.sm),
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (pri['color'] as Color)
                                          .withValues(alpha: 0.15)
                                      : c.surface,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.sm),
                                  border: Border.all(
                                    color: isSelected
                                        ? pri['color'] as Color
                                        : c.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    pri['name'] as String,
                                    style: AppTextStyles.body(c).copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? pri['color'] as Color
                                          : c.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      // ── Lampiran ──────────────────────────────────────
                      Text(
                        'Lampiran (Opsional)',
                        style: AppTextStyles.body(c)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Fitur lampiran akan segera hadir'),
                              behavior: SnackBarBehavior.floating,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppRadius.md)),
                              ),
                              margin: const EdgeInsets.all(AppSpacing.lg),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.xxl),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: c.border, width: 1),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Camera-add.svg',
                                width: 40,
                                height: 40,
                                colorFilter: ColorFilter.mode(
                                    c.textSecondary, BlendMode.srcIn),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Tambah File',
                                style: AppTextStyles.body(c)
                                    .copyWith(color: c.primary),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Maksimal 5MB per file',
                                style: AppTextStyles.caption(c)
                                    .copyWith(color: c.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Submit Button ──────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: c.surface,
                  border: Border(top: BorderSide(color: c.divider, width: 1)),
                ),
                child: CustomButton(
                  text: 'Kirim Tiket',
                  onPressed: () => _handleSubmit(context),
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
