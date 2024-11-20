import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/core/common_feature/widgets/edit_working_hour.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/bottom_gradient.dart';
import 'package:new_design/features/finish_working/view/widgets/working_status_card.dart';
import 'package:new_design/features/finish_working/viewmodel/finish_working_view_model.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/start_page/view/widgets/network_status_bar.dart';
import 'package:new_design/features/start_working/view/widgets/finish_working_button.dart';
import 'package:new_design/features/start_working/view/widgets/timer_section.dart';
import 'package:new_design/features/start_working/view/widgets/working_location_change_button.dart';
import 'package:new_design/features/start_working/viewmodel/start_working_view_model.dart';
import 'package:provider/provider.dart';

class StartWorkingPage extends StatelessWidget {
  const StartWorkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StartWorkingViewModel()),
        ChangeNotifierProvider(create: (_) => FinishWorkingViewModel()),
      ],
      child: const StartWorkingView(),
    );
  }
}

class StartWorkingView extends StatelessWidget {
  const StartWorkingView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StartWorkingViewModel>();
    final finishWorkingViewModel = context.watch<FinishWorkingViewModel>();
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NetworkStatusBar(),
                  const Gap(24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: [
                        WorkingStatusCard(
                          workingStatus: viewModel.startingStatus ??
                              viewModel.workingStatus,
                          onEdit: () => _showWorkingTimeDialog(
                              context, WorkMode.starting),
                        ),
                        if (viewModel.isLoading)
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
                  ),
                  const Spacer(),
                  TimerSection(
                    controller: viewModel.timeTrackingViewModel.timerController,
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      Positioned.fill(
                        child:
                            BottomGradient(config: viewModel.backgroundConfig),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                LocationOptionsSection(
                                  locations: viewModel.locationOptions,
                                ),
                                SlidableButton(
                                  onSlideComplete: () async {
                                    final DateTime exactTime = DateTime.now();
                                    developer.log('slide complete');
                                    final int elapsedSeconds = viewModel
                                        .timeTrackingViewModel
                                        .timerController
                                        .elapsed
                                        .inSeconds;
                                    await viewModel
                                        .saveElapsedTime(elapsedSeconds);
                                    developer.log(
                                        'Elapsed seconds: $elapsedSeconds');
                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    if (context.mounted) {
                                      finishWorkingViewModel
                                          .updateFinishWorkingStatusTime(
                                              exactTime);

                                      context.pushNamed(
                                        'finish_working',
                                        extra: {
                                          'workMode': WorkMode.ending,
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Gap(24),
                          const BottomNavigationSection(),
                        ],
                      ),
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

void _showWorkingTimeDialog(BuildContext context, WorkMode mode) {
  final viewModel = Provider.of<StartWorkingViewModel>(context, listen: false);

  final config = switch (mode) {
    WorkMode.starting => (
        title: 'Edit your entry time',
        label: 'Edit your entry time here:',
        status: viewModel.startingStatus ?? viewModel.workingStatus,
      ),
    WorkMode.ending => (
        title: 'Edit your exit time',
        label: 'Edit your exit time here:',
        status: viewModel.finishingStatus ?? viewModel.workingStatus,
      ),
  };

  WorkingTimePickerDialog.show(
      context: context,
      title: config.title,
      editTimeLabel: config.label,
      currentStatus: config.status,
      onStatusSaved: (updatedStatus) => {
            viewModel.saveWorkingStatus(updatedStatus),
          });
}
