import 'dart:developer' as developer;

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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                meeting.title,
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildLocationInfo(context),
                ),
                _buildEditButton(),
              ],
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                meeting.time,
                style: AppTextStyles.subtitle2.copyWith(
                  color: AppPalette.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: meeting.location,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );

        // Account for the icon and spacing in available width
        final availableWidth =
            constraints.maxWidth - 20; // 16 for icon + 4 for spacing
        textPainter.layout(maxWidth: availableWidth);

        final hasOverflow = textPainter.didExceedMaxLines;
        developer.log(hasOverflow.toString());

        return Row(
          crossAxisAlignment: hasOverflow
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: hasOverflow ? 2.0 : 0.0),
              child: const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey,
              ),
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
                key: ValueKey(
                    'location_${hasOverflow ? 'overflow' : 'normal'}'), // For testing
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditButton() {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
