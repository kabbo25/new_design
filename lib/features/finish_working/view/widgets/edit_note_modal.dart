import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/note.dart';
import 'package:new_design/features/finish_working/view/widgets/add_note_modal.dart';
import 'package:new_design/generated/assets.dart';

class EditNoteModal extends StatefulWidget {
  final Note? initialNote;
  final Function(Note) onEdit;

  const EditNoteModal({
    super.key,
    this.initialNote,
    required this.onEdit,
  });

  @override
  State<EditNoteModal> createState() => _EditNoteModalState();
}

class _EditNoteModalState extends State<EditNoteModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildEditButton() {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled:
              true, // This ensures the modal can expand to full height if needed
          backgroundColor: Colors.transparent,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddNoteModal(
              onSaveNote: widget.onEdit,
              initialNote: widget.initialNote,
            ),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.svgsEdit),
          const Gap(8),
          Text(
            'Edit',
            style: AppTextStyles.customStyle(
              AppTextStyles.subtitle1,
              color: AppPalette.primary,
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final isEditing = widget.initialNote != null;

    return Container(
      padding: const EdgeInsets.only(top: 24),
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Note',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Gap(12),
          const Divider(),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppPalette.textPrimary.withOpacity(0.1),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.initialNote?.content ?? 'No Note foung',
                            style: AppTextStyles.customStyle(
                              AppTextStyles.subtitle1,
                              color: AppPalette.textPrimary,
                              weight: FontWeight.w400,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(12),
                        _buildEditButton(),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: AppButtonStyles.elevatedButton,
                    child: Text(
                      'Back',
                      style: AppTextStyles.subtitle1.copyWith(
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
