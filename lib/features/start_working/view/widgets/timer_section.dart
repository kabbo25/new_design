import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/features/finish_working/view/widgets/elapsed_time/elapsed_time_controller.dart';

import 'package:new_design/generated/assets.dart';

import '../../../office_page/view/widgets/flip_animation.dart';

class TimerSection extends StatefulWidget {
  final TimeTrackerController controller;

  const TimerSection({
    super.key,
    required this.controller,
  });

  @override
  State<TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  late final TimeTrackerController _controller;
  String? _previousTime;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_handleControllerUpdate);
  }

  void _handleControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerUpdate);
    super.dispose();
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  String _formatDuration(Duration duration) {
    final hours = _formatNumber(duration.inHours);
    final minutes = _formatNumber(duration.inMinutes.remainder(60));
    final seconds = _formatNumber(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  List<Widget> _buildTimeDigits(String currentTime) {
    final List<Widget> digits = [];
    final previousTimeSegments = _previousTime?.split('') ?? List.filled(8, '0');
    final currentTimeSegments = currentTime.split('');

    for (int i = 0; i < currentTimeSegments.length; i++) {
      if (currentTimeSegments[i] == ':') {
        digits.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      } else {
        digits.add(
          NumberFlip(
            newValue: currentTimeSegments[i],
            previousValue: previousTimeSegments[i],
          ),
        );
      }
    }

    _previousTime = currentTime;
    return digits;
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _controller.elapsed;
    final formattedTime = _formatDuration(elapsed);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.svgsClock01,
              height: 20,
              width: 20,
            ),
            const Gap(4),
            const Text(
              'Elapsed time',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildTimeDigits(formattedTime),
        ),
      ],
    );
  }
}