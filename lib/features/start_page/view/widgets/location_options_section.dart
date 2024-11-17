import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/features/office_page/view/pages/location_modal.dart';
import 'package:new_design/features/office_page/view/widgets/network_verification_modal.dart';
import 'package:new_design/features/office_page/viewmodel/location_verification_viewmodel.dart';
import 'package:new_design/features/office_page/viewmodel/network_verification_viewmodel.dart';
import 'package:new_design/features/outside_office/view_model/outside_meeting_view_model.dart';
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
    BuildContext context,
    AttendanceLocation location,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => NetworkVerificationViewModel(),
              ),
              ChangeNotifierProvider(
                create: (_) => LocationVerificationViewModel(),
              ),
            ],
            child: Consumer2<NetworkVerificationViewModel,
                LocationVerificationViewModel>(
              builder: (context, networkViewModel, locationViewModel, _) {
                return NetworkVerificationModal(
                  isLoading: networkViewModel.state.isLoading,
                  onVerifyNetwork: () =>
                      networkViewModel.verifyNetwork(context),
                  onUseGPS: () => locationViewModel.verifyLocation(context),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showLocationVerificationModal(
    BuildContext context,
    AttendanceLocation location,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => OutsideMeetingViewModel(),
              ),
              ChangeNotifierProvider(
                create: (_) => LocationVerificationViewModel(),
              ),
            ],
            child: Consumer2<OutsideMeetingViewModel,
                LocationVerificationViewModel>(
              builder:
                  (context, outsideMeetingViewModel, locationViewModel, _) {
                return LocationModal(
                  isLoading: locationViewModel.state.isLoading,
                  onFindLocation: () =>
                      locationViewModel.handleFindLocation(context),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleLocationTap(BuildContext context, AttendanceLocation location) {
    // Existing switch-case logic for handling location taps
    switch (location.title.toLowerCase()) {
      case 'office':
        _showNetworkVerificationModal(context, location);
        break;
      case 'outside':
        _showLocationVerificationModal(context, location);
        break;
      case 'home':
        // Navigate or other action
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: locations.map((location) {
        return Column(
          children: [
            LocationOption(
              location: location,
              onTap: () => _handleLocationTap(context, location),
            ),
            const Gap(16),
          ],
        );
      }).toList(),
    );
  }
}
