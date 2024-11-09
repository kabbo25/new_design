import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/core/theme/app_button_styles.dart';
import 'package:new_design/core/theme/app_palette.dart';
import 'package:new_design/core/theme/app_text_styles.dart';
import 'package:new_design/features/edit_working_hour/view/pages/last_working_day_modal.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/finish_working/view/widgets/bottom_gradient.dart';
import 'package:new_design/features/finish_working/view/widgets/outside_meeting_list/outside_meeting_list_dropdown.dart';
import 'package:new_design/features/finish_working/view/widgets/working_status_card.dart';
import 'package:new_design/features/office_page/viewmodel/location_verification_viewmodel.dart';
import 'package:new_design/features/outside_office/view/widgets/semi_circle.dart';
import 'package:new_design/features/outside_office/view_model/outside_meeting_view_model.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/start_page/view/widgets/network_status_bar.dart';
import 'package:new_design/features/start_working/view/widgets/finish_working_button.dart';
import 'package:new_design/features/start_working/view/widgets/timer_section.dart';
import 'package:new_design/features/start_working/view/widgets/working_location_change_button.dart';
import 'package:new_design/generated/assets.dart';
import 'package:provider/provider.dart';

// Update your OutsideMeetingPage to provide both view models
class OutsideMeetingPage extends StatelessWidget {
  const OutsideMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OutsideMeetingViewModel()),
        ChangeNotifierProvider(create: (_) => LocationVerificationViewModel()),
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
    // Add LocationVerificationViewModel
    final locationVerificationVM =
        Provider.of<LocationVerificationViewModel>(context, listen: false);
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
                  const NetworkStatusBar(),
                  const Gap(24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: [
                        WorkingStatusCard(
                          workingStatus: viewModel.workingStatuses.isEmpty
                              ? viewModel.workingStatus
                              : viewModel.workingStatuses[0],
                          onEdit: () => _showStartWorking(context),
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
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
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
                  ),
                  const Spacer(),
                  const TimerSection(),
                  TextButton(
                    style: AppButtonStyles.textButton,
                    onPressed: () async {
                      // Call _handleFindLocation directly
                      await locationVerificationVM.handleFindLocation(context,
                          shouldNavigate: false);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: SvgPicture.asset(
                            Assets.svgsFindMyLocation,
                            height: 16,
                            // width: 12.52,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Find My Location',
                          style: AppTextStyles.customStyle(
                            AppTextStyles.title,
                            color: AppPalette.primary,
                          ),
                        ),
                      ],
                    ),
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
                                const SemiCircle(),
                                const Gap(8),
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
  final viewModel =
      Provider.of<OutsideMeetingViewModel>(context, listen: false);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TimePickerModal(
      title: 'Edit your entry time',
      editTimeLabel: 'Edit your entry time here:',
      initialTime: const TimeOfDay(hour: 15, minute: 0),
      showWorkingHourSelector: false,
      onSave: (newTime) async {
        developer.log(
            'Saving initial working status with time: ${newTime.format(context)}');
        try {
          final currentStatus = viewModel.workingStatuses.isEmpty
              ? viewModel.workingStatus
              : viewModel.workingStatuses[0];
          developer.log(currentStatus.toJson().toString());
          final updatedStatus = WorkingStatus(
            id: currentStatus.id, // Preserve the existing ID if any
            location: currentStatus.location,
            workMode: currentStatus.workMode,
            time: newTime, // Update with new time
          );

          // Save the new status using the mixin method
          await viewModel.saveWorkingStatus(updatedStatus);

          if (context.mounted) {
            // Close the modal after saving
            //Navigator.pop(context);
            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Working time saved successfully')),
            );
          }
        } catch (e) {
          developer.log('Error saving working status: $e');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to save working time'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    ),
  );
}
