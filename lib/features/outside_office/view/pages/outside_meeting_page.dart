import 'dart:developer' as developer;

import 'package:flutter/material.dart';
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
import 'package:new_design/features/office_page/viewmodel/location_verification_viewmodel.dart';
import 'package:new_design/features/outside_office/view/widgets/semi_circle.dart';
import 'package:new_design/features/outside_office/view_model/outside_meeting_view_model.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/start_page/view/widgets/network_status_bar.dart';
import 'package:new_design/features/start_working/view/widgets/finish_working_button.dart';
import 'package:new_design/features/start_working/view/widgets/start_working_hour_card.dart';
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
                    child: WorkingStatusCard(
                      startWorkingHour: viewModel.startWorkingHour,
                      onEdit: () => _showStartWorking(context),
                    ),
                  ),
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutsideMeetingsCard(
                      meetings: viewModel.locations,
                      onLocationSelected: (location) {
                        viewModel.updateLocations(location);
                      },
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
