import 'package:flutter/material.dart';
import '../theme/theme.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: AppSpacing.loaderSize,
            height: AppSpacing.loaderSize,
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message ?? 'Loading your tasks...',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}