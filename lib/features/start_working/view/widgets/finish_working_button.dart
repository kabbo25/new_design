import 'package:flutter/material.dart';
import 'package:new_design/core/theme/app_palette.dart';

class FinishWorkingButton extends StatelessWidget {
  const FinishWorkingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Finish Working',
          style: TextStyle(
            color: AppPalette.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
