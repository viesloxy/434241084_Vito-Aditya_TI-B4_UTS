import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_palette.dart';

/// ErrorState ala FlutterShop — icon error 80×80, retry button.
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.message = 'Gagal memuat data',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: c.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/Close.svg',
                  width: 40,
                  height: 40,
                  colorFilter: ColorFilter.mode(c.error, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Oops!', style: AppTextStyles.h3(c)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTextStyles.body(c).copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
