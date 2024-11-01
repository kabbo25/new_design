import 'package:flutter/material.dart';
import 'package:new_design/core/servies/wheeler_feedback_service.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/edit_working_hour/view/widgets/hour_wheel.dart';
import 'package:new_design/features/edit_working_hour/view/widgets/minute_wheel.dart';
import 'package:new_design/features/edit_working_hour/view/widgets/period_wheel.dart';

class TimeSelectorWheel extends StatefulWidget {
  final TimeOfDay initialTime;
  final double itemExtent;
  final Function(TimeOfDay) onSelectedTimeChanged;
  final bool enableSound;
  final bool enableVibration;

  const TimeSelectorWheel({
    super.key,
    required this.initialTime,
    this.itemExtent = 50,
    required this.onSelectedTimeChanged,
    this.enableSound = true,
    this.enableVibration = true,
  });

  @override
  State<TimeSelectorWheel> createState() => _TimeSelectorWheelState();
}

class _TimeSelectorWheelState extends State<TimeSelectorWheel> {
  late final FeedbackService _feedbackService;

  @override
  void initState() {
    super.initState();
    _feedbackService = FeedbackService(
      enableSound: widget.enableSound,
      enableVibration: widget.enableVibration,
    );
  }

  @override
  void dispose() {
    _feedbackService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildSelectionOverlay(),
        _buildWheels(),
      ],
    );
  }

  Widget _buildSelectionOverlay() {
    return Positioned.fill(
      child: Center(
        child: Container(
          height: widget.itemExtent,
          decoration: BoxDecoration(
            color: AppPalette.textSecondary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildWheels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: HourWheel(
            initialTime: widget.initialTime,
            itemExtent: widget.itemExtent,
            onChanged: _onTimeChanged,
            onSelectionChanged: _feedbackService.provideFeedback,
          ),
        ),
        Expanded(
          child: MinuteWheel(
            initialTime: widget.initialTime,
            itemExtent: widget.itemExtent,
            onChanged: _onTimeChanged,
            onSelectionChanged: _feedbackService.provideFeedback,
          ),
        ),
        SizedBox(
          width: 80,
          child: PeriodWheel(
            initialTime: widget.initialTime,
            itemExtent: widget.itemExtent,
            onChanged: _onTimeChanged,
            onSelectionChanged: _feedbackService.provideFeedback,
          ),
        ),
      ],
    );
  }

  void _onTimeChanged(TimeOfDay newTime) {
    widget.onSelectedTimeChanged(newTime);
  }
}
