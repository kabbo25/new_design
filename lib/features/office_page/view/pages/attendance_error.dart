
import 'package:flutter/material.dart';

class AttendanceErrorPage extends StatelessWidget {
  final String errorType;

  const AttendanceErrorPage({
    super.key,
    required this.errorType,
  });

  String _getErrorMessage() {
    switch (errorType) {
      case 'not_connected':
        return 'You are not connected to the office network. Please ensure you are within office premises and connected to the correct network.';
      case 'mobile_connection':
        return 'Please switch from mobile data to WiFi connection to record attendance.';
      case 'no_connection':
        return 'No internet connection detected. Please check your device\'s network settings.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }

  String _getErrorTitle() {
    switch (errorType) {
      case 'not_connected':
        return 'Wrong Network';
      case 'mobile_connection':
        return 'Mobile Data Detected';
      case 'no_connection':
        return 'No Connection';
      default:
        return 'Error';
    }
  }

  IconData _getErrorIcon() {
    switch (errorType) {
      case 'not_connected':
        return Icons.wifi_off_rounded;
      case 'mobile_connection':
        return Icons.phone_android_rounded;
      case 'no_connection':
        return Icons.signal_wifi_connected_no_internet_4_rounded;
      default:
        return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getErrorIcon(),
                    color: Colors.red,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 32),
                // Error Title
                Text(
                  _getErrorTitle(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                // Error Message
                Text(
                  _getErrorMessage(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),
                // Try Again Button
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}