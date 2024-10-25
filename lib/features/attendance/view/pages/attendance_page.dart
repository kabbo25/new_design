import 'package:flutter/material.dart';
import 'package:new_design/features/attendance/view/widgets/background_widget.dart';
import 'package:new_design/features/attendance/view/widgets/bottom_navigation_section.dart';
import 'package:new_design/features/attendance/view/widgets/last_working_day_card.dart';
import 'package:new_design/features/attendance/view/widgets/location_options_section.dart';
import 'package:new_design/features/attendance/view/widgets/network_status_bar.dart';
import 'package:new_design/features/attendance/view/widgets/user_profile_section.dart';
import 'package:new_design/features/edit_working_hour/view/pages/last_working_day_modal.dart';
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
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NetworkStatusBar(),
                  const UserProfileSection(),
                  LocationOptionsSection(
                    locations: viewModel.locationOptions,
                  ),
                  LastWorkingDayCard(
                    lastWorkingDay: viewModel.lastWorkingDay,
                    onEdit: () => _showEditTimeModal(context),
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
    builder: (context) => LastWorkingDayModal(
      initialTime: TimeOfDay.now(),
      onSave: (TimeOfDay selectedTime) {
        context.read<AttendanceViewModel>().updateLastWorkingDay(selectedTime);
        Navigator.pop(context);
      },
    ),
  );
}
