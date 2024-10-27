import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';

class TimeTypeSelector extends StatelessWidget {
  final bool isStartTime;
  final VoidCallback onStartTimeSelected;
  final VoidCallback onEndTimeSelected;

  const TimeTypeSelector({
    super.key,
    required this.isStartTime,
    required this.onStartTimeSelected,
    required this.onEndTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTypeButton(
          title: 'Started at',
          isSelected: isStartTime,
          onTap: onStartTimeSelected,
        ),
        const Gap(12),
        _buildTypeButton(
          title: 'Finished at',
          isSelected: !isStartTime,
          onTap: onEndTimeSelected,
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppPalette.background
                : AppPalette.textSecondary.withOpacity(0.1),
            border: Border.all(
              color: isSelected
                  ? AppPalette.background
                  : AppPalette.textSecondary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: isSelected
                ? AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.bold)
                : AppTextStyles.subtitle1
                    .copyWith(color: AppPalette.textSecondary),
          ),
        ),
      ),
    );
  }
}
