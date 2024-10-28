import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';

class AddNoteModal extends StatefulWidget {
  final Function(String) onSaveNote;
  final bool isLoading;

  const AddNoteModal({
    super.key,
    required this.onSaveNote,
    this.isLoading = false,
  });

  @override
  State<AddNoteModal> createState() => _AddNoteModalState();
}

class _AddNoteModalState extends State<AddNoteModal> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  'Add a note',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Gap(12),
          Container(
            width: double.infinity,
            height: 2,
            color: AppPalette.textSecondary.withOpacity(0.5),
          ),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Please write your note here:',
                  style: AppTextStyles.customStyle(
                    AppTextStyles.subtitle1,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppPalette.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write here',
                    ),
                  ),
                ),
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ElevatedButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            widget.onSaveNote(_noteController.text);
                            Navigator.pop(context);
                          },
                    style: AppButtonStyles.elevatedButton,
                    child: Text(
                      'Save',
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppPalette.background,
                      ),
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
