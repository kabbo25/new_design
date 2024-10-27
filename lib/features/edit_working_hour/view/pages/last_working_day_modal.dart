import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/working_hour_viewmodel.dart';
import '../widgets/time_selector_wheel.dart';
import '../widgets/time_type_selector.dart';

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

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          TimeTypeSelector(
            isStartTime: viewModel.isStartTime,
            onStartTimeSelected: () => viewModel.toggleTimeType(),
            onEndTimeSelected: () => viewModel.toggleTimeType(),
          ),
          const Gap(24),
          Text(
            viewModel.isStartTime
                ? 'Edit your entry time here:'
                : 'Edit your exit time here:',
            style: AppTextStyles.subtitle1,
          ),
          _buildTimeWheels(context, viewModel),
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
            color: AppPalette.textSecondary,
            width: 3,
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

  Widget _buildTimeWheels(
      BuildContext context, WorkingHourViewModel viewModel) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimeSelectorWheel(
            items: List.generate(12, (i) => '${i + 1}'),
            onSelectedItemChanged: (index) => viewModel.updateTime(
              index + 1,
              viewModel.selectedTime.minute,
              viewModel.selectedTime.period == DayPeriod.pm,
            ),
            initialItem: viewModel.selectedTime.hourOfPeriod - 1,
          ),
          TimeSelectorWheel(
            items: List.generate(12, (i) => (i * 5).toString().padLeft(2, '0')),
            onSelectedItemChanged: (index) => viewModel.updateTime(
              viewModel.selectedTime.hour,
              index * 5,
              viewModel.selectedTime.period == DayPeriod.pm,
            ),
            initialItem: viewModel.selectedTime.minute ~/ 5,
          ),
          TimeSelectorWheel(
            items: const ['AM', 'PM'],
            onSelectedItemChanged: (index) => viewModel.updateTime(
              viewModel.selectedTime.hourOfPeriod,
              viewModel.selectedTime.minute,
              index == 1,
            ),
            initialItem: viewModel.selectedTime.period == DayPeriod.pm ? 1 : 0,
          ),
        ],
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
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPalette.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
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
