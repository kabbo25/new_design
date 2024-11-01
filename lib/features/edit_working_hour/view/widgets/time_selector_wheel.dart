import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/generated/assets.dart';
import 'package:vibration/vibration.dart';

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
  late AudioPlayer _audioPlayer;
  bool _hasVibrator = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadSound();
    _checkVibrationCapability();
  }

  Future<void> _checkVibrationCapability() async {
    if (widget.enableVibration) {
      print('hello');
      _hasVibrator = await Vibration.hasVibrator() ?? false;
    }
  }

  Future<void> _loadSound() async {
    if (widget.enableSound) {
      try {
        await _audioPlayer.setAsset(Assets.audioTick);
      } catch (e) {
        debugPrint('Error loading sound: $e');
      }
    }
  }

  Future<void> _provideFeedback() async {
    if (widget.enableSound) {
      try {
        _audioPlayer.seek(Duration(milliseconds: 500));
        _audioPlayer.play();
      } catch (e) {
        debugPrint('Error playing sound: $e');
      }
    }

    if (widget.enableVibration && _hasVibrator) {
      try {
        // Different vibration patterns you can try:

        // Option 1: Simple vibration
        Vibration.vibrate(duration: 40);
        debugPrint('ka');
        // Option 2: Haptic feedback (iOS-style)
        //HapticFeedback.heavyImpact();
        //HapticFeedback.selectionClick();
        // Option 3: Custom pattern
        // Vibration.vibrate(
        //   pattern: [0, 30],
        //   intensities: [128], // Intensity from 1-255
        // );
      } catch (e) {
        debugPrint('Error during vibration: $e');
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _buildHourWheel(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            ':',
            style: AppTextStyles.heading2,
          ),
        ),
        Expanded(
          child: _buildMinuteWheel(),
        ),
        SizedBox(
          width: 80,
          child: _buildPeriodWheel(),
        ),
      ],
    );
  }

  Widget _buildWheelItem(
      String text, bool isSelected, int index, int totalItems) {
    if (isSelected) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.heading2,
        ),
      );
    }

    // Calculate the relative position from the center
    final itemPosition = index / totalItems;
    final distanceFromCenter = (itemPosition - 0.5).abs() * 2;

    // Calculate the transformation angle based on position
    final angle = (distanceFromCenter * math.pi / 4.5);

    // Create perspective transform matrix
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective
      ..rotateX(angle);

    // Calculate opacity based on distance from center
    final opacity = 1.0 - (distanceFromCenter * 0.6);

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.subtitle1.copyWith(
            color: AppPalette.textSecondary.withOpacity(opacity),
          ),
        ),
      ),
    );
  }

  Widget _buildHourWheel() {
    // Generate list with padding items for circular effect
    List<String> hours = [
      ...List.generate(
          3,
          (index) => (12 - (2 - index))
              .toString()
              .padLeft(2, '0')), // Add 10,11,12 before 1
      ...List.generate(
          12, (index) => (index + 1).toString().padLeft(2, '0')), // 1-12
      ...List.generate(
          3,
          (index) =>
              (index + 1).toString().padLeft(2, '0')), // Add 1,2,3 after 12
    ];

    final initialIndex = widget.initialTime.hourOfPeriod == 12
        ? 2
        : widget.initialTime.hourOfPeriod + 2;

    return ListWheelScrollView.useDelegate(
      itemExtent: widget.itemExtent,
      diameterRatio: 2.0,
      perspective: 0.005,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: initialIndex),
      onSelectedItemChanged: (index) {
        final adjustedIndex = index - 2; // Adjust for padding items
        final hour = ((adjustedIndex - 1) % 12) + 1; // Convert to 1-12 range
        final isPM = widget.initialTime.period == DayPeriod.pm;
        final actualHour =
            isPM ? (hour == 12 ? 12 : hour + 12) : (hour == 12 ? 0 : hour);
        widget.onSelectedTimeChanged(
            TimeOfDay(hour: actualHour, minute: widget.initialTime.minute));
      },
      childDelegate: ListWheelChildLoopingListDelegate(
        children: hours.map((hour) {
          final parsedHour = int.parse(hour);
          final isSelected = parsedHour == widget.initialTime.hourOfPeriod;
          return Container(
            alignment: Alignment.center,
            child: Text(
              hour,
              style: isSelected
                  ? AppTextStyles.heading2
                  : AppTextStyles.subtitle1.copyWith(
                      color: AppPalette.textSecondary.withOpacity(0.5),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMinuteWheel() {
    List<String> minutes = [
      ...List.generate(
          3, (index) => (60 - (3 - index)).toString().padLeft(2, '0')),
      ...List.generate(60, (index) => index.toString().padLeft(2, '0')),
      ...List.generate(3, (index) => index.toString().padLeft(2, '0')),
    ];

    final initialIndex = widget.initialTime.minute + 3;

    return ListWheelScrollView.useDelegate(
      itemExtent: widget.itemExtent,
      diameterRatio: 3.0,
      perspective: 0.003,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: initialIndex),
      onSelectedItemChanged: (index) {
        final adjustedIndex = (index - 3) % 60;
        widget.onSelectedTimeChanged(
          TimeOfDay(
            hour: widget.initialTime.hour,
            minute: adjustedIndex,
          ),
        );
        _provideFeedback();
      },
      childDelegate: ListWheelChildLoopingListDelegate(
        children: List.generate(minutes.length, (index) {
          final minute = minutes[index];
          final parsedMinute = int.parse(minute) % 60;
          final isSelected = parsedMinute == widget.initialTime.minute;
          return _buildWheelItem(
            parsedMinute.toString().padLeft(2, '0'),
            isSelected,
            index,
            minutes.length,
          );
        }),
      ),
    );
  }

  Widget _buildPeriodWheel() {
    const periods = ['AM', 'PM'];

    return ListWheelScrollView(
      itemExtent: widget.itemExtent,
      diameterRatio: 20.0,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(
        initialItem: widget.initialTime.period == DayPeriod.pm ? 1 : 0,
      ),
      onSelectedItemChanged: (index) {
        final isPM = index == 1;
        final currentHourOfPeriod = widget.initialTime.hourOfPeriod;
        final newHour = isPM ? currentHourOfPeriod + 12 : currentHourOfPeriod;
        widget.onSelectedTimeChanged(TimeOfDay(
          hour: newHour == 24 ? 0 : newHour,
          minute: widget.initialTime.minute,
        ));
      },
      children: periods.map((period) {
        final isSelected =
            period == (widget.initialTime.period == DayPeriod.pm ? 'PM' : 'AM');
        return Container(
          alignment: Alignment.center,
          child: Text(
            period,
            style: isSelected
                ? AppTextStyles.heading2
                : AppTextStyles.subtitle1.copyWith(
                    color: AppPalette.textSecondary.withOpacity(0.5),
                  ),
          ),
        );
      }).toList(),
    );
  }
}
