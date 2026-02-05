import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.borderRadius = AppConstants.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? context.buttonHeight;
    final effectiveBorderRadius = borderRadius;
    
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: effectiveHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: backgroundColor ?? AppColors.primary,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
          child: _buildButtonContent(context),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          elevation: 2,
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: context.iconSize * 0.8,
        height: context.iconSize * 0.8,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.iconSize * 0.8),
          SizedBox(width: context.responsivePadding / 2),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isOutlined 
                  ? (backgroundColor ?? AppColors.primary)
                  : (textColor ?? Colors.white),
              fontWeight: FontWeight.w500,
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize! * context.fontSizeMultiplier,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: isOutlined 
            ? (backgroundColor ?? AppColors.primary)
            : (textColor ?? Colors.white),
        fontWeight: FontWeight.w500,
        fontSize: Theme.of(context).textTheme.titleMedium!.fontSize! * context.fontSizeMultiplier,
      ),
    );
  }
}