import 'package:flutter/material.dart';
import 'package:new_design/features/edit_working_hour/extension/time_of_day_extensions.dart';
import 'package:new_design/features/edit_working_hour/model/time_wheel_model.dart';
import 'package:new_design/features/edit_working_hour/view/widgets/wheel_base.dart';

class PeriodWheel extends WheelBase {
  const PeriodWheel({
    super.key,
    required super.initialTime,
    required super.itemExtent,
    required super.onChanged,
    required super.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    const periods = ['AM', 'PM'];

    return ListWheelScrollView(
      itemExtent: itemExtent,
      diameterRatio: 20.0,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(
        initialItem: initialTime.isPM ? 1 : 0,
      ),
      onSelectedItemChanged: (index) {
        final isPM = index == 1;
        final currentHourOfPeriod = initialTime.hourOfPeriod;
        final newHour = TimeWheelModel.normalizeHour(currentHourOfPeriod, isPM);

        onChanged(initialTime.copyWith(hour: newHour));
        onSelectionChanged();
      },
      children: periods.map((period) {
        final isSelected = period == (initialTime.isPM ? 'PM' : 'AM');
        return buildWheelItem(period, isSelected);
      }).toList(),
    );
  }
}
