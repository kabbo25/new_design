import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(24),
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
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          const Text(
            'Please turn on your wifi and connect to any DSi network to confirm your presence at DSi premises.',
            style: AppTextStyles.subtitle1,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : onVerifyNetwork,
            style: AppButtonStyles.elevatedButton,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppPalette.background),
                    ),
                  )
                : Text(
                    'Verify Network',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppPalette.background,
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
