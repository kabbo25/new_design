// outside_meeting_list.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_decorations.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/finish_working/view/widgets/outside_meeting_list/outside_meeting_list_item.dart';
import 'package:new_design/features/outside_office/view/widgets/animated_list.dart';

class OutsideMeetingList extends StatelessWidget {
  final List<OutsideMeeting> meetings;
  final Function(OutsideMeeting) onMeetingUpdated;

  const OutsideMeetingList({
    super.key,
    required this.meetings,
    required this.onMeetingUpdated,
  });

  Widget _buildMeetingItem(
      OutsideMeeting meeting, double opacity, bool isLast) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: OutsideMeetingListItem(
            meeting: meeting,
            onTap: () {},
            onEdit: onMeetingUpdated,
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: const Color(0XFFE8E8E8).withOpacity(0.5),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Center(
          child: Text(
            'My locations',
            style: AppTextStyles.heading2,
          ),
        ),
        const Gap(12),
        AppDecorations.modalDivider,
        const Gap(24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          AnimatedScrollList<OutsideMeeting>(
            items: meetings,
            maxHeight: MediaQuery.of(context).size.height * 0.25,
            itemHeight: 100,
            // debug: true,
            itemBuilder: (meeting, opacity) => _buildMeetingItem(
              meeting,
              opacity,
              meetings.indexOf(meeting) == meetings.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}
