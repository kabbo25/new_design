import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/generated/assets.dart';

class OutsideMeetingListItem extends StatelessWidget {
  final OutsideMeeting meeting;
  final VoidCallback onTap;

  const OutsideMeetingListItem({
    super.key,
    required this.meeting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meeting.title,
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildLocationInfo(),
                ),
                _buildEditButton(),
              ],
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                meeting.time,
                style: AppTextStyles.title.copyWith(
                  color: AppPalette.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            meeting.location,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Remove padding
        minimumSize: Size.zero, // Remove minimum size constraint
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimize tap target
      ),
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.svgsEdit),
          const Gap(8),
          Text(
            'Edit',
            style: AppTextStyles.customStyle(
              AppTextStyles.subtitle2,
              color: AppPalette.primary,
            ),
          ),
        ],
      ),
    );
  }
}
