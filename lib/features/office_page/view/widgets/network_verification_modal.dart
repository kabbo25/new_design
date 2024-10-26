import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/theme/app_button_styles.dart';
import 'package:new_design/theme/app_palette.dart';
import 'package:new_design/theme/app_text_styles.dart';

class NetworkVerificationModal extends StatelessWidget {
  final VoidCallback onVerifyNetwork;
  final VoidCallback onUseGPS;
  final bool isLoading;

  const NetworkVerificationModal({
    super.key,
    required this.onVerifyNetwork,
    required this.onUseGPS,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppPalette.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Verify Network',
            style: AppTextStyles.heading1,
            textAlign: TextAlign.center,
          ),
          const Gap(20),
          Container(
            width: double.infinity,
            height: 2,
            color: AppPalette.textSecondary.withOpacity(0.5),
          ),
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Please turn on your wifi and connect to any DSi network to confirm your presence at DSi premises.',
              style: AppTextStyles.customStyle(
                AppTextStyles.subtitle1,
                color: AppPalette.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: isLoading ? null : onVerifyNetwork,
              style: AppButtonStyles.elevatedButton,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppPalette.background),
                      ),
                    )
                  : Text(
                      'Verify Network',
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppPalette.background,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: isLoading ? null : onUseGPS,
            style: AppButtonStyles.textButton,
            child: const Text(
              'Use GPS instead',
              style: AppTextStyles.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
