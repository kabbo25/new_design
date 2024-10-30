import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_decorations.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/generated/assets.dart';

class MeetingLocation {
  final String title;
  final String location;
  final String time;

  MeetingLocation({
    required this.title,
    required this.location,
    required this.time,
  });
}

class LocationsBottomSheet extends StatelessWidget {
  final List<MeetingLocation> meetings;

  const LocationsBottomSheet({
    super.key,
    required this.meetings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'My locations',
              style: AppTextStyles.heading2,
            ),
          ),
          const Gap(12),
          AppDecorations.modalDivider,
          const Gap(12),
          ...meetings.map(
            (meeting) => GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meeting.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                meeting.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            style: AppButtonStyles.textButton,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  Assets.svgsEdit,
                                ),
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
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          meeting.time,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 5,
            width: 50,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.4,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ],
      ),
    );
  }
}

class MyLocationsCard extends StatelessWidget {
  final List<String> locations;
  final Function(String)? onLocationSelected;

  MyLocationsCard({
    super.key,
    required this.locations,
    this.onLocationSelected,
  });
  final meetings = [
    MeetingLocation(
      title: 'Requirement gathering IPEMIS',
      location: '36 B, MJ road, Shershah Colony',
      time: '11:00 am',
    ),
    MeetingLocation(
      title: 'Requirement gathering IPEMIS',
      location: '36 B, MJ road, Shershah Colony',
      time: '11:00 am',
    ),
    // Add more meetings...
  ];
  void _showLocationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationsBottomSheet(
        meetings: meetings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = locations.isNotEmpty;

    return GestureDetector(
      onTap: isEnabled ? () => _showLocationsBottomSheet(context) : null,
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
