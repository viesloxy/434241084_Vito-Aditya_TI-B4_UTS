import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_shadow.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/app_palette.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  String _humanizeError(Object e) {
    if (e is AuthException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('network') || msg.contains('socket')) {
        return 'Gagal terhubung ke server. Cek koneksi internet Anda.';
      }
      return e.message;
    }
    return 'Gagal mengirim email: ${e.toString()}';
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.resetPassword(_emailController.text.trim());

      if (!mounted) return;
      setState(() => _emailSent = true);
    } catch (e) {
      if (!mounted) return;
      final c = context.palette;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  _humanizeError(e),
                  style: AppTextStyles.body(c).copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: c.error,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          margin: const EdgeInsets.all(AppSpacing.lg),
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
            _ForgotPasswordHero(height: size.height * 0.32),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _emailSent ? _SuccessView(c: c) : _FormView(
                formKey: _formKey,
                emailController: _emailController,
                isLoading: _isLoading,
                onSubmit: () => _handleSubmit(context),
                onBack: () => Navigator.pop(context),
                c: c,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Hero Banner =====
class _ForgotPasswordHero extends StatelessWidget {
  final double height;
  const _ForgotPasswordHero({required this.height});

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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
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
                const Text(
                  'Lupa Password',
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
                  'Reset akses akun Anda',
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

// ===== Form View =====
class _FormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final AppPalette c;

  const _FormView({
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
    required this.onBack,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reset Password', style: AppTextStyles.h1(c)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Masukkan email yang terdaftar. Kami akan mengirimkan link untuk membuat password baru.',
            style: AppTextStyles.body(c),
          ),
          const SizedBox(height: AppSpacing.xxl),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Alamat email terdaftar',
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: SvgPicture.asset(
                  'assets/icons/Message.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(c.textTertiary, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Kirim Link Reset'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sudah ingat password?', style: AppTextStyles.body(c)),
              TextButton(
                onPressed: onBack,
                child: const Text('Masuk'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===== Success View (setelah email terkirim) =====
class _SuccessView extends StatelessWidget {
  final AppPalette c;
  const _SuccessView({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: c.successLight,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.mark_email_read_outlined, color: c.success, size: 40),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Email Terkirim!',
          style: AppTextStyles.h1(c),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Cek inbox atau folder spam Anda. Link reset password akan kedaluwarsa dalam 60 menit.',
          style: AppTextStyles.body(c),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          child: const Text('Kembali ke Login'),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}
