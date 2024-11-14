import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/finish_working/view/widgets/outside_meeting_list/outside_meeting_list_dropdown.dart';

class OutsideMeetingsSection extends StatelessWidget {
  final List<OutsideMeeting> meetings;
  final Function(OutsideMeeting) onLocationSelected;
  final bool isLoading;

  const OutsideMeetingsSection({
    super.key,
    required this.meetings,
    required this.onLocationSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          OutsideMeetingsCard(
            meetings: meetings,
            onLocationSelected: onLocationSelected,
          ),
          if (isLoading)
            const Positioned.fill(
              child: Center(
                child: SpinKitWave(
                  color: AppPalette.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
