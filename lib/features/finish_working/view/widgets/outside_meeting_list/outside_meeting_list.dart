import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_decorations.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/finish_working/view/widgets/outside_meeting_list/outside_meeting_list_item.dart';

class OutsideMeetingList extends StatelessWidget {
  final List<OutsideMeeting> meetings;

  const OutsideMeetingList({
    super.key,
    required this.meetings,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildMeetingsList(scrollController, context),
          // _buildBottomIndicator(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Center(
          child: Text(
            'Outside Meetings',
            style: AppTextStyles.heading2,
          ),
        ),
        const Gap(12),
        AppDecorations.modalDivider,
        const Gap(12),
      ],
    );
  }

  Widget _buildMeetingsList(
      ScrollController scrollController, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Scrollbar(
        controller: scrollController,
        thickness: 4,
        radius: const Radius.circular(2),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: meetings
                .map(
                  (meeting) => OutsideMeetingListItem(
                    meeting: meeting,
                    onTap: () => Navigator.pop(context),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
