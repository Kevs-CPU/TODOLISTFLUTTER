import 'package:flutter/material.dart';

class AppColors {
  // =====================================================
  // PRIMARY COLORS
  // =====================================================
  static const Color primary = Color(0xFF667EEA);
  static const Color primaryLight = Color(0xFF8B9FF0);
  static const Color primaryDark = Color(0xFF4A5FB5);
  
  static const Color secondary = Color(0xFF764BA2);
  static const Color secondaryLight = Color(0xFF9B6FC7);
  static const Color secondaryDark = Color(0xFF5A357A);

  // =====================================================
  // NEUTRAL COLORS
  // =====================================================
  static const Color background = Color(0xFFF0F2F5);
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF2D2D44);
  
  static const Color text = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFADB5BD);
  static const Color textWhite = Colors.white;
  static const Color textWhite80 = Color(0xCCFFFFFF);

  // =====================================================
  // STATE COLORS
  // =====================================================
  static const Color success = Color(0xFF28A745);
  static const Color successLight = Color(0xFFD4EDDA);
  static const Color successDark = Color(0xFF155724);
  
  static const Color error = Color(0xFFDC3545);
  static const Color errorLight = Color(0xFFFFEEEE);
  static const Color errorDark = Color(0xFF721C24);
  
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFF3CD);
  static const Color warningDark = Color(0xFF856404);

  // =====================================================
  // BORDER COLORS
  // =====================================================
  static const Color border = Color(0xFFE9ECEF);
  static const Color borderFocus = Color(0xFF667EEA);
  static const Color borderError = Color(0xFFDC3545);

  // =====================================================
  // BACKGROUND COLORS
  // =====================================================
  static const Color inputBackground = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundDark = Color(0xFF2D2D44);
  
  // =====================================================
  // BUTTON COLORS
  // =====================================================
  static const Color buttonPrimary = Color(0xFF667EEA);
  static const Color buttonSecondary = Color(0xFFE9ECEF);
  static const Color buttonDanger = Color(0xFFDC3545);
  static const Color buttonSuccess = Color(0xFF28A745);
  
  // =====================================================
  // ICON COLORS
  // =====================================================
  static const Color iconDefault = Color(0xFF6C757D);
  static const Color iconPrimary = Color(0xFF667EEA);
  static const Color iconSuccess = Color(0xFF28A745);
  static const Color iconError = Color(0xFFDC3545);
  static const Color iconEdit = Color(0xFF1976D2);
  static const Color iconDelete = Color(0xFFDC3545);
  static const Color iconSave = Color(0xFF155724);
  static const Color iconCancel = Color(0xFF721C24);

  // =====================================================
  // OPACITY COLORS (withValues)
  // =====================================================
  static Color primaryWithOpacity(double opacity) => 
      primary.withValues(alpha: opacity);
  
  static Color whiteWithOpacity(double opacity) => 
      Colors.white.withValues(alpha: opacity);
  
  static Color blackWithOpacity(double opacity) => 
      Colors.black.withValues(alpha: opacity);
}