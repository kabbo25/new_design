import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/edit_working_hour/viewmodel/working_hour_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/time_selector_wheel.dart';
import '../widgets/time_type_selector.dart';

class TimePickerModal extends StatelessWidget {
  final String title;
  final String editTimeLabel;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onSave;
  final bool showWorkingHourSelector;
  final String saveButtonText;

  const TimePickerModal({
    super.key,
    required this.title,
    required this.editTimeLabel,
    this.initialTime,
    required this.onSave,
    this.showWorkingHourSelector = false,
    this.saveButtonText = 'Save',
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkingHourViewModel(initialTime: initialTime),
      child: _TimePickerModalContent(
        title: title,
        editTimeLabel: editTimeLabel,
        onSave: onSave,
        showWorkingHourSelector: showWorkingHourSelector,
        saveButtonText: saveButtonText,
      ),
    );
  }
}

class _TimePickerModalContent extends StatelessWidget {
  final String title;
  final String editTimeLabel;
  final Function(TimeOfDay) onSave;
  final bool showWorkingHourSelector;
  final String saveButtonText;

  const _TimePickerModalContent({
    required this.title,
    required this.editTimeLabel,
    required this.onSave,
    required this.showWorkingHourSelector,
    required this.saveButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkingHourViewModel>();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          if (showWorkingHourSelector) ...[
            //const Gap(24),
            TimeTypeSelector(
              isStartTime: viewModel.isStartTime,
              onStartTimeSelected: () => viewModel.toggleTimeType(),
              onEndTimeSelected: () => viewModel.toggleTimeType(),
            ),
          ],
          const Gap(12),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                viewModel.isStartTime
                    ? editTimeLabel
                    : 'Edit your exit time here:',
                style:
                    AppTextStyles.title.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const Gap(8),
          _buildTimeWheel(context, viewModel),
          const Gap(12),
          _buildSaveButton(context, viewModel),
          const Gap(20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0XFFE8E8E8),
            width: 2,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: AppTextStyles.heading2,
        ),
      ),
    );
  }

  Widget _buildTimeWheel(BuildContext context, WorkingHourViewModel viewModel) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 100),
      child: TimeSelectorWheel(
        initialTime: viewModel.selectedTime,
        enableSound: true,
        enableVibration: true,
        onSelectedTimeChanged: (TimeOfDay newTime) {
          viewModel.updateTime(
            newTime.hourOfPeriod,
            newTime.minute,
            newTime.period == DayPeriod.pm,
          );
        },
      ),
    );
  }

  Widget _buildSaveButton(
      BuildContext context, WorkingHourViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            onSave(viewModel.selectedTime);
            Navigator.pop(context);
          },
          style: AppButtonStyles.elevatedButton,
          child: Text(
            saveButtonText,
            style:
                AppTextStyles.buttonText.copyWith(color: AppPalette.background),
          ),
        ),
      ),
    );
  }
}
