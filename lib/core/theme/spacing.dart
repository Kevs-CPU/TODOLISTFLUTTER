import 'package:flutter/material.dart';

class AppSpacing {
  // =====================================================
  // STANDARD SPACING (from CSS: gap, padding, margin)
  // =====================================================
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // =====================================================
  // PADDING (from CSS: padding: 20px 24px, etc.)
  // =====================================================
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: lg);
  
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: lg);

  static const EdgeInsets paddingTopBar = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: 20,
  );

  static const EdgeInsets paddingTaskCard = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: md,
  );

  static const EdgeInsets paddingModalHeader = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: 20,
  );

  static const EdgeInsets paddingModalBody = EdgeInsets.all(lg);

  // =====================================================
  // MARGIN (from CSS: margin-bottom: 24px, etc.)
  // =====================================================
  static const EdgeInsets marginXS = EdgeInsets.all(xs);
  static const EdgeInsets marginSM = EdgeInsets.all(sm);
  static const EdgeInsets marginMD = EdgeInsets.all(md);
  static const EdgeInsets marginLG = EdgeInsets.all(lg);
  static const EdgeInsets marginXL = EdgeInsets.all(xl);

  static const EdgeInsets marginTopBar = EdgeInsets.only(bottom: lg);
  static const EdgeInsets marginTaskCard = EdgeInsets.only(bottom: md);

  // =====================================================
  // BORDER RADIUS (from CSS: border-radius)
  // =====================================================
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(999));

  // =====================================================
  // SIZES (from CSS: width, height)
  // =====================================================
  static const double iconSizeSM = 16.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;

  static const double buttonHeight = 48.0;
  static const double buttonMinWidth = 120.0;
  static const double inputHeight = 48.0;

  static const double fabSize = 60.0;
  static const double fabSizeSmall = 50.0;
  static const double fabIconSize = 32.0;
  static const double fabIconSizeSmall = 28.0;

  static const double checkboxSize = 28.0;
  static const double iconButtonSize = 32.0;

  static const double loaderSize = 40.0;
  static const double emptyIconSize = 48.0;

  // =====================================================
  // CONSTRAINTS (from CSS: max-width: 800px, etc.)
  // =====================================================
  static const double maxAppWidth = 800.0;
  static const double maxModalWidth = 500.0;

  // =====================================================
  // Z-INDEX (from CSS: z-index: 1000)
  // =====================================================
  static const int modalZIndex = 1000;
}