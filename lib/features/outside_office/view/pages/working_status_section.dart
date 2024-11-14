import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/working_status_card.dart';

class WorkingStatusSection extends StatelessWidget {
  final WorkingStatus workingStatus;
  final VoidCallback onEdit;
  final bool isLoading;

  const WorkingStatusSection({
    super.key,
    required this.workingStatus,
    required this.onEdit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          WorkingStatusCard(
            workingStatus: workingStatus,
            onEdit: onEdit,
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.5),
                child: const SpinKitThreeInOut(
                  color: AppPalette.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
