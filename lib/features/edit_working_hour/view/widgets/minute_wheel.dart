import 'package:flutter/material.dart';
import 'package:new_design/features/edit_working_hour/extension/time_of_day_extensions.dart';
import 'package:new_design/features/edit_working_hour/model/time_wheel_model.dart';
import 'package:new_design/features/edit_working_hour/view/widgets/wheel_base.dart';

class MinuteWheel extends WheelBase {
  const MinuteWheel({
    super.key,
    required super.initialTime,
    required super.itemExtent,
    required super.onChanged,
    required super.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = TimeWheelModel.generateMinuteList();
    final initialIndex = initialTime.minute + 3;

    return ListWheelScrollView.useDelegate(
      itemExtent: itemExtent,
      diameterRatio: 2.0,
      perspective: 0.005,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: initialIndex),
      onSelectedItemChanged: (index) {
        final adjustedIndex = (index - 3) % 60;
        onChanged(initialTime.copyWith(minute: adjustedIndex));
        onSelectionChanged();
      },
      childDelegate: ListWheelChildLoopingListDelegate(
        children: List.generate(minutes.length, (index) {
          final minute = minutes[index];
          final parsedMinute = int.parse(minute) % 60;
          return buildWheelItem(minute, parsedMinute == initialTime.minute);
        }).toList(),
      ),
    );
  }
}
