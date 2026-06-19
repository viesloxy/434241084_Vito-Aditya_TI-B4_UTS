import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../../../core/constants/app_max_width.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/theme/app_palette.dart';

/// Login Page ala FlutterShop Free Version.
///
/// Referensi: `lib/screens/auth/views/login_screen.dart` &
/// `lib/screens/auth/views/components/login_form.dart`.
///
/// Layout:
/// - Scaffold white (ala FlutterShop `scaffoldBackgroundColor`)
/// - Outer padding `EdgeInsets.all(defaultPadding)` = 16
/// - **Form di-center dengan `maxWidth: 360` (CenteredContent)** — konten
///   tidak mepet ke edge di layar lebar (tablet/landscape/web).
/// - Spacing mengikuti konvensi FlutterShop (section 4 dokumentasi).
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 8.3.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  String _humanizeError(Object e) {
    if (e is AuthException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login') || msg.contains('invalid credentials')) {
        return 'Email atau password salah. Periksa kembali kredensial Anda.';
      }
      if (msg.contains('email not confirmed')) {
        return 'Email belum diverifikasi. Cek inbox Anda untuk link konfirmasi.';
      }
      if (msg.contains('user not found')) {
        return 'Akun dengan email ini tidak ditemukan.';
      }
      if (msg.contains('network') || msg.contains('socket')) {
        return 'Gagal terhubung ke server. Cek koneksi internet Anda.';
      }
      return e.message;
    }
    final text = e.toString();
    if (text.contains('profile') || text.contains('user_profiles')) {
      return 'Akun ditemukan tapi profil tidak lengkap. Hubungi admin.';
    }
    return 'Login gagal: $text';
  }

  Future<void> _handleLogin(BuildContext context) async {
    final c = context.palette;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        _floatingSnackBar(
          context: context,
          message: 'Login berhasil! Selamat datang, ${user.fullName}.',
          background: c.success,
          icon: Icons.check_circle_outline,
        ),
      );

      Navigator.pushReplacementNamed(context, user.role.defaultRoute);
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

  void _fillDemoCredentials(String email) {
    _emailController.text = email;
    _passwordController.text = 'password123';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: CenteredContent(
            maxWidth: AppMaxWidth.form,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.huge),

                  // ===== Hero: gradient box (96×96) + white logo =====
                  Center(
                    child: Container(
                      width: 96,
                      height: 96,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: c.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xxl),
                        boxShadow: AppShadow.fab,
                      ),
                      child: SvgPicture.asset(
                        'assets/logowhite.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  Text('Selamat Datang', style: AppTextStyles.h1(c)),
                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'Masuk dengan akun Anda untuk membuat dan melacak tiket helpdesk.',
                    style: AppTextStyles.body(c),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ===== Form =====
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Alamat email',
                    prefixIcon: const AppFieldPrefix(icon: Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    prefixIcon: const AppFieldPrefix(icon: Icons.lock_outline),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleLogin(context),
                    validator: _validatePassword,
                    suffixIcon: AppPasswordSuffix(
                      obscure: _obscurePassword,
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          _floatingSnackBar(
                            context: context,
                            message: 'Hubungi admin untuk reset password.',
                            background: c.info,
                            icon: Icons.info_outline,
                          ),
                        );
                      },
                      child: const Text('Lupa password?'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  _DemoAccountsCard(
                    onTapUser: () => _fillDemoCredentials('user@demo.com'),
                    onTapAdmin: () => _fillDemoCredentials('admin@demo.com'),
                    onTapHelpdesk: () => _fillDemoCredentials('helpdesk@demo.com'),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ===== Remember Me =====
                  Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Ingat saya',
                        style: AppTextStyles.body(c).copyWith(color: c.textPrimary),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _handleLogin(context),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Masuk'),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun?',
                        style: AppTextStyles.body(c),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text('Daftar'),
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

class _DemoAccountsCard extends StatelessWidget {
  final VoidCallback onTapUser;
  final VoidCallback onTapAdmin;
  final VoidCallback onTapHelpdesk;

  const _DemoAccountsCard({
    required this.onTapUser,
    required this.onTapAdmin,
    required this.onTapHelpdesk,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: c.infoLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: c.info.withValues(alpha: 0.4)),
        boxShadow: AppShadow.dialog,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: c.info),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Akun Demo (testing)',
                style: AppTextStyles.caption(c).copyWith(
                  color: c.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _DemoRow(
            icon: Icons.person_outline,
            role: 'User',
            email: 'user@demo.com',
            onTap: onTapUser,
          ),
          _DemoRow(
            icon: Icons.admin_panel_settings_outlined,
            role: 'Admin',
            email: 'admin@demo.com',
            onTap: onTapAdmin,
          ),
          _DemoRow(
            icon: Icons.support_agent_outlined,
            role: 'Helpdesk',
            email: 'helpdesk@demo.com',
            onTap: onTapHelpdesk,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Password semua akun: password123',
            style: AppTextStyles.caption(c).copyWith(
              color: c.info,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoRow extends StatelessWidget {
  final IconData icon;
  final String role;
  final String email;
  final VoidCallback onTap;

  const _DemoRow({
    required this.icon,
    required this.role,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: AppSpacing.xs),
        child: Row(
          children: [
            Icon(icon, size: 16, color: c.info),
            const SizedBox(width: AppSpacing.sm),
            Text(
              role,
              style: AppTextStyles.caption(c).copyWith(
                color: c.info,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                email,
                style: AppTextStyles.caption(c).copyWith(
                  color: c.info,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.touch_app, size: 14, color: c.info),
          ],
        ),
      ),
    );
  }
}
