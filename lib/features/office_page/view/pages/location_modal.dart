import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/theme/app_button_styles.dart';
import 'package:new_design/theme/app_palette.dart';
import 'package:new_design/theme/app_text_styles.dart';

class LocationModal extends StatelessWidget {
  final VoidCallback onFindLocation;
  final bool isLoading;

  const LocationModal({
    super.key,
    required this.onFindLocation,
    this.isLoading = false,
  });

  // void _handleFindLocation(BuildContext context) async {
  //   // Close current modal
  //   Navigator.pop(context);

  //   // Show loading modal
  //   await showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     isDismissible: false,
  //     builder: (context) => const LoadingModal(),
  //   );

  //   // Call the original onFindLocation callback
  //   onFindLocation();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppPalette.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  'Tell us where',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Gap(20),
          Container(
              width: double.infinity,
              height: 2,
              color: AppPalette.textSecondary.withOpacity(0.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(24),
                Text(
                  'To record where the meeting is being held, location needs to be turned on\nPress on the button below to continue.',
                  style: AppTextStyles.customStyle(
                    AppTextStyles.subtitle1,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const Gap(24),
                ElevatedButton(
                  onPressed: () => onFindLocation(),
                  style: AppButtonStyles.elevatedButton,
                  child: Text(
                    'Find Me',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppPalette.background,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
