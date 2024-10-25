import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:new_design/common/network_utils.dart';
import 'package:new_design/features/office_page/model/network_verification_state.dart';

class NetworkVerificationViewModel extends ChangeNotifier {
  NetworkVerificationState _state = NetworkVerificationState();
  NetworkVerificationState get state => _state;
  Future<void> verifyNetwork(BuildContext context) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final results = await Connectivity().checkConnectivity();

      if (results[0] == ConnectivityResult.wifi) {
        try {
          final response = await http
              .post(
                Uri.parse('http://10.0.0.137:8080/api/v1/main/success'),
              )
              .timeout(const Duration(seconds: 2));

          developer.log('Response status: ${response.statusCode}');

          if (response.statusCode == 201) {
            String? wifiName = await NetworkUtils.initNetworkInfo();
            developer.log('Connected to WiFi: $wifiName');

            _state = _state.copyWith(
              isLoading: false,
              isConnected: true,
              wifiName: wifiName,
            );

            if (context.mounted) {
              context.pushNamed(
                'attendance_success',
                extra: {'wifiName': wifiName},
              );
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
      } else if (results[0] == ConnectivityResult.mobile) {
        if (context.mounted) {
          _handleMobileConnection(context);
        }
      } else {
        if (context.mounted) {
          _handleNoConnection(context);
        }
      }
    } catch (e) {
      developer.log('Connectivity error: $e');
      if (context.mounted) {
        _handleError(context, 'Failed to verify network connection');
      }
    }

    notifyListeners();
  }

  void _handleConnectionFailure(BuildContext context) {
    _state = _state.copyWith(
      isLoading: false,
      error: 'Not connected to office network',
    );
    if (context.mounted) {
      context.pushNamed('attendance_error',
          queryParameters: {'type': 'not_connected'});
    }
  }

  void _handleMobileConnection(BuildContext context) {
    _state = _state.copyWith(
      isLoading: false,
      error: 'Please connect to WiFi',
    );
    if (context.mounted) {
      context.pushNamed('attendance_error',
          queryParameters: {'type': 'mobile_connection'});
    }
  }

  void _handleNoConnection(BuildContext context) {
    _state = _state.copyWith(
      isLoading: false,
      error: 'No internet connection',
    );
    if (context.mounted) {
      context.pushNamed('attendance_error',
          queryParameters: {'type': 'no_connection'});
    }
  }

  void _handleError(BuildContext context, String message) {
    _state = _state.copyWith(
      isLoading: false,
      error: message,
    );
    if (context.mounted) {
      context.pushNamed('attendance_error',
          queryParameters: {'type': 'generic_error'});
    }
  }

  Future<void> verifyGPS() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      // Add your GPS verification logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay
      _state = _state.copyWith(isLoading: false);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'Failed to verify GPS location',
      );
    }
    notifyListeners();
  }
}
