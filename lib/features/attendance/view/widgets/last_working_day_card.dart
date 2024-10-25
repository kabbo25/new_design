import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../generated/assets.dart';
import '../../../../theme/app_decorations.dart';
import '../../../../theme/app_text_styles.dart';
import '../../model/last_working_day.dart';

class LastWorkingDayCard extends StatelessWidget {
  final LastWorkingDay lastWorkingDay;
  final VoidCallback onEdit;

  const LastWorkingDayCard({
    super.key,
    required this.lastWorkingDay,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.borderDecoration,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Last working day', style: AppTextStyles.heading2),
              const SizedBox(height: 4),
              Text(
                '${lastWorkingDay.location} • ${_formatDate(lastWorkingDay.date)} • ${_formatTime(lastWorkingDay.time)}',
                style: AppTextStyles.subtitle2,
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: onEdit,
            child: Row(
              children: [
                SvgPicture.asset(Assets.svgsEdit),
                const Gap(8),
                Text('Edit', style: AppTextStyles.buttonText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }
}
