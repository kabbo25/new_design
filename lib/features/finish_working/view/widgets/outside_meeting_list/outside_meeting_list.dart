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
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildMeetingsList(scrollController, context),
        ],
      ),
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

  Widget _buildMeetingsList(
      ScrollController scrollController, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.25,
      ),
      child: Scrollbar(
        controller: scrollController,
        thickness: 4,
        radius: const Radius.circular(2),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: List.generate(meetings.length, (index) {
              final meeting = meetings[index];
              final isLast = index == meetings.length - 1;

              return Column(
                children: [
                  OutsideMeetingListItem(
                    meeting: meeting,
                    onTap: () => Navigator.pop(context),
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                      child: Container(
                        width: double.infinity,
                        height: 1,
                        color: const Color(0XFFE8E8E8).withOpacity(0.5),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
