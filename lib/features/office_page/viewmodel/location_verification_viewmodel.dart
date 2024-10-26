import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/common/location_fetching.dart';
import 'package:new_design/features/office_page/model/location_verification_state.dart';
import 'package:new_design/features/office_page/view/pages/location_found_modal.dart';
import 'package:new_design/features/office_page/view/pages/location_modal.dart';
import 'package:new_design/features/office_page/view/widgets/location_loading_modal.dart';

class LocationVerificationViewModel extends ChangeNotifier {
  LocationVerificationState _state = LocationVerificationState();
  LocationVerificationState get state => _state;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void _updateState(LocationVerificationState newState) {
    if (!_disposed) {
      _state = newState;
      notifyListeners();
    }
  }

  Future<void> verifyLocation(BuildContext context) async {
    if (_disposed) return;

    try {
      Navigator.pop(context);
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (context) => LocationModal(
          isLoading: false,
          onFindLocation: () => _handleFindLocation(context),
        ),
      );
    } catch (e) {
      developer.log('Location verification error');
      // if (context.mounted) _handleError(context, 'Failed to verify location');
    }
  }

  Future<void> _handleFindLocation(BuildContext context) async {
    try {
      String address = await Locationservices.checkLocation();
      developer.log(address);
      _updateState(_state.copyWith(
        isLoading: false,
        isLocationFound: true,
        address: address,
      ));
      if (context.mounted) {
        Navigator.pop(context);
      }
      // Show loading modal
      if (context.mounted) {
        developer.log('showing loading location');
        await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          builder: (context) => LoadingModal(onDismissed: () async {
            if (context.mounted) {
              developer.log(
                  'Context is mounted, proceeding with location confirmation');
              // First pop the loading modal
              //Navigator.pop(context);

              // Show the location confirmation modal
              if (context.mounted) {
                developer.log('Showing location confirmation modal');
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isDismissible: false,
                  builder: (context) => LocationConfirmationWrapper(
                      address: address,
                      onTryAgain: () async {
                        developer.log(
                            'Try Again pressed, restarting location check');
                        Navigator.pop(context); // Close current modal
                        await _handleFindLocation(
                            context); // Restart the location finding process
                      },
                      onNext: () {
                        developer
                            .log('Next pressed, navigating to success page');
                        Navigator.pop(context);
                        if (context.mounted) {
                          context.pushNamed(
                            'attendance_success',
                            extra: {'wifiName': address},
                          );
                        }
                      }),
                );
              }
            }
          }),
        );
      }
    } catch (e) {
      developer.log('Error in _handleFindLocation: $e');
      // if (context.mounted) {
      //   Navigator.pop(context); // Pop loading modal
      //   await showModalBottomSheet(
      //     context: context,
      //     backgroundColor: Colors.transparent,
      //     isDismissible: false,
      //     builder: (context) => LocationConfirmationWrapper(
      //       address: 'Location not found. Please try again.',
      //       onTryAgain: () async {
      //         developer.log('Try Again pressed after error');
      //         Navigator.pop(context);
      //         await _handleFindLocation(context);
      //       },
      //       onNext: () {
      //         developer.log('Next pressed after error');
      //         Navigator.pop(context);
      //       },
      //     ),
      //   );
      // }
    }
  }
}
