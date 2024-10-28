// NetworkConfirmationModal.dart
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/office_page/viewmodel/network_verification_viewmodel.dart';
import 'package:new_design/generated/assets.dart';
import 'package:provider/provider.dart';

class NetworkConfirmationWrapper extends StatelessWidget {
  final String wifiName;
  final VoidCallback? onDismissed;

  const NetworkConfirmationWrapper({
    super.key,
    required this.wifiName,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NetworkVerificationViewModel(),
      child: NetworkConfirmationModal(
        wifiName: wifiName,
        onDismissed: onDismissed,
      ),
    );
  }
}

class NetworkConfirmationModal extends StatefulWidget {
  final String wifiName;
  final VoidCallback? onDismissed;

  const NetworkConfirmationModal({
    super.key,
    required this.wifiName,
    this.onDismissed,
  });

  @override
  State<NetworkConfirmationModal> createState() =>
      _NetworkConfirmationModalState();
}

class _NetworkConfirmationModalState extends State<NetworkConfirmationModal> {
  @override
  void initState() {
    super.initState();
    _startAutoConfirmation();
  }

  Future<void> _startAutoConfirmation() async {
    developer.log('Starting auto confirmation timer');
    await Future.delayed(const Duration(seconds: 2));
    if (mounted && context.mounted) {
      developer.log('Auto confirmation timer completed, dismissing modal');
      Navigator.pop(context);
      widget.onDismissed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppPalette.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: GifView.asset(
              Assets.gifWifiConnected,
              height: 100,
            ),
          ),
          //const Gap(16),
          SizedBox(
            width: 120,
            //height: 50,
            child: Text(
              widget.wifiName,
              textAlign: TextAlign.left,
              style: AppTextStyles.customStyle(
                AppTextStyles.subtitle1,
                weight: FontWeight.w600,
                color: AppPalette.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          // const Gap(24),
          Text(
            'Network Confirmed',
            style: AppTextStyles.customStyle(
              AppTextStyles.subtitle1,
              color: AppPalette.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// In NetworkVerificationViewModel, update the showModalBottomSheet section:
