import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/edit_working_hour/view/widgets/time_type_selector.dart';
import 'package:new_design/features/edit_working_hour/viewmodel/working_hour_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/time_selector_wheel.dart';

class LastWorkingDayModal extends StatelessWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay) onSave;

  const LastWorkingDayModal({
    super.key,
    this.initialTime,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkingHourViewModel(initialTime: initialTime),
      child: _LastWorkingDayModalContent(onSave: onSave),
    );
  }
}

class _LastWorkingDayModalContent extends StatelessWidget {
  final Function(TimeOfDay) onSave;

  const _LastWorkingDayModalContent({
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkingHourViewModel>();
    final now = TimeOfDay.now();
    final selectedTime = viewModel.selectedTime;

    final currentMinutes = now.hour * 60 + now.minute;
    final selectedMinutes = selectedTime.hour * 60 + selectedTime.minute;
    final diffMinutes = selectedMinutes - currentMinutes;
    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          //const Gap(24),
          TimeTypeSelector(
            isStartTime: viewModel.isStartTime,
            onStartTimeSelected: () => viewModel.toggleTimeType(),
            onEndTimeSelected: () => viewModel.toggleTimeType(),
          ),
          const Gap(12),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                viewModel.isStartTime
                    ? 'Edit your entry time here:'
                    : 'Edit your exit time here:',
                style:
                    AppTextStyles.title.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const Gap(8),
          _buildTimeWheel(context, viewModel),
          const Gap(32),
          _buildSaveButton(context, viewModel),
          const Gap(16),
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
      child: const Center(
        child: Text(
          'Edit last working day',
          style: AppTextStyles.heading2,
        ),
      ),
    );
  }

  Widget _buildTimeWheel(BuildContext context, WorkingHourViewModel viewModel) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 100),
      // decoration: BoxDecoration(
      //   color: AppPalette.textSecondary.withOpacity(0.1),
      //   borderRadius: BorderRadius.circular(12),
      // ),

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
            'Save',
            style:
                AppTextStyles.buttonText.copyWith(color: AppPalette.background),
          ),
        ),
      ),
    );
  }
}
