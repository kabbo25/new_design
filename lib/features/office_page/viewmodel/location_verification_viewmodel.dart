import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/core/common_feature/location_fetching.dart';
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
      final navigatorContext = Navigator.of(context).context;
      Navigator.pop(context);

      developer.log('Showing location modal');

      bool? shouldProceed = await showModalBottomSheet<bool>(
        context: navigatorContext,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (context) => LocationModal(
          isLoading: false,
          onFindLocation: () {
            developer.log('Find location pressed');
            Navigator.pop(context, true);
          },
        ),
      );

      developer.log('Should proceed value: $shouldProceed');

      if (shouldProceed == true && navigatorContext.mounted) {
        developer.log('Properly popped, proceeding with location check');
        await _handleFindLocation(navigatorContext);
      }
    } catch (e) {
      developer.log('Location verification error: $e');
    }
  }

  Future<void> _handleFindLocation(BuildContext context) async {
    try {
      if (!context.mounted) {
        developer.log('Context not mounted in _handleFindLocation');
        return;
      }

      developer.log('showing loading location');

      // Start fetching location immediately
      final Future<String> locationFuture = Locationservices.checkLocation();

      // Track if location has been fetched
      String? fetchedAddress;

      // Listen to the location future without awaiting
      locationFuture.then((address) {
        developer.log('Location fetched: $address');
        fetchedAddress = address;
        _updateState(_state.copyWith(
          isLoading: false,
          isLocationFound: true,
          address: address,
        ));
      }).catchError((e) {
        developer.log('Error fetching location: $e');
        fetchedAddress = 'Location not found. Please try again.';
      });

      // Show loading modal while location is being fetched
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (context) => LoadingModal(
          onDismissed: () async {
            // Wait for location if not yet fetched
            fetchedAddress ??= await locationFuture;

            if (context.mounted) {
              developer.log('Showing location confirmation modal');
              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isDismissible: false,
                builder: (context) => LocationConfirmationWrapper(
                  address: fetchedAddress!,
                  onTryAgain: () async {
                    developer
                        .log('Try Again pressed, restarting location check');
                    Navigator.pop(context);
                    await _handleFindLocation(context);
                  },
                  onNext: () {
                    developer.log('Next pressed, navigating to success page');
                    Navigator.pop(context);
                    if (context.mounted) {
                      context.pushNamed(
                        'attendance_success',
                        extra: {'wifiName': fetchedAddress},
                      );
                    }
                  },
                ),
              );
            }
          },
        ),
      );
    } catch (e) {
      developer.log('Error in _handleFindLocation: $e');
      if (context.mounted) {
        await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isDismissible: false,
          builder: (context) => LocationConfirmationWrapper(
            address: 'Location not found. Please try again.',
            onTryAgain: () async {
              developer.log('Try Again pressed after error');
              Navigator.pop(context);
              await _handleFindLocation(context);
            },
            onNext: () {
              developer.log('Next pressed after error');
              Navigator.pop(context);
            },
          ),
        );
      }
    }
  }
}
