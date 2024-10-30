import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/features/edit_working_hour/view/pages/last_working_day_modal.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/bottom_gradient.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/start_page/view/widgets/network_status_bar.dart';
import 'package:new_design/features/start_working/view/widgets/finish_working_button.dart';
import 'package:new_design/features/start_working/view/widgets/start_working_hour_card.dart';
import 'package:new_design/features/start_working/view/widgets/timer_section.dart';
import 'package:new_design/features/start_working/view/widgets/working_location_change_button.dart';
import 'package:new_design/features/start_working/viewmodel/start_working_view_model.dart';
import 'package:provider/provider.dart';

class StartWorkingPage extends StatelessWidget {
  const StartWorkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StartWorkingViewModel(),
      child: const StartWorkingView(),
    );
  }
}

class StartWorkingView extends StatelessWidget {
  const StartWorkingView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StartWorkingViewModel>();
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
                    child: WorkingStatusCard(
                      startWorkingHour: viewModel.startWorkingHour,
                      onEdit: () => _showStartWorking(context),
                    ),
                  ),
                  const Spacer(),
                  const TimerSection(),
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
                                SlidableButton(onSlideComplete: () async {
                                  developer.log('slide complete');
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (context.mounted) {
                                    context.pushNamed(
                                      'finish_working',
                                      extra: {
                                        //'wifiName': wifiName.toLowerCase(),
                                        //'startedWorkingTime': startedWorkingTime,
                                        'workMode': WorkMode.ending,
                                      },
                                    );
                                  }
                                }),
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

void _showStartWorking(BuildContext context) {
  developer.log('calling modal');
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TimePickerModal(
      title: 'Edit  your entry time',
      editTimeLabel: 'Edit your entry time here:',
      initialTime: const TimeOfDay(hour: 15, minute: 0),
      showWorkingHourSelector: false,
      onSave: (newTime) {
        developer.log('calling');
        // Handle save
      },
    ),
  );
}
