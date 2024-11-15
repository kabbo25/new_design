import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/note.dart';
import 'package:new_design/features/finish_working/view/widgets/add_note_modal.dart';
import 'package:new_design/generated/assets.dart';

class EditNotesModal extends StatefulWidget {
  final List<Note> notes;
  final Function(Note) onEdit;

  const EditNotesModal({
    super.key,
    required this.notes,
    required this.onEdit,
  });

  @override
  State<EditNotesModal> createState() => _EditNotesModalState();
}

class _EditNotesModalState extends State<EditNotesModal> {
  ScrollController controller = ScrollController();
  double topContainer = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        topContainer = controller.offset /
            120; // Adjust this value to control animation speed
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildEditButton(Note note) {
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
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddNoteModal(
              onSaveNote: widget.onEdit,
              initialNote: note,
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

  Widget _buildNoteCard(Note note, int index) {
    double opacity = 1.0;
    if (topContainer > 0.1) {
      // Changed from 0.5 to 0
      opacity = (index + .7) - topContainer; // Added +1 to include first item
      opacity = opacity.clamp(0.0, 1.0);
    }

    return Opacity(
      opacity: opacity,
      child: Transform(
        transform: Matrix4.identity()..scale(opacity, opacity),
        alignment: Alignment.topCenter,
        child: Align(
          heightFactor: .9,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppPalette.textPrimary.withOpacity(0.1),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: AppPalette.background,
              boxShadow: [
                BoxShadow(
                  color: AppPalette.textPrimary.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    note.content,
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
                _buildEditButton(note),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                  'Notes',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Gap(12),
          const Divider(),
          const Gap(10),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.20, // Maximum 25% of screen height
            ),
            child: ListView.builder(
              shrinkWrap: true,
              controller: controller,
              itemCount: widget.notes.length,
              itemBuilder: (context, index) =>
                  _buildNoteCard(widget.notes[index], index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
    );
  }
}
