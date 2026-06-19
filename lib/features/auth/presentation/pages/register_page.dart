import 'package:flutter/material.dart';
import '../../../../core/constants/app_max_width.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../widgets/role_selector.dart';
import '../../../../core/theme/app_palette.dart';

/// Register Page ala FlutterShop Free Version.
///
/// Referensi: `lib/screens/auth/views/signup_screen.dart` &
/// `lib/screens/auth/views/components/sign_up_form.dart`.
///
/// FlutterShop pattern (kita tambahkan Name + Role + Confirm Password):
/// - Outer padding: `EdgeInsets.all(defaultPadding)` = 16
/// - Title → subtitle: `SizedBox(height: defaultPadding / 2)` = 8
/// - Subtitle → form: `SizedBox(height: defaultPadding)` = 16
/// - Antar field: `SizedBox(height: defaultPadding)` = 16
/// - Sebelum CTA: `SizedBox(height: defaultPadding * 2)` = 32
/// - Setelah CTA: `SizedBox(height: defaultPadding)` = 16
/// - "Sudah punya akun? Masuk" row ala FlutterShop
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'mahasiswa';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
    if (value.length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 8) return 'Password minimal 8 karakter';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) return 'Password tidak cocok';
    return null;
  }

  Future<void> _handleRegister(BuildContext context) async {
    final c = context.palette;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Registrasi berhasil! Silakan login.',
                style: AppTextStyles.body(c).copyWith(color: Colors.white),
              ),
            ),
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
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Daftar Akun'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg), // defaultPadding
          child: CenteredContent(
            maxWidth: AppMaxWidth.form, // samakan dengan Login
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // "Let's get started!" ala FlutterShop (headlineSmall)
                Text('Buat Akun Baru', style: AppTextStyles.h1(c)),
                const SizedBox(height: AppSpacing.sm), // defaultPadding / 2

                Text(
                  'Silakan masukkan data valid untuk membuat akun.',
                  style: AppTextStyles.body(c),
                ),
                const SizedBox(height: AppSpacing.lg), // defaultPadding

                // ===== Name =====
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Nama lengkap',
                  prefixIcon: const AppFieldPrefix(icon: Icons.person_outline),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                const SizedBox(height: AppSpacing.lg), // defaultPadding

                // ===== Email =====
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Alamat email',
                  prefixIcon: const AppFieldPrefix(icon: Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                const SizedBox(height: AppSpacing.lg), // defaultPadding

                // ===== Role Selector (custom, bukan FlutterShop punya) =====
                RoleSelector(
                  selectedRole: _selectedRole,
                  onRoleChanged: (role) => setState(() => _selectedRole = role),
                ),
                const SizedBox(height: AppSpacing.lg), // defaultPadding

                // ===== Password =====
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: const AppFieldPrefix(icon: Icons.lock_outline),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  suffixIcon: AppPasswordSuffix(
                    obscure: _obscurePassword,
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg), // defaultPadding

                // ===== Confirm Password =====
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Ulangi password',
                  prefixIcon: const AppFieldPrefix(icon: Icons.lock_outline),
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onSubmitted: (_) => _handleRegister(context),
                  suffixIcon: AppPasswordSuffix(
                    obscure: _obscureConfirmPassword,
                    onPressed: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl), // defaultPadding * 1.5

                // ===== Register Button (ala "Continue" di FlutterShop) =====
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleRegister(context),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Daftar'),
                ),
                const SizedBox(height: AppSpacing.lg), // defaultPadding

                // "Do you have an account? Log in" ala FlutterShop
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: AppTextStyles.body(c),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text('Masuk'),
                    ),
                  ],
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
