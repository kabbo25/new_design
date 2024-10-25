import 'package:flutter/material.dart';
import 'package:new_design/features/office_page/model/network_verification_state.dart';

class NetworkVerificationViewModel extends ChangeNotifier {
  NetworkVerificationState _state = NetworkVerificationState();
  NetworkVerificationState get state => _state;

  Future<void> verifyNetwork() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      // Add your network verification logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay
      _state = _state.copyWith(isLoading: false);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: 'Failed to verify network connection',
      );
    }
    notifyListeners();
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
