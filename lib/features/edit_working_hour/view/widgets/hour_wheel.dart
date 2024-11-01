import 'package:flutter/material.dart';
import 'package:new_design/features/edit_working_hour/extension/time_of_day_extensions.dart';
import 'package:new_design/features/edit_working_hour/model/time_wheel_model.dart';
import 'package:new_design/features/edit_working_hour/view/widgets/wheel_base.dart';

class HourWheel extends WheelBase {
  const HourWheel({
    super.key,
    required super.initialTime,
    required super.itemExtent,
    required super.onChanged,
    required super.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hours = TimeWheelModel.generateHourList();
    final initialIndex =
        initialTime.hourOfPeriod == 12 ? 2 : initialTime.hourOfPeriod + 2;

    return ListWheelScrollView.useDelegate(
      itemExtent: itemExtent,
      diameterRatio: 2.0,
      perspective: 0.005,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: initialIndex),
      onSelectedItemChanged: (index) {
        final adjustedIndex = index - 2;
        final hour = ((adjustedIndex - 1) % 12) + 1;
        final actualHour = TimeWheelModel.normalizeHour(hour, initialTime.isPM);

        onChanged(initialTime.copyWith(hour: actualHour));
        onSelectionChanged();
      },
      childDelegate: ListWheelChildLoopingListDelegate(
        children: hours.map((hour) {
          final parsedHour = int.parse(hour);
          return buildWheelItem(hour, parsedHour == initialTime.hourOfPeriod);
        }).toList(),
      ),
    );
  }
}
