import 'package:flutter/material.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';

abstract class WheelBase extends StatelessWidget {
  final TimeOfDay initialTime;
  final double itemExtent;
  final Function(TimeOfDay) onChanged;
  final VoidCallback onSelectionChanged;

  const WheelBase({
    super.key,
    required this.initialTime,
    required this.itemExtent,
    required this.onChanged,
    required this.onSelectionChanged,
  });

  Widget buildWheelItem(String text, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: isSelected
            ? AppTextStyles.heading2
            : AppTextStyles.subtitle1.copyWith(
                color: AppPalette.textSecondary.withOpacity(0.5),
              ),
      ),
    );
  }
}
