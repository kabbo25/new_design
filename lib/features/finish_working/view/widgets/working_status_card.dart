import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/generated/assets.dart';

class WorkingStatusCard extends StatelessWidget {
  final WorkingStatus workingStatus;
  final VoidCallback onEdit;

  const WorkingStatusCard({
    super.key,
    required this.workingStatus,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isStarting = workingStatus.workMode == WorkMode.starting;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatTime(workingStatus.time),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //const Gap(4),
                Text(
                  '${isStarting ? 'Started' : 'Finished'} working • ${workingStatus.location}',
                  style: AppTextStyles.subtitle2,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.svgsEdit,
                ),
                const Gap(8),
                const Text(
                  'Edit',
                  style: AppTextStyles.buttonText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute $period';
  }
}
