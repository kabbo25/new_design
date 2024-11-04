import 'package:flutter/material.dart';
import 'package:new_design/features/office_page/view/pages/location_found_modal.dart';
import 'package:new_design/features/office_page/view/pages/location_modal.dart';
import 'package:new_design/features/office_page/view/widgets/location_loading_modal.dart';
import 'package:new_design/features/outside_office/view/widgets/outside_meeting_location_modal.dart';

class ModalManager {
  static Future<bool?> showLocationVerificationModal(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => LocationModal(
        isLoading: false,
        onFindLocation: () {
          Navigator.pop(context, true);
        },
      ),
    );
  }

  static Future<void> showLoadingModal(
    BuildContext context, {
    required VoidCallback onDismissed,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => LoadingModal(onDismissed: onDismissed),
    );
  }

  static Future<void> showLocationConfirmationModal(
    BuildContext context, {
    required String address,
    required VoidCallback onTryAgain,
    required VoidCallback onNext,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => LocationConfirmationWrapper(
        address: address,
        onTryAgain: onTryAgain,
        onNext: onNext,
      ),
    );
  }

  static Future<void> showOutsideMeetingModal(
    BuildContext context, {
    required String location,
    required Function(String, String) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: OutsideMeetingLocationModal(
          location: location,
          onSave: onSave,
        ),
      ),
    );
  }
}