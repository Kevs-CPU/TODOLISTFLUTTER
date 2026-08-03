// lib/app/pages/auth/widgets/login_widget_styles.dart

import 'package:flutter/material.dart';

class LoginWidgetStyles {
  // ===================================================
  // COLORS
  // ===================================================
  static const Color backgroundStart = Color(0xFFEAFBFF);
  static const Color backgroundEnd = Color(0xFF49C5F1);

  static const Color accentColor = Color(0xFF2F9BE0);
  static const Color titleColor = Color(0xFF14507D);
  static const Color subtitleColor = Color(0xFF64748B);
  static const Color labelColor = Color(0xFF334155);
  static const Color iconColor = Color(0xFF7B93A8);

  // Card / inputs — light theme now instead of dark navy
  static const Color cardColor = Color.fromARGB(255, 217, 243, 250);
  static const Color inputBorder = Color(0xFFDCE6F0);
  static const Color inputBackground = Color(0xFFF3F7FB);
  static const Color inputTextColor = Color(0xFF1E293B);
  static const Color inputHintColor = Color(0xFF9FB3C8);

  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF22C55E);

  // Gradient border colors (orange → blue diagonal, like the reference cards)
  static const Color borderGradientStart = Color.fromARGB(255, 252, 251, 251);
  static const Color borderGradientEnd = Color.fromARGB(255, 251, 251, 252);

  // Decorative blurred "blob" accents
  static const Color blobColor = Color(0xFF3FA9F5);

  // ===================================================
  // GRADIENTS
  // ===================================================
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color.fromARGB(255, 166, 225, 238), backgroundEnd],
  );

  static const LinearGradient cardBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [borderGradientStart, borderGradientEnd],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFF1F5F9)],
  );

  // ===================================================
  // CARD SHAPE
  // ===================================================
  static const double cardBorderRadius = 28;
  static const double cardBorderWidth = 1.6;
  static double get cardInnerRadius => cardBorderRadius - cardBorderWidth;

  static BoxDecoration get cardOuterDecoration => BoxDecoration(
        gradient: cardBorderGradient,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.18),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      );

  static BoxDecoration get cardInnerDecoration => BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(cardInnerRadius),
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
  // TEXT STYLES — dark navy on light background now
  // ===================================================
  static const TextStyle titleStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: titleColor,
    letterSpacing: -0.4,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14.5,
    color: subtitleColor,
    fontWeight: FontWeight.w400,
    height: 1.4,
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

  // "Cancel"-style plain link text, like the reference card
  static const TextStyle toggleButtonStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: subtitleColor,
  );

  // ===================================================
  // INPUT DECORATION — light theme
  // ===================================================
  static InputDecoration inputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: inputHintColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(color: inputTextColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: inputBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
    );
  }

  // ===================================================
  // BUTTON DECORATION — floating white pill, like "Subscribe"
  // ===================================================
  static BoxDecoration buttonDecoration({bool disabled = false}) {
    return BoxDecoration(
      gradient: buttonGradient,
      borderRadius: BorderRadius.circular(999),
      boxShadow: disabled
          ? []
          : [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
    );
  }

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: titleColor,
    letterSpacing: 0.3,
  );
}