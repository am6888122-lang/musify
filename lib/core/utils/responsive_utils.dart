import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Get responsive padding based on screen size
  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return 8.0;
    if (isTablet(context)) return 12.0;
    return 32.0;
  }

  // Get responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    if (isMobile(context)) return 1.0;
    if (isTablet(context)) return 1.1;
    return 1.2;
  }

  // Get responsive card width
  static double getCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) return 150.0;
    if (isTablet(context)) return screenWidth * 0.2;
    return screenWidth * 0.15;
  }

  // Get responsive grid columns
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  // Get responsive list item height
  static double getListItemHeight(BuildContext context) {
    if (isMobile(context)) return 70.0;
    if (isTablet(context)) return 80.0;
    return 90.0;
  }

  // Get responsive border radius
  static double getBorderRadius(BuildContext context) {
    if (isMobile(context)) return 12.0;
    if (isTablet(context)) return 16.0;
    return 20.0;
  }

  // Get responsive icon size
  static double getIconSize(BuildContext context) {
    if (isMobile(context)) return 24.0;
    if (isTablet(context)) return 28.0;
    return 32.0;
  }

  // Get responsive button height
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) return 50.0;
    if (isTablet(context)) return 55.0;
    return 60.0;
  }

  // Get max content width for web
  static double getMaxContentWidth(BuildContext context) {
    if (isWeb(context)) return 1200.0;
    return double.infinity;
  }

  // Get responsive horizontal spacing
  static double getHorizontalSpacing(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 20.0;
    return 24.0;
  }

  // Get responsive vertical spacing
  static double getVerticalSpacing(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 20.0;
    return 24.0;
  }
}

// Extension to make responsive utilities easier to use
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  bool get isWeb => ResponsiveUtils.isWeb(this);

  double get screenWidth => ResponsiveUtils.getScreenWidth(this);
  double get screenHeight => ResponsiveUtils.getScreenHeight(this);
  double get responsivePadding => ResponsiveUtils.getResponsivePadding(this);
  double get fontSizeMultiplier => ResponsiveUtils.getFontSizeMultiplier(this);
  double get cardWidth => ResponsiveUtils.getCardWidth(this);
  int get gridColumns => ResponsiveUtils.getGridColumns(this);
  double get listItemHeight => ResponsiveUtils.getListItemHeight(this);
  double get borderRadius => ResponsiveUtils.getBorderRadius(this);
  double get iconSize => ResponsiveUtils.getIconSize(this);
  double get buttonHeight => ResponsiveUtils.getButtonHeight(this);
  double get maxContentWidth => ResponsiveUtils.getMaxContentWidth(this);
  double get horizontalSpacing => ResponsiveUtils.getHorizontalSpacing(this);
  double get verticalSpacing => ResponsiveUtils.getVerticalSpacing(this);
}
