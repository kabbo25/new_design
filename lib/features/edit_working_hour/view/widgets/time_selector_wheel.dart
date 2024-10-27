import 'package:flutter/material.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';

class TimeSelectorWheel extends StatelessWidget {
  final List<String> items;
  final double itemExtent;
  final Function(int) onSelectedItemChanged;
  final int initialItem;

  const TimeSelectorWheel({
    super.key,
    required this.items,
    this.itemExtent = 50,
    required this.onSelectedItemChanged,
    required this.initialItem,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListWheelScrollView(
        itemExtent: itemExtent,
        diameterRatio: 1.5,
        onSelectedItemChanged: onSelectedItemChanged,
        children: items.asMap().entries.map((entry) {
          final isSelected = entry.key == initialItem;
          return Container(
            alignment: Alignment.center,
            child: Text(
              entry.value,
              style: isSelected
                  ? AppTextStyles.heading2
                  : AppTextStyles.subtitle1
                      .copyWith(color: AppPalette.textSecondary),
            ),
          );
        }).toList(),
      ),
    );
  }
}
