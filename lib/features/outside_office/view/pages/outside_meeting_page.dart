import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/viewmodel/finish_working_view_model.dart';
import 'package:new_design/features/finish_working/viewmodel/timer_tracking_view_model.dart';
import 'package:new_design/features/office_page/viewmodel/location_verification_viewmodel.dart';
import 'package:new_design/features/outside_office/view/pages/common_layout.dart';
import 'package:new_design/features/outside_office/view/pages/find_location_button.dart';
import 'package:new_design/features/outside_office/view/pages/outside_meetings_section.dart';
import 'package:new_design/features/outside_office/view/pages/work_time_dialog.dart';
import 'package:new_design/features/outside_office/view/pages/working_status_section.dart';
import 'package:new_design/features/outside_office/view/widgets/semi_circle.dart';
import 'package:new_design/features/outside_office/view_model/outside_meeting_view_model.dart';
import 'package:new_design/features/start_page/view/widgets/network_status_bar.dart';
import 'package:new_design/features/start_working/view/widgets/finish_working_button.dart';
import 'package:new_design/features/start_working/view/widgets/timer_section.dart';
import 'package:new_design/features/start_working/view/widgets/working_location_change_button.dart';
import 'package:provider/provider.dart';

class OutsideMeetingPage extends StatelessWidget {
  const OutsideMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the shared TimeTrackingViewModel from the parent context
    final timeTrackingViewModel = context.read<TimeTrackingViewModel>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OutsideMeetingViewModel(
            timeTrackingViewModel: timeTrackingViewModel,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationVerificationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => FinishWorkingViewModel(
            timeTrackingViewModel: timeTrackingViewModel,
          ),
        ),
      ],
      child: const OutsideMeetingView(),
    );
  }
}

class OutsideMeetingView extends StatelessWidget {
  const OutsideMeetingView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OutsideMeetingViewModel>();
    final locationVerificationVM =
        Provider.of<LocationVerificationViewModel>(context, listen: false);
    final finishWorkingViewModel = context.watch<FinishWorkingViewModel>();

    return CommonPageLayout(
      backgroundConfig: viewModel.backgroundConfig,
      topSection: [
        const NetworkStatusBar(),
        const Gap(24),
        WorkingStatusSection(
          workingStatus: viewModel.startingStatus ?? viewModel.workingStatus,
          onEdit: () => showWorkingTimeDialog(
            context: context,
            mode: WorkMode.starting,
            currentStatus: viewModel.startingStatus ?? viewModel.workingStatus,
            onStatusSaved: viewModel.saveWorkingStatus,
          ),
          isLoading: viewModel.isLoading,
        ),
        const Gap(12),
        OutsideMeetingsSection(
          meetings: viewModel.locations,
          onLocationSelected: viewModel.updateLocation,
          isLoading: viewModel.ismeetingLoading,
        ),
      ],
      timerSection: Column(
        children: [
          TimerSection(
            controller: viewModel.timeTrackingViewModel.timerController,
          ),
          const Gap(16),
          FindLocationButton(
            onPressed: () async {
              await locationVerificationVM.handleFindLocation(
                context,
                shouldNavigate: false,
              );
            },
          ),
        ],
      ),
      bottomSection: Column(
        children: [
          const SemiCircle(),
          const Gap(8),
          LocationOptionsSection(
            locations: viewModel.locationOptions,
          ),
          SlidableButton(
            onSlideComplete: () async {
              final DateTime exactTime = DateTime.now();
              await Future.delayed(const Duration(seconds: 1));
              if (context.mounted) {
                finishWorkingViewModel.updateFinishWorkingStatusTime(exactTime);
                context.pushNamed(
                  'finish_working',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
