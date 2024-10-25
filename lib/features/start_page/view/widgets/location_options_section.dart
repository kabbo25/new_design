import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/features/office_page/view/widgets/network_verification_modal.dart';
import 'package:new_design/features/office_page/viewmodel/network_verification_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../model/attendance_location.dart';
import 'location_option.dart';

class LocationOptionsSection extends StatelessWidget {
  final List<AttendanceLocation> locations;

  const LocationOptionsSection({
    super.key,
    required this.locations,
  });

  void _showNetworkVerificationModal(
      BuildContext context, AttendanceLocation location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ChangeNotifierProvider(
            create: (_) => NetworkVerificationViewModel(),
            child: Consumer<NetworkVerificationViewModel>(
              builder: (context, viewModel, _) {
                return ChangeNotifierProvider(
                  create: (_) => NetworkVerificationViewModel(),
                  child: Consumer<NetworkVerificationViewModel>(
                    builder: (context, viewModel, _) {
                      return NetworkVerificationModal(
                        isLoading: viewModel.state.isLoading,
                        onVerifyNetwork: () => viewModel.verifyNetwork(),
                        onUseGPS: () => viewModel.verifyGPS(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: locations.map((location) {
        return Column(
          children: [
            LocationOption(
              location: location,
              onTap: () => _showNetworkVerificationModal(context, location),
            ),
            const Gap(16),
          ],
        );
      }).toList(),
    );
  }
}
