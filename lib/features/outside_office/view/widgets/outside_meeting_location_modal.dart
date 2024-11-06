import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/common_feature/widgets/toastify.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_decorations.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';

class OutsideMeetingLocationModal extends StatefulWidget {
  final String location;
  final Function(String, String) onSave;
  final bool isLoading;
  final String? initialPlace;
  final String? initialPurpose;

  const OutsideMeetingLocationModal({
    super.key,
    required this.location,
    required this.onSave,
    this.isLoading = false,
    this.initialPlace,
    this.initialPurpose,
  });

  @override
  State<OutsideMeetingLocationModal> createState() =>
      _OutsideMeetingLocationModal();
}

class _OutsideMeetingLocationModal extends State<OutsideMeetingLocationModal> {
  late final TextEditingController _meetingPlaceController;
  late final TextEditingController _meetingPurposeController;

  @override
  void initState() {
    super.initState();
    _meetingPlaceController =
        TextEditingController(text: widget.initialPlace ?? '');
    _meetingPurposeController =
        TextEditingController(text: widget.initialPurpose ?? '');
  }

  @override
  void dispose() {
    _meetingPlaceController.dispose();
    _meetingPurposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
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
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Text(
              'Save Location',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(12),
          AppDecorations.modalDivider,
          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Location', style: AppTextStyles.title),
                Text(
                  widget.location,
                  style: AppTextStyles.subtitle2
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const Gap(16),
                Text(
                  'Meeting Place',
                  style: AppTextStyles.customStyle(
                    AppTextStyles.subtitle1,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppPalette.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _meetingPlaceController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write here',
                    ),
                  ),
                ),
                const Gap(16),
                Text(
                  'Meeting Purpose',
                  style: AppTextStyles.customStyle(
                    AppTextStyles.subtitle1,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppPalette.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _meetingPurposeController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write here',
                    ),
                  ),
                ),
                const Gap(24),
                ElevatedButton(
                  onPressed: widget.isLoading
                      ? null
                      : () {
                          widget.onSave(
                            _meetingPlaceController.text,
                            _meetingPurposeController.text,
                          );
                          Navigator.pop(context);
                          ToastOverlay.show(
                            context,
                            message: "New Meeting Added Successfully",
                            duration: const Duration(seconds: 3),
                          );
                        },
                  style: AppButtonStyles.elevatedButton,
                  child: Text(
                    'Save',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppPalette.background,
                    ),
                  ),
                ),
                const Gap(12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Discard',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppPalette.textPrimary,
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
