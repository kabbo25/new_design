import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/finish_working/view/widgets/outside_meeting_list/outside_meeting_list.dart';

class OutsideMeetingsCard extends StatelessWidget {
  final List<OutsideMeeting> meetings;
  final Function(OutsideMeeting) onLocationSelected;

  const OutsideMeetingsCard({
    super.key,
    required this.meetings,
    required this.onLocationSelected,
  });

  void _showOutsideMeetingsList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OutsideMeetingList(
          meetings: meetings, onMeetingUpdated: onLocationSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = meetings.isNotEmpty;
    developer.log(isEnabled.toString());
    return GestureDetector(
      onTap: isEnabled ? () => _showOutsideMeetingsList(context) : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Locations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: isEnabled ? Colors.black : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
