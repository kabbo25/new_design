import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/features/finish_working/view/widgets/elapsed_time/elapsed_time_controller.dart';
import 'package:new_design/generated/assets.dart';

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

  @override
  Widget build(BuildContext context) {
    final elapsed = _controller.elapsed;
    final formattedTime = _formatDuration(elapsed);
    final timeSegments = formattedTime.split(':');

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
          children: [
            _buildTimeSegment(timeSegments[0]), // hours
            _buildSeparator(),
            _buildTimeSegment(timeSegments[1]), // minutes
            _buildSeparator(),
            _buildTimeSegment(timeSegments[2]), // seconds
          ],
        ),
      ],
    );
  }

  Widget _buildTimeSegment(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
