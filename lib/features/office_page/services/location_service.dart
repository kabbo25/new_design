// location_service.dart
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/core/common_feature/location_fetching.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/outside_office/view_model/outside_meeting_view_model.dart';
import 'package:provider/provider.dart';

class OutsideLocationService {
  static Future<String> fetchLocation() async {
    try {
      return await Locationservices.checkLocation();
    } catch (e) {
      return 'Location not found. Please try again.';
    }
  }

  static void handleOutsideMeetingSave(
    BuildContext context,
    String location,
    String meetingPlace,
    String meetingPurpose,
    bool shouldNavigate,
  ) {
    try {
      if (shouldNavigate) {
        context.pushNamed('outside_working');
      } else {
        final now = TimeOfDay.now();
        final newMeeting = OutsideMeeting(
          title: meetingPurpose,
          location: meetingPlace,
          time:
              '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'am' : 'pm'}',
        );

        // Get the ViewModel instance from a valid context
        final viewModel =
            Provider.of<OutsideMeetingViewModel>(context, listen: false);
        viewModel.addLocation(newMeeting);
      }
    } catch (e) {
      developer.log('Error saving outside meeting: $e');
      // Handle error appropriately
    }
  }
}
