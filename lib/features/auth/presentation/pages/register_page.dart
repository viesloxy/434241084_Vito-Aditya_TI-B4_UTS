import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../widgets/role_selector.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

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
  final _authService = AuthService();

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

  String _humanizeError(Object e) {
    if (e is AuthException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('user already registered') ||
          msg.contains('already exists')) {
        return 'Email sudah terdaftar. Silakan login.';
      }
      if (msg.contains('network') || msg.contains('socket')) {
        return 'Gagal terhubung ke server. Cek koneksi internet Anda.';
      }
      return e.message;
    }
    return 'Registrasi gagal: ${e.toString()}';
  }

  Future<void> _handleRegister(BuildContext context) async {
    final c = context.palette;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        role: _selectedRole,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        _floatingSnackBar(
          context: context,
          message: 'Registrasi berhasil! Silakan login.',
          background: c.success,
          icon: Icons.check_circle_outline,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        _floatingSnackBar(
          context: context,
          message: _humanizeError(e),
          background: c.error,
          icon: Icons.error_outline,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  SnackBar _floatingSnackBar({
    required BuildContext context,
    required String message,
    required Color background,
    required IconData icon,
  }) {
    final c = context.palette;
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body(c).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: background,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
      ),
      margin: const EdgeInsets.all(AppSpacing.lg),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: c.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Hero banner (ala signUp_dark.png FlutterShop) =====
            _RegisterHero(
              height: size.height * 0.35,
              onBack: () => Navigator.pop(context),
            ),

            // ===== Konten =====
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg), // defaultPadding
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buat Akun Baru', style: AppTextStyles.h1(c)),
                    const SizedBox(height: AppSpacing.sm), // defaultPadding / 2

                    Text(
                      'Silakan masukkan data valid untuk membuat akun.',
                      style: AppTextStyles.body(c),
                    ),
                    const SizedBox(height: AppSpacing.lg), // defaultPadding

                    // ===== Nama =====
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: _validateName,
                      decoration: InputDecoration(
                        hintText: 'Nama lengkap',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md), // 12 = defaultPadding * 0.75
                          child: SvgPicture.asset(
                            'assets/icons/Profile.svg',
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                c.textTertiary, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ===== Email =====
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        hintText: 'Alamat email',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md), // 12 = defaultPadding * 0.75
                          child: SvgPicture.asset(
                            'assets/icons/Message.svg',
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                c.textTertiary, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ===== Role Selector =====
                    RoleSelector(
                      selectedRole: _selectedRole,
                      onRoleChanged: (role) =>
                          setState(() => _selectedRole = role),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ===== Password =====
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md), // 12 = defaultPadding * 0.75
                          child: SvgPicture.asset(
                            'assets/icons/Lock.svg',
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                c.textTertiary, BlendMode.srcIn),
                          ),
                        ),
                        suffixIcon: AppPasswordSuffix(
                          obscure: _obscurePassword,
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ===== Konfirmasi Password =====
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleRegister(context),
                      validator: _validateConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Ulangi password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md), // 12 = defaultPadding * 0.75
                          child: SvgPicture.asset(
                            'assets/icons/Lock.svg',
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                c.textTertiary, BlendMode.srcIn),
                          ),
                        ),
                        suffixIcon: AppPasswordSuffix(
                          obscure: _obscureConfirmPassword,
                          onPressed: () => setState(() =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl), // defaultPadding * 2

                    // ===== CTA Button (ala "Continue" FlutterShop) =====
                    ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _handleRegister(context),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : const Text('Daftar'),
                    ),

                    // ===== Login row (ala FlutterShop) =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sudah punya akun?', style: AppTextStyles.body(c)),
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
          ],
        ),
      ),
    );
  }
}

// ===== Hero Banner Register =====
class _RegisterHero extends StatelessWidget {
  final double height;
  final VoidCallback onBack;
  const _RegisterHero({required this.height, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                c.primaryDark,
                c.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/logowhite.svg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        // Back button overlay di atas hero
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                shape: const CircleBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
