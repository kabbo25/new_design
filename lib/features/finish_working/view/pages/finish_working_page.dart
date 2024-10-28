import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/location_bottom_sheet.dart';
import 'package:new_design/features/finish_working/view/widgets/network_profile_bar.dart';
import 'package:new_design/features/finish_working/view/widgets/working_status_card.dart';
import 'package:new_design/features/finish_working/viewmodel/finish_working_view_model.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  // Timer section

                  // if any note added, it will appear here

                  // add a note elevated button

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
