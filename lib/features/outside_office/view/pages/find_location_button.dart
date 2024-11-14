// widgets/find_location_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/generated/assets.dart';

class FindLocationButton extends StatelessWidget {
  final Function() onPressed;

  const FindLocationButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: AppButtonStyles.textButton,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: SvgPicture.asset(
              Assets.svgsFindMyLocation,
              height: 16,
            ),
          ),
          const Gap(8),
          Text(
            'Find My Location',
            style: AppTextStyles.customStyle(
              AppTextStyles.title,
              color: AppPalette.primary,
            ),
          ),
        ],
      ),
    );
  }
}
