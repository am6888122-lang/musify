import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final double max;
  final double min;
  final void Function(double)? onChanged;
  final void Function(double)? onChangeStart;
  final void Function(double)? onChangeEnd;

  const CustomSlider({
    super.key,
    required this.value,
    required this.max,
    this.min = 0.0,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primary.withOpacity(0.3),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        trackHeight: 4,
      ),
      child: Slider(
        value: max > 0 ? value.clamp(min, max) : 0.0,
        min: min,
        max: max > 0 ? max : 1.0,
        onChanged: max > 0 ? onChanged : null,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
      ),
    );
  }
}