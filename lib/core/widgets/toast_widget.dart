import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ToastWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;

  const ToastWidget({
    super.key,
    required this.message,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMD,
      decoration: AppDecorations.errorDecoration,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.errorDark,
            ),
          ),
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: const Icon(
                Icons.close,
                color: AppColors.errorDark,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}