import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';

/// Role login untuk testing. Setelah integrasi backend,
/// role akan dideteksi dari response API berdasarkan kredensial user.
enum LoginRole { user, admin, helpdesk }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  LoginRole _selectedRole = LoginRole.user;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulasi panggilan API
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        // Redirect sesuai role
        switch (_selectedRole) {
          case LoginRole.user:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case LoginRole.admin:
            Navigator.pushReplacementNamed(context, '/admin');
            break;
          case LoginRole.helpdesk:
            Navigator.pushReplacementNamed(context, '/helpdesk');
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacing3xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    size: 48,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.spacingSm),

                const Text(
                  'Masuk untuk melanjutkan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.spacing3xl),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Masukkan email Anda',
                  labelText: 'Email',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Masukkan password',
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                  validator: _validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() => _rememberMe = value ?? false);
                              },
                              activeColor: AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.border, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingSm),
                          const Text(
                            'Ingat saya',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lupa password?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                // Role Switcher (3 Mode untuk Testing)
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Mode Login (Testing)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      Row(
                        children: [
                          Expanded(
                            child: _buildRoleButton(
                              role: LoginRole.user,
                              icon: Icons.person_outline,
                              label: 'Pengguna',
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingXs),
                          Expanded(
                            child: _buildRoleButton(
                              role: LoginRole.admin,
                              icon: Icons.admin_panel_settings_outlined,
                              label: 'Admin',
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingXs),
                          Expanded(
                            child: _buildRoleButton(
                              role: LoginRole.helpdesk,
                              icon: Icons.support_agent_outlined,
                              label: 'Helpdesk',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                // Login Button
                CustomButton(
                  text: 'Masuk',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                  icon: Icons.arrow_forward,
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
                      child: const Text(
                        'atau',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),

                const SizedBox(height: AppConstants.spacing2xl),

                // Register Link (Hanya untuk User)
                if (_selectedRole == LoginRole.user)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingLg),
                    child: Text(
                      _selectedRole == LoginRole.admin
                          ? 'Akun Admin & Helpdesk dibuat oleh sistem/superadmin (tidak bisa register sendiri).'
                          : 'Akun Helpdesk dibuat oleh sistem/superadmin (tidak bisa register sendiri).',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required LoginRole role,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
