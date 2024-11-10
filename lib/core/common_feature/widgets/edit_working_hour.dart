import 'dart:developer' as developer;

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:new_design/features/edit_working_hour/view/pages/last_working_day_modal.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';

class WorkingTimePickerDialog extends StatelessWidget {
  final String title;
  final String editTimeLabel;
  final WorkingStatus currentStatus;
  final Function(WorkingStatus) onStatusSaved;
  final bool showWorkingHourSelector;

  const WorkingTimePickerDialog({
    super.key,
    required this.title,
    required this.editTimeLabel,
    required this.currentStatus,
    required this.onStatusSaved,
    this.showWorkingHourSelector = false,
  });

  void _showAwesomeSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _handleTimeSave(BuildContext context, TimeOfDay newTime) async {
    developer
        .log('Saving working status with time: ${newTime.format(context)}');
    try {
      final updatedStatus = WorkingStatus(
        id: currentStatus.id,
        location: currentStatus.location,
        workMode: currentStatus.workMode,
        time: newTime,
      );

      // Call the callback to save the status
      await onStatusSaved(updatedStatus);

      if (context.mounted) {
        _showAwesomeSnackbar(
          context: context,
          title: 'Success!',
          message: 'Working time has been saved successfully',
          contentType: ContentType.success,
        );
      }
    } catch (e) {
      developer.log('Error saving working status: $e');
      if (context.mounted) {
        _showAwesomeSnackbar(
          context: context,
          title: 'Error!',
          message: 'Failed to save working time. Please try again.',
          contentType: ContentType.failure,
        );
      }
    }
  }

  static void show({
    required BuildContext context,
    required String title,
    required String editTimeLabel,
    required WorkingStatus currentStatus,
    required Function(WorkingStatus) onStatusSaved,
    bool showWorkingHourSelector = false,
  }) {
    developer.log('Showing time picker modal');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkingTimePickerDialog(
        title: title,
        editTimeLabel: editTimeLabel,
        currentStatus: currentStatus,
        onStatusSaved: onStatusSaved,
        showWorkingHourSelector: showWorkingHourSelector,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TimePickerModal(
      title: title,
      editTimeLabel: editTimeLabel,
      initialTime: currentStatus.time,
      showWorkingHourSelector: showWorkingHourSelector,
      onSave: (newTime) => _handleTimeSave(context, newTime),
    );
  }
}
