import 'package:flutter/material.dart';
import 'colors.dart';

class AppDecorations {
  // =====================================================
  // GRADIENTS
  // =====================================================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.secondary],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.success, Color(0xFF20C997)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.error, Color(0xFFE74C3C)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.warning, Color(0xFFFFD54F)],
  );

  // =====================================================
  // SHADOWS (withValues)
  // =====================================================
  static BoxShadow primaryShadow = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.3),
    blurRadius: 20,
    offset: const Offset(0, 4),
  );

  static BoxShadow primaryShadowSmall = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.4),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.06),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static BoxShadow cardShadowHover = BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  static BoxShadow fabShadow = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.4),
    blurRadius: 20,
    offset: const Offset(0, 4),
  );

  static BoxShadow fabShadowHover = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.5),
    blurRadius: 28,
    offset: const Offset(0, 6),
  );

  static BoxShadow buttonShadow = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.4),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  static BoxShadow errorShadow = BoxShadow(
    color: AppColors.error.withValues(alpha: 0.2),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static BoxShadow modalShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: 60,
    offset: const Offset(0, 20),
  );

  static BoxShadow filterShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.06),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  // =====================================================
  // CARD DECORATIONS
  // =====================================================
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [cardShadow],
  );

  static BoxDecoration cardDecorationHover = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [cardShadowHover],
  );

  static BoxDecoration cardDecorationCompleted = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [cardShadow],
  );

  // =====================================================
  // TOPBAR DECORATION
  // =====================================================
  static BoxDecoration topBarDecoration = BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [primaryShadow],
  );

  // =====================================================
  // GRADIENT CARD DECORATION
  // =====================================================
  static BoxDecoration gradientCardDecoration = BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [primaryShadow],
  );

  // =====================================================
  // ERROR DECORATION
  // =====================================================
  static BoxDecoration errorDecoration = BoxDecoration(
    color: AppColors.errorLight,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.error, width: 4),
    boxShadow: [errorShadow],
  );

  static BoxDecoration successDecoration = BoxDecoration(
    color: AppColors.successLight,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.success, width: 2),
  );

  // =====================================================
  // INPUT DECORATIONS
  // =====================================================
  static InputDecoration inputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.inputBackground,
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textLight),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderError, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // =====================================================
  // MODAL DECORATION
  // =====================================================
  static BoxDecoration modalDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [modalShadow],
  );

  // =====================================================
  // EMPTY STATE DECORATION
  // =====================================================
  static BoxDecoration emptyStateDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [cardShadow],
  );

  // =====================================================
  // FILTER GROUP DECORATION
  // =====================================================
  static BoxDecoration filterGroupDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [filterShadow],
  );

  static BoxDecoration filterCountDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [filterShadow],
  );
}