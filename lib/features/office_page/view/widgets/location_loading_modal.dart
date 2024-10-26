import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:new_design/generated/assets.dart';
import 'package:new_design/theme/app_palette.dart';
import 'package:new_design/theme/app_text_styles.dart';

class LoadingModal extends StatefulWidget {
  final VoidCallback? onDismissed;

  const LoadingModal({super.key, this.onDismissed});

  @override
  State<LoadingModal> createState() => _LoadingModalState();
}

class _LoadingModalState extends State<LoadingModal> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Set up timer to dismiss modal and trigger callback
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted && context.mounted) {
        developer.log('Auto confirmation timer completed, dismissing modal');
        Navigator.pop(context);
        widget.onDismissed?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppPalette.background,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GifView.asset(
                  Assets.gifLocationLoading,
                  width: 200,
                ),
                const Text(
                  'Just a moment...',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
