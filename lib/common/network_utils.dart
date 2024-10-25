import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class NetworkUtils {
  static final NetworkInfo _networkInfo = NetworkInfo();

  static Future<String?> initNetworkInfo() async {
    // ... (implementation of _initNetworkInfo method)
    String? wifiName;

    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        // Request permissions as recommended by the plugin documentation:
        // https://github.com/fluttercommunity/plus_plugins/tree/main/packages/network_info_plus/network_info_plus
        if (await Permission.locationWhenInUse.request().isGranted) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = 'Unauthorized to get Wifi Name';
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }
    return '''
      $wifiName
    ''';
  }
}
