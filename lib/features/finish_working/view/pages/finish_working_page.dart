import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/add_note_modal.dart';
import 'package:new_design/features/finish_working/view/widgets/location_bottom_sheet.dart';
import 'package:new_design/features/finish_working/view/widgets/network_profile_bar.dart';
import 'package:new_design/features/finish_working/view/widgets/working_status_card.dart';
import 'package:new_design/features/finish_working/viewmodel/finish_working_view_model.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/start_working/view/widgets/timer_section.dart';
import 'package:provider/provider.dart';

class FinishWorkingPage extends StatelessWidget {
  final WorkMode workMode;

  const FinishWorkingPage({
    super.key,
    required this.workMode,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinishWorkingViewModel(workMode: workMode),
      child: const FinishWorkingView(),
    );
  }
}

class FinishWorkingView extends StatelessWidget {
  const FinishWorkingView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FinishWorkingViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // network status bar with circle avatar
                  const NetworkProfileBar(),
                  const SizedBox(height: 20),

                  // start working card
                  WorkingStatusCard(
                    workingStatus: viewModel.workingStatus,
                    onEdit: () => (),
                  ),
                  const Gap(12),
                  // finished working card
                  WorkingStatusCard(
                    workingStatus: viewModel.workingStatus,
                    onEdit: () => (),
                  ),
                  const Gap(12),
                  // My locations card
                  MyLocationsCard(
                    locations: viewModel.locations,
                    onLocationSelected: (location) {
                      viewModel.updateLocation(location);
                    },
                  ),
                  const Spacer(),
                  const TimerSection(),

                  // Timer section

                  // if any note added, it will appear here

                  // add a note elevated button
                  TextButton(
                    onPressed: () => _showAddNoteModal(context, viewModel),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Add a note',
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '👋 See you tomorrow!',
                    style: AppTextStyles.heading2,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      'Work Again',
                      style: AppTextStyles.customStyle(
                        AppTextStyles.subtitle1,
                        color: AppPalette.primary,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Stack(
                    children: [
                      BottomNavigationSection(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAddNoteModal(BuildContext context, FinishWorkingViewModel viewModel) {
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
        onSaveNote: (note) {
          viewModel.updateNote(note);
        },
      ),
    ),
  );
}
