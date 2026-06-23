import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/theme/app_palette.dart';

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: c.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Hero banner full-width (ala login_dark.png FlutterShop) =====
            _LoginHero(height: size.height * 0.38),

            // ===== Konten =====
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg), // defaultPadding = 16
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat Datang!', style: AppTextStyles.h1(c)),
                    const SizedBox(height: AppSpacing.sm), // defaultPadding / 2 = 8

                    Text(
                      'Masuk dengan akun Anda untuk membuat dan melacak tiket helpdesk.',
                      style: AppTextStyles.body(c),
                    ),
                    const SizedBox(height: AppSpacing.lg), // defaultPadding = 16

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
                    const SizedBox(height: AppSpacing.lg), // defaultPadding = 16

                    // ===== Password =====
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(context),
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
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),

                    // ===== Lupa password (center ala FlutterShop) =====
                    Align(
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

                    // ===== Spacing dinamis ala FlutterShop =====
                    SizedBox(
                      height: size.height > 700
                          ? size.height * 0.03
                          : AppSpacing.lg,
                    ),

                    // ===== Demo accounts =====
                    _DemoAccountsCard(
                      onTapUser: () => _fillDemoCredentials('user@demo.com'),
                      onTapAdmin: () => _fillDemoCredentials('admin@demo.com'),
                      onTapHelpdesk:
                          () => _fillDemoCredentials('helpdesk@demo.com'),
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
                            onChanged: (v) =>
                                setState(() => _rememberMe = v ?? false),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Ingat saya',
                          style: AppTextStyles.body(c)
                              .copyWith(color: c.textPrimary),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xxl), // defaultPadding * 2

                    // ===== CTA Button =====
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _handleLogin(context),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Masuk'),
                    ),

                    // ===== Sign up row =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belum punya akun?', style: AppTextStyles.body(c)),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text('Daftar'),
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

// ===== Hero Banner (pengganti login_dark.png FlutterShop) =====
class _LoginHero extends StatelessWidget {
  final double height;
  const _LoginHero({required this.height});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: c.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Dekorasi lingkaran besar di pojok kanan atas
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          // Dekorasi lingkaran sedang di pojok kiri bawah
          Positioned(
            left: -24,
            bottom: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          // Logo putih di tengah
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.xxl),
                    boxShadow: AppShadow.fab,
                  ),
                  child: SvgPicture.asset(
                    'assets/logowhite.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'E-Ticketing Helpdesk',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Universitas Airlangga',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Demo Accounts Card =====
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
          _DemoRow(role: 'User', email: 'user@demo.com', onTap: onTapUser),
          _DemoRow(
              role: 'Admin', email: 'admin@demo.com', onTap: onTapAdmin),
          _DemoRow(
              role: 'Helpdesk',
              email: 'helpdesk@demo.com',
              onTap: onTapHelpdesk),
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
  final String role;
  final String email;
  final VoidCallback onTap;

  const _DemoRow({
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
