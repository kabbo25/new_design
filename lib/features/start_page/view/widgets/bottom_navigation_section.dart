import 'package:flutter/material.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/generated/assets.dart';

import 'bottom_nav_item.dart';

class BottomNavigationSection extends StatelessWidget {
  const BottomNavigationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppPalette.background.withOpacity(0.4),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Light shadow
            blurRadius: 100, // Makes the shadow blurry
            offset: const Offset(0, -4), // Moves shadow upward
            spreadRadius: 1, // How much the shadow spreads
          ),
        ],
      ),
      child: const Row(
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
      ),
    );
  }
}
