import 'package:flutter/material.dart';
import 'package:new_design/core/common_feature/widgets/edit_working_hour.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';

void showWorkingTimeDialog({
  required BuildContext context,
  required WorkMode mode,
  required WorkingStatus currentStatus,
  required Function(WorkingStatus) onStatusSaved,
}) {
  final config = switch (mode) {
    WorkMode.starting => (
        title: 'Edit your entry time',
        label: 'Edit your entry time here:',
      ),
    WorkMode.ending => (
        title: 'Edit your exit time',
        label: 'Edit your exit time here:',
      ),
  };

  WorkingTimePickerDialog.show(
    context: context,
    title: config.title,
    editTimeLabel: config.label,
    currentStatus: currentStatus,
    onStatusSaved: onStatusSaved,
  );
}
