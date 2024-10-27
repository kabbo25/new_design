import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';

class NetworkStatusBar extends StatelessWidget {
  const NetworkStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First box (25%)
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ),

        // Middle container (50%)
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: AppPalette.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi, size: 16, color: AppPalette.success),
                  Gap(8),
                  Text(
                    'Connected to DSi network',
                    style: AppTextStyles.subtitle2,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Last box (25%) - empty SizedBox
        // SizedBox(
        //   width: MediaQuery.of(context).size.width * 0.2,
        // ),
      ],
    );
  }
}
