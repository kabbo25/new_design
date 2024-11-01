// modal_service.dart
import 'package:flutter/material.dart';

class ModalService {
  static Future<T?> showCustomBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = false,
    Color backgroundColor = Colors.transparent, required bool handleKeyboard,
  }) async {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      builder: (context) => child,
    );
  }
}
