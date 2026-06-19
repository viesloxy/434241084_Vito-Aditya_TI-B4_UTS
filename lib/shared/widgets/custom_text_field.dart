import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_palette.dart';

/// TextFormField ala FlutterShop Free Version.
///
/// Lihat: `docs/STYLE_GUIDE_FLUTTERSHOP.md` section 7.2
/// dan referensi `lib/screens/auth/views/components/login_form.dart`.
///
/// Karakteristik:
/// - **Borderless** — border transparan, fokus primary 1 px
/// - **Fill `lightGreyColor` (`#F8F8F9`)** — dari theme
/// - **Radius 12** (`defaultBorderRadious`) — dari theme
/// - **Prefix icon di-wrap `Padding(vertical: 12)`** — ala login_form.dart
/// - **Tanpa custom contentPadding** — FlutterShop tidak set, default Material
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final int maxLines;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: AppTextStyles.label(c)),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          enabled: enabled,
          maxLines: maxLines,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Helper untuk wrap prefix icon ala FlutterShop:
/// `Padding(EdgeInsets.symmetric(vertical: defaultPadding * 0.75))` = 12.
class AppFieldPrefix extends StatelessWidget {
  final IconData icon;
  final Color? color;
  const AppFieldPrefix({super.key, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md), // 12
      child: Icon(
        icon,
        size: 24,
        color: color ?? c.textTertiary,
      ),
    );
  }
}

/// Helper suffix icon untuk password visibility toggle (ala FlutterShop).
class AppPasswordSuffix extends StatelessWidget {
  final bool obscure;
  final VoidCallback onPressed;
  const AppPasswordSuffix({super.key, required this.obscure, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: c.textSecondary,
        size: 20,
      ),
    );
  }
}
