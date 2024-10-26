import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gif_view/gif_view.dart';
import 'package:new_design/generated/assets.dart';
import 'package:new_design/theme/app_button_styles.dart';
import 'package:new_design/theme/app_palette.dart';
import 'package:new_design/theme/app_text_styles.dart';

class LocationConfirmationWrapper extends StatelessWidget {
  final String address;
  final VoidCallback onTryAgain;
  final VoidCallback onNext;

  const LocationConfirmationWrapper({
    super.key,
    required this.address,
    required this.onTryAgain,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return LocationConfirmationModal(
      address: address,
      onTryAgain: onTryAgain,
      onNext: onNext,
    );
  }
}

class LocationConfirmationModal extends StatelessWidget {
  final String address;
  final VoidCallback onTryAgain;
  final VoidCallback onNext;

  const LocationConfirmationModal({
    super.key,
    required this.address,
    required this.onTryAgain,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppPalette.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text(
              'Location Found',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(20),
          Container(
              width: double.infinity,
              height: 2,
              color: AppPalette.textSecondary.withOpacity(0.5)),
          const Gap(20),
          Center(
            child: GifView.asset(
              Assets.gifWifiConnected, // Make sure to add this asset
              height: 120,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              address,
              style: AppTextStyles.customStyle(
                AppTextStyles.subtitle1,
                weight: FontWeight.w600,
                color: AppPalette.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: onTryAgain,
            style: AppButtonStyles.textButton,
            child: Text(
              'Try Again',
              style: AppTextStyles.customStyle(
                AppTextStyles.subtitle1,
                color: AppPalette.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
            child: ElevatedButton(
              onPressed: onNext,
              style: AppButtonStyles.elevatedButton,
              child: Text(
                'Next',
                style: AppTextStyles.customStyle(
                  AppTextStyles.subtitle1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
