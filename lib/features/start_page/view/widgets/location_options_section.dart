import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/features/office_page/view/pages/location_modal.dart';
import 'package:new_design/features/office_page/view/widgets/network_verification_modal.dart';
import 'package:new_design/features/office_page/viewmodel/location_verification_viewmodel.dart';
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

  void _showModalWithProviders<T extends ChangeNotifier>({
    required BuildContext context,
    required T viewModel,
    required Widget Function(BuildContext, T, Widget?) builder,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ChangeNotifierProvider.value(
            value: viewModel,
            child: Consumer<T>(
              builder: builder,
            ),
          ),
        );
      },
    );
  }

  void _handleLocationTap(BuildContext context, AttendanceLocation location) {
    switch (location.title.toLowerCase()) {
      case 'office':
        _showModalWithProviders(
          context: context,
          viewModel: NetworkVerificationViewModel(),
          builder: (context, networkViewModel, _) {
            return NetworkVerificationModal(
              isLoading: networkViewModel.state.isLoading,
              onVerifyNetwork: () => networkViewModel.verifyNetwork(context),
              onUseGPS: () {
                _showModalWithProviders(
                  context: context,
                  viewModel: LocationVerificationViewModel(),
                  builder: (context, locationViewModel, _) {
                    return LocationModal(
                      isLoading: locationViewModel.state.isLoading,
                      onFindLocation: () =>
                          locationViewModel.handleFindLocation(context),
                    );
                  },
                );
              },
            );
          },
        );
        break;
      case 'outside':
        _showModalWithProviders(
          context: context,
          viewModel: LocationVerificationViewModel(),
          builder: (context, locationViewModel, _) {
            return LocationModal(
              isLoading: locationViewModel.state.isLoading,
              onFindLocation: () =>
                  locationViewModel.handleFindLocation(context),
            );
          },
        );
        break;
      case 'home':
        // Implement navigation or other action for 'home' case
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
