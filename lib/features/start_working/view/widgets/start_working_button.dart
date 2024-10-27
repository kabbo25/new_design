import 'package:flutter/material.dart';

class StartWorkingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isProcessing;

  const StartWorkingButton({
    super.key,
    required this.onPressed,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isProcessing ? null : onPressed,
        child: isProcessing
            ? const CircularProgressIndicator()
            : const Text('Start Working'),
      ),
    );
  }
}
