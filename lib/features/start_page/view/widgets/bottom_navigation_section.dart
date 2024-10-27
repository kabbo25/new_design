import 'package:flutter/material.dart';

import '../../../../core/generated/assets.dart';
import 'bottom_nav_item.dart';

class BottomNavigationSection extends StatelessWidget {
  const BottomNavigationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BottomNavItem(
          svgPath: Assets.svgsStartPage,
          label: 'Start Page',
          isSelected: false,
        ),
        BottomNavItem(
          svgPath: Assets.svgsAttendence,
          label: 'My Attendance',
          isSelected: false,
        ),
        BottomNavItem(
          svgPath: Assets.svgsSetting,
          label: 'Settings',
          isSelected: false,
        ),
      ],
    );
  }
}
