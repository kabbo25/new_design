// lib/features/attendance/view/widgets/timer_section.dart
import 'package:flutter/material.dart';

class TimerSection extends StatelessWidget {
  const TimerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Elapsed time',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
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
