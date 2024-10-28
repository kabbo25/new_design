import 'package:flutter/material.dart';
import 'package:new_design/features/start_page/view/widgets/background_widget.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/start_page/view/widgets/network_status_bar.dart';
import 'package:new_design/features/start_working/view/widgets/finish_working_button.dart';
import 'package:new_design/features/start_working/view/widgets/location_selector.dart';
import 'package:new_design/features/start_working/view/widgets/start_working_hour_card.dart';
import 'package:new_design/features/start_working/view/widgets/timer_section.dart';
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const NetworkStatusBar(),
                  const SizedBox(height: 20),
                  WorkingStatusCard(
                    startWorkingHour: viewModel.startWorkingHour,
                    onEdit: () => () {},
                  ),
                  const TimerSection(),
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
                          const FinishWorkingButton(),
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
