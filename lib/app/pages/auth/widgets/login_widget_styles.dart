// lib/app/pages/auth/widgets/login_widget_styles.dart

import 'package:flutter/material.dart';

class LoginWidgetStyles {
  // ===================================================
  // COLORS
  // ===================================================
  static const Color backgroundStart = Color(0xFF0F172A);
  static const Color backgroundEnd = Color(0xFF1E293B);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color titleColor = Colors.white;
  static const Color subtitleColor = Color(0xFF94A3B8);
  static const Color labelColor = Color(0xFFE2E8F0);
  static const Color iconColor = Color(0xFF94A3B8);
  static const Color inputBorder = Color(0xFF334155);
  static const Color inputBackground = Color(0xFF1E293B);
  static const Color inputTextColor = Colors.white;
  static const Color inputHintColor = Color(0xFF64748B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF22C55E);

  // ===================================================
  // GRADIENTS
  // ===================================================
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundStart, backgroundEnd],
  );

  // ===================================================
  // CARD DECORATION - WALANG CARD (Transparent)
  // ===================================================
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(0),
    boxShadow: [],
  );

  // ===================================================
  // ICON BADGE
  // ===================================================
  static BoxDecoration iconBadgeDecoration = BoxDecoration(
    color: accentColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: accentColor.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // ===================================================
  // TEXT STYLES - White text for dark background
  // ===================================================
  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: titleColor,
    letterSpacing: -0.5,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 15,
    color: subtitleColor,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: labelColor,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 12,
    color: errorColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle successTextStyle = TextStyle(
    fontSize: 12,
    color: successColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle toggleButtonStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: accentColor,
  );

  // ===================================================
  // INPUT DECORATION - Dark theme with WHITE text
  // ===================================================
  static InputDecoration inputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: inputHintColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      //  Style for the text inside input
      labelStyle: const TextStyle(color: inputTextColor),
      //  Style for the input text
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: inputBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
    );
  }

  // ===================================================
  // BUTTON DECORATION
  // ===================================================
  static BoxDecoration buttonDecoration({bool disabled = false}) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: disabled
          ? []
          : [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
    );
  }

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}