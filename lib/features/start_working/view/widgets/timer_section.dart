// lib/features/attendance/view/widgets/timer_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/generated/assets.dart';

class TimerSection extends StatelessWidget {
  const TimerSection({super.key});

  @override
  Widget build(BuildContext context) {
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
            _buildTimeSegment('00'),
            _buildSeparator(),
            _buildTimeSegment('01'),
            _buildSeparator(),
            _buildTimeSegment('00'),
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
