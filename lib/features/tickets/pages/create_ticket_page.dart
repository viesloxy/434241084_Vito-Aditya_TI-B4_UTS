import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_button.dart';

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

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Akademik', 'icon': Icons.menu_book_outlined, 'value': 'akademik'},
    {'name': 'Teknologi', 'icon': Icons.laptop_mac, 'value': 'teknologi'},
    {'name': 'Fasilitas', 'icon': Icons.business_outlined, 'value': 'fasilitas'},
    {'name': 'Keuangan', 'icon': Icons.credit_card_outlined, 'value': 'keuangan'},
    {'name': 'Lainnya', 'icon': Icons.more_horiz, 'value': 'lainnya'},
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

  Future<void> _handleSubmit() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih kategori tiket'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
        ),
      );
      return;
    }

    if (_selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih tingkat prioritas'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
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
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Tiket berhasil dibuat!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
          ),
        );

        // Navigate back to home after short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  }

  void _handleClose() {
    // Check if form has data
    final hasData = _titleController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _selectedCategory != null ||
        _selectedPriority != null;

    if (hasData) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          title: const Text('Batalkan Tiket?'),
          content: const Text('Data yang sudah diisi akan hilang.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tetap di Halaman'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous page
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: _handleClose,
        ),
        title: const Text(
          'Buat Tiket Baru',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori Section
                      const Text(
                        'Kategori *',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      Wrap(
                        spacing: AppConstants.spacingSm,
                        runSpacing: AppConstants.spacingSm,
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory == cat['value'];
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat['value']),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryLight : AppColors.surface,
                                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    cat['icon'],
                                    size: 16,
                                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat['name'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppConstants.spacing2xl),

                      // Judul Field
                      CustomTextField(
                        controller: _titleController,
                        hintText: 'Ringkasan masalah Anda',
                        labelText: 'Judul *',
                        prefixIcon: const AppFieldPrefix(icon: Icons.title),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: _validateTitle,
                      ),

                      const SizedBox(height: AppConstants.spacingLg),

                      // Deskripsi Field
                      CustomTextField(
                        controller: _descriptionController,
                        hintText: 'Jelaskan masalah Anda secara detail...',
                        labelText: 'Deskripsi *',
                        maxLines: 5,
                        validator: _validateDescription,
                      ),

                      const SizedBox(height: AppConstants.spacing2xl),

                      // Prioritas Section
                      const Text(
                        'Prioritas *',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      Row(
                        children: _priorities.map((pri) {
                          final isSelected = _selectedPriority == pri['value'];
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedPriority = pri['value']),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(
                                  right: pri['value'] != 'tinggi' ? AppConstants.spacingSm : 0,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? pri['color'].withValues(alpha: 0.15) : AppColors.surface,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                  border: Border.all(
                                    color: isSelected ? pri['color'] : AppColors.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    pri['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? pri['color'] : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppConstants.spacing2xl),

                      // Lampiran Section
                      const Text(
                        'Lampiran (Opsional)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      GestureDetector(
                        onTap: () {
                          // Image picker would go here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Fitur lampiran akan segera hadir'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppConstants.spacing2xl),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.textSecondary),
                              const SizedBox(height: AppConstants.spacingSm),
                              const Text(
                                'Tambah File',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
                              ),
                              const SizedBox(height: AppConstants.spacingXs),
                              const Text(
                                'Maksimal 5MB per file',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Submit Button
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, -2))],
                ),
                child: CustomButton(
                  text: 'Kirim Tiket',
                  onPressed: _handleSubmit,
                  isLoading: _isLoading,
                  icon: Icons.send,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
