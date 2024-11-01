import 'package:flutter/material.dart';
import 'package:new_design/features/edit_working_hour/view/pages/last_working_day_modal.dart';
import 'package:new_design/features/start_page/view/widgets/background_widget.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/start_page/view/widgets/last_working_day_card.dart';
import 'package:new_design/features/start_page/view/widgets/location_options_section.dart';
import 'package:new_design/features/start_page/view/widgets/network_status_bar.dart';
import 'package:new_design/features/start_page/view/widgets/user_profile_section.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/attendance_view_model.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceViewModel(),
      child: const AttendanceView(),
    );
  }
}

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AttendanceViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(config: viewModel.backgroundConfig),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: NetworkStatusBar(),
                  ),
                  const UserProfileSection(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        LocationOptionsSection(
                          locations: viewModel.locationOptions,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LastWorkingDayCard(
                      lastWorkingDay: viewModel.lastWorkingDay,
                      onEdit: () => _showEditTimeModal(context),
                    ),
                  ),
                  const BottomNavigationSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showEditTimeModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => TimePickerModal(
      title: 'Edit Working Hours',
      editTimeLabel: 'Edit your entry time here:',
      initialTime: const TimeOfDay(hour: 15, minute: 0),
      showWorkingHourSelector: true,
      onSave: (newTime) {
        // Handle save
      },
    ),
  );
}
