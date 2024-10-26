import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../theme/app_palette.dart';
import '../../../../theme/app_text_styles.dart';

class NetworkStatusBar extends StatelessWidget {
  const NetworkStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            color: AppPalette.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.wifi, size: 16, color: AppPalette.success),
              Gap( 8),
              Text(
                'Connected to DSi network',
                style: AppTextStyles.subtitle2,
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
