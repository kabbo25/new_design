import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../model/attendance_location.dart';
import 'location_option.dart';

class LocationOptionsSection extends StatelessWidget {
  final List<AttendanceLocation> locations;

  const LocationOptionsSection({
    super.key,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: locations.map((location) {
        return Column(
          children: [
            LocationOption(
              location: location,
              onTap: () {},
            ),
            const Gap(16),
          ],
        );
      }).toList(),
    );
  }
}
