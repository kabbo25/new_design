import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_design/core/services/location_fetching.dart';
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

  static OutsideMeeting _createOutsideMeeting({
    required String location,
    required String meetingPurpose,
  }) {
    final now = TimeOfDay.now();
    return OutsideMeeting(
      title: meetingPurpose,
      location: location,
      time:
          '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'am' : 'pm'}',
      purpose: meetingPurpose,
    );
  }

  static void handleOutsideMeetingSave(
    BuildContext context,
    String location,
    String meetingPlace,
    String meetingPurpose,
    bool shouldNavigate,
  ) {
    try {
      final newMeeting = _createOutsideMeeting(
        location: location,
        meetingPurpose: meetingPurpose,
      );

      developer.log(newMeeting.toJson().toString());

      final viewModel =
          Provider.of<OutsideMeetingViewModel>(context, listen: false);
      viewModel.addLocation(newMeeting);
      final DateTime exactTime = DateTime.now();
      if (shouldNavigate) {
        viewModel.updateStartWorkingStatusTime(exactTime);
        context.pushNamed('outside_working');
      }
    } catch (e) {
      developer.log('Error saving outside meeting: $e');
      // Handle error appropriately
    }
  }
}
