import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/servies/location_fetching.dart';
import 'package:new_design/features/office_page/model/location_verification_state.dart';
import 'package:new_design/features/office_page/services/location_service.dart';
import 'package:new_design/features/office_page/services/modal_manager.dart';

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
      bool? shouldProceed =
          await ModalManager.showLocationVerificationModal(navigatorContext);

      if (shouldProceed == true && navigatorContext.mounted) {
        developer.log('Properly popped, proceeding with location check');
        await handleFindLocation(navigatorContext);
      }
    } catch (e) {
      developer.log('Location verification error: $e');
    }
  }

  Future<void> handleFindLocation(BuildContext context,
      {bool shouldNavigate = true}) async {
    if (!context.mounted) {
      developer.log('Context not mounted in handleFindLocation');
      return;
    }

    try {
      developer.log('showing loading location');
      String? fetchedAddress;

      final Future<String> locationFuture = Locationservices.checkLocation();

      locationFuture.then((address) {
        developer.log('Location fetched: $address');
        fetchedAddress = address;
        _updateState(_state.copyWith(
          isLoading: false,
          isLocationFound: true,
          address: address,
        ));
      });

      await ModalManager.showLoadingModal(
        context,
        onDismissed: () async {
          fetchedAddress ??= await locationFuture;

          if (context.mounted) {
            await ModalManager.showLocationConfirmationModal(
              context,
              address: fetchedAddress!,
              onTryAgain: () async {
                developer.log('Try Again pressed, restarting location check');
                Navigator.pop(context);
                await handleFindLocation(context);
              },
              onNext: () {
                developer.log('Next pressed, navigating to success page');
                Navigator.pop(context);
                if (context.mounted) {
                  ModalManager.showOutsideMeetingModal(
                    context,
                    location: fetchedAddress ?? 'no address found',
                    onSave: (meetingPlace, meetingPurpose) {
                      OutsideLocationService.handleOutsideMeetingSave(
                        context,
                        fetchedAddress!,
                        meetingPlace,
                        meetingPurpose,
                        shouldNavigate,
                      );
                    },
                  );
                }
              },
            );
          }
        },
      );
    } catch (e) {
      developer.log('Error in handleFindLocation: $e');
      if (context.mounted) {
        await ModalManager.showLocationConfirmationModal(
          context,
          address: 'Location not found. Please try again.',
          onTryAgain: () async {
            developer.log('Try Again pressed after error');
            Navigator.pop(context);
            await handleFindLocation(context);
          },
          onNext: () {
            developer.log('Next pressed after error');
            Navigator.pop(context);
          },
        );
      }
    }
  }
}
