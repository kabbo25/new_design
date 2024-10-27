import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/core/common_feature/network_utils.dart';
import 'package:new_design/features/office_page/model/network_verification_state.dart';
import 'package:new_design/features/office_page/view/pages/wifi_connected.dart';

class NetworkVerificationViewModel extends ChangeNotifier {
  NetworkVerificationState _state = NetworkVerificationState();
  NetworkVerificationState get state => _state;
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

  Future<void> verifyNetwork(BuildContext context) async {
    _updateState(_state.copyWith(isLoading: true));

    try {
      final results = await Connectivity().checkConnectivity();

      if (results[0] == ConnectivityResult.wifi) {
        try {
          const response = 201;

          if (response == 201) {
            String wifiName = await NetworkUtils.initNetworkInfo() ?? 'No wifi';
            developer.log('Connected to WiFi: $wifiName');
            final startedWorkingTime =
                DateTime.now(); // Capture the current time

            _updateState(_state.copyWith(
              isLoading: false,
              isConnected: true,
              wifiName: wifiName,
            ));

            if (context.mounted) {
              developer.log('Context is mounted, proceeding with navigation');
              // First pop the verification bottom sheet
              Navigator.pop(context);

              // Show the confirmation modal
              if (context.mounted) {
                developer.log('Showing confirmation modal');
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isDismissible: false,
                  builder: (context) => NetworkConfirmationWrapper(
                    wifiName: wifiName,
                    onDismissed: () {
                      developer
                          .log('Modal dismissed, navigating to success page');
                      if (context.mounted) {
                        context.pushNamed(
                          'start_working',
                          extra: {
                            'wifiName': wifiName.toLowerCase(),
                            'startedWorkingTime': startedWorkingTime,
                          },
                        );
                      }
                    },
                  ),
                );
              }
            }
          } else {
            if (context.mounted) {
              _handleConnectionFailure(context);
            }
          }
        } catch (e) {
          developer.log('Network error: $e');
          if (context.mounted) {
            _handleConnectionFailure(context);
          }
        }
      } else {
        // Your existing connection type handling
        if (results[0] == ConnectivityResult.mobile) {
          if (context.mounted) {
            _handleMobileConnection(context);
          }
        } else {
          if (context.mounted) {
            _handleNoConnection(context);
          }
        }
      }
    } catch (e) {
      developer.log('Connectivity error: $e');
      if (context.mounted) {
        _handleError(context, 'Failed to verify network connection');
      }
    }
  }

  void _updateState(NetworkVerificationState newState) {
    if (!_disposed) {
      _state = newState;
      notifyListeners();
    }
  }

  void _handleConnectionFailure(BuildContext context) {
    _updateState(_state.copyWith(
      isLoading: false,
      error: 'Not connected to office network',
    ));

    if (context.mounted) {
      context.pushNamed('attendance_error',
          queryParameters: {'type': 'not_connected'});
    }
  }

  void _handleMobileConnection(BuildContext context) {
    _updateState(_state.copyWith(
      isLoading: false,
      error: 'Please connect to WiFi',
    ));

    if (context.mounted) {
      context.pushNamed('attendance_error',
          queryParameters: {'type': 'mobile_connection'});
    }
  }

  void _handleNoConnection(BuildContext context) {
    _updateState(_state.copyWith(
      isLoading: false,
      error: 'No internet connection',
    ));

    if (context.mounted) {
      context.pushNamed('attendance_error',
          queryParameters: {'type': 'no_connection'});
    }
  }

  void _handleError(BuildContext context, String message) {
    _updateState(_state.copyWith(
      isLoading: false,
      error: message,
    ));

    if (context.mounted) {
      context.pushNamed('attendance_error',
          queryParameters: {'type': 'generic_error'});
    }
  }
}
