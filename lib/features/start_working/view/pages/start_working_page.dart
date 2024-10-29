import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/start_page/view/widgets/background_widget.dart';
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
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NetworkStatusBar(),
                  const Gap(24),
                  WorkingStatusCard(
                    startWorkingHour: viewModel.startWorkingHour,
                    onEdit: () => () {},
                  ),
                  const Spacer(),
                  const TimerSection(),
                  const Spacer(),
                  Stack(
                    children: [
                      Positioned.fill(
                        child: BackgroundWidget(
                            config: viewModel.backgroundConfig),
                      ),
                      Column(
                        children: [
                          LocationOptionsSection(
                            locations: viewModel.locationOptions,
                          ),
                          SlidableButton(onSlideComplete: () async {
                            developer.log('slide complete');
                            await Future.delayed(const Duration(seconds: 1));
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
