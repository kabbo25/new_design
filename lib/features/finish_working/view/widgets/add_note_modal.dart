import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/common_feature/widgets/toastify.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/note.dart';

class AddNoteModal extends StatefulWidget {
  final Function(Note) onSaveNote;
  final bool isLoading;
  final Note? initialNote;

  const AddNoteModal({
    super.key,
    required this.onSaveNote,
    this.isLoading = false,
    this.initialNote,
  });

  @override
  State<AddNoteModal> createState() => _AddNoteModalState();
}

class _AddNoteModalState extends State<AddNoteModal> {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialNote != null) {
      _noteController.text = widget.initialNote!.content;
    }
    // Add this - will focus in both cases
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _focusNode.dispose(); // Add this line
    super.dispose();
  }

  void _handleSave() {
    if (_noteController.text.isEmpty) return;

    final note = widget.initialNote?.copyWith(
          content: _noteController.text,
        ) ??
        Note(content: _noteController.text);

    widget.onSaveNote(note);
    final isEditing = widget.initialNote != null;
    ToastOverlay.show(
      context,
      message:
          isEditing ? 'Note updated successfully' : 'Note saved successfully',
      isUpdate: isEditing,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialNote != null;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  isEditing ? 'Edit note' : 'Add a note',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Gap(12),
          const Divider(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  decoration: BoxDecoration(
                    color: AppPalette.textSecondary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _noteController,
                      focusNode: _focusNode, // Add the focus node here
                      maxLines: 2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write here',
                      ),
                    ),
                  ),
                ),
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ElevatedButton(
                    onPressed: widget.isLoading ? null : _handleSave,
                    style: AppButtonStyles.elevatedButton,
                    child: Text(
                      isEditing ? 'Update' : 'Save',
                      style: AppTextStyles.subtitle2.copyWith(
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
