import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:new_design/core/common_feature/widgets/edit_working_hour.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/add_note_modal.dart';
import 'package:new_design/features/finish_working/view/widgets/bottom_gradient.dart';
import 'package:new_design/features/finish_working/view/widgets/edit_note_modal.dart';
import 'package:new_design/features/finish_working/view/widgets/network_profile_bar.dart';
import 'package:new_design/features/finish_working/view/widgets/outside_meeting_list/outside_meeting_list_dropdown.dart';
import 'package:new_design/features/finish_working/view/widgets/working_status_card.dart';
import 'package:new_design/features/finish_working/viewmodel/finish_working_view_model.dart';
import 'package:new_design/features/finish_working/viewmodel/timer_tracking_view_model.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/start_working/view/widgets/timer_section.dart';
import 'package:new_design/generated/assets.dart';
import 'package:provider/provider.dart';

class FinishWorkingPage extends StatelessWidget {
  final WorkMode workMode;

  const FinishWorkingPage({
    super.key,
    required this.workMode,
  });

  @override
  Widget build(BuildContext context) {
    // Get the shared TimeTrackingViewModel from the parent context
    final timeTrackingViewModel = context.read<TimeTrackingViewModel>();

    return ChangeNotifierProvider(
      create: (_) => FinishWorkingViewModel(
        timeTrackingViewModel: timeTrackingViewModel,
      ),
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
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // network status bar with circle avatar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        const NetworkProfileBar(),
                        const SizedBox(height: 20),

                        // Working status cards
                        WorkingStatusCard(
                          workingStatus: viewModel.startingStatus ??
                              viewModel.startingWorkingStatus,
                          onEdit: () => _showWorkingTimeDialog(
                              context, WorkMode.starting),
                        ),
                        const Gap(12),
                        WorkingStatusCard(
                          workingStatus: viewModel.finishingStatus ??
                              viewModel.finishWorkingStatus,
                          onEdit: () =>
                              _showWorkingTimeDialog(context, WorkMode.ending),
                        ),
                        const Gap(12),
                        Stack(
                          children: [
                            OutsideMeetingsCard(
                              meetings: viewModel.locations,
                              onLocationSelected: (location) {
                                viewModel.updateLocation(location);
                              },
                            ),
                            if (viewModel.ismeetingLoading)
                              const Positioned.fill(
                                child: Center(
                                  child: SpinKitWave(
                                    color: AppPalette.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Timer section
                  //const Spacer(),
                  const Gap(24),
                  TimerSection(
                      controller:
                          viewModel.timeTrackingViewModel.timerController),

                  // Bottom section with gradient
                  //const Spacer(),
                  const Gap(24),
                  Expanded(
                    child: Stack(
                      children: [
                        // Gradient background
                        Positioned.fill(
                          child: BottomGradient(
                              config: viewModel.backgroundConfig),
                        ),

                        //const Gap(30),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildNoteCounter(context, viewModel),
                            TextButton(
                              onPressed: () =>
                                  _showAddNoteModal(context, viewModel),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: Colors.transparent,
                              ),
                              child: Text(
                                'Add a note',
                                style: AppTextStyles.customStyle(
                                  AppTextStyles.heading2,
                                  color: AppPalette.primary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '👋 See you tomorrow!',
                              style: AppTextStyles.heading2,
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {},
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
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
                                const Gap(20),
                                const BottomNavigationSection(),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
        onSaveNote: (note) async {
          await viewModel.saveNote(note);
        },
      ),
    ),
  );
}

void _showWorkingTimeDialog(BuildContext context, WorkMode mode) {
  final viewModel = Provider.of<FinishWorkingViewModel>(context, listen: false);

  final config = switch (mode) {
    WorkMode.starting => (
        title: 'Edit your entry time',
        label: 'Edit your entry time here:',
        status: viewModel.startingStatus ?? viewModel.startingWorkingStatus,
      ),
    WorkMode.ending => (
        title: 'Edit your exit time',
        label: 'Edit your exit time here:',
        status: viewModel.finishingStatus ?? viewModel.finishWorkingStatus,
      ),
  };

  WorkingTimePickerDialog.show(
    context: context,
    title: config.title,
    editTimeLabel: config.label,
    currentStatus: config.status,
    onStatusSaved: (updatedStatus) =>
        viewModel.saveWorkingStatus(updatedStatus),
  );
}

Widget buildNoteCounter(
    BuildContext context, FinishWorkingViewModel viewModel) {
  if (viewModel.noteList.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    children: [
      TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled:
                true, // This ensures the modal can expand to full height if needed
            backgroundColor: Colors.transparent,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: EditNotesModal(
                onEdit: (note) async {
                  viewModel.saveNote(note);
                },
                notes: viewModel.noteList,
              ),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Assets.svgsNote),
            const Gap(8),
            Text(
              '${viewModel.noteList.length} ${viewModel.noteList.length == 1 ? 'Note' : 'Notes'} added',
              style: AppTextStyles.customStyle(
                AppTextStyles.buttonText,
                color: AppPalette.primary,
              ),
            ),
          ],
        ),
      ),
      const Gap(10),
    ],
  );
}
