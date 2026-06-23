import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
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

  Future<void> _handleSubmit(BuildContext context) async {
    final c = context.palette;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih kategori tiket'),
          backgroundColor: c.error,
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
          backgroundColor: c.error,
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
            backgroundColor: c.success,
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

  void _handleClose(BuildContext context) {

    final c = context.palette;
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
          icon: Icon(Icons.close, color: c.textPrimary),
          onPressed: () => _handleClose(context),
        ),
        title: Text(
          'Buat Tiket Baru',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.textPrimary),
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
                      Text(
                        'Kategori *',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.textPrimary),
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
                                color: isSelected ? c.primaryLight : c.surface,
                                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                border: Border.all(
                                  color: isSelected ? c.primary : c.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    cat['icon'],
                                    size: 16,
                                    color: isSelected ? c.primary : c.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat['name'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? c.primary : c.textPrimary,
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
                        prefixIcon: const AppFieldPrefix(svgAsset: 'assets/icons/Edit Square.svg'),
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
                      Text(
                        'Prioritas *',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.textPrimary),
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
                                  color: isSelected ? pri['color'].withValues(alpha: 0.15) : c.surface,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                  border: Border.all(
                                    color: isSelected ? pri['color'] : c.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    pri['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? pri['color'] : c.textPrimary,
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
                      Text(
                        'Lampiran (Opsional)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.textPrimary),
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
                            color: c.surface,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                            border: Border.all(color: c.border, style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 40, color: c.textSecondary),
                              const SizedBox(height: AppConstants.spacingSm),
                              Text(
                                'Tambah File',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.primary),
                              ),
                              const SizedBox(height: AppConstants.spacingXs),
                              Text(
                                'Maksimal 5MB per file',
                                style: TextStyle(fontSize: 12, color: c.textSecondary),
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
                decoration: BoxDecoration(
                  color: c.surface,
                  boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, -2))],
                ),
                child: CustomButton(
                  text: 'Kirim Tiket',
                  onPressed: () => _handleSubmit(context),
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
