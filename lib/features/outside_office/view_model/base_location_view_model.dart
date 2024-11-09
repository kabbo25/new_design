import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';

mixin BaseLocationViewModel on ChangeNotifier {
  late final BaseStorageProvider<OutsideMeeting> _repository;
  final List<OutsideMeeting> _locations = [];
  bool _ismeetingLoading = false;
  bool get ismeetingLoading => _ismeetingLoading;
  bool _isInitialized = false;

  void initializeLocationProvider(
      BaseStorageProvider<OutsideMeeting> repository) {
    _repository = repository;
    initlocation();
  }

  Future<void> initlocation() async {
    if (!_isInitialized) {
      developer.log('inside inti');
      await loadLocations();
      _isInitialized = true;
    }
  }

  List<OutsideMeeting> get locations => List.unmodifiable(_locations);

  Future<void> loadLocations() async {
    try {
      _ismeetingLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      final loadedLocations = await _repository.getAll();
      _locations.clear();
      _locations.addAll(loadedLocations);
      // developer.log('inside');
    } catch (e) {
      developer.log('Error loading locations: $e');
    } finally {
      Future.delayed(const Duration(milliseconds: 500));
      _ismeetingLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLocation(OutsideMeeting location) async {
    try {
      await _repository.save(location);
      _locations.add(location);
      notifyListeners();
    } catch (e) {
      developer.log('Error adding location: $e');
    }
  }

  Future<void> updateLocation(OutsideMeeting location) async {
    try {
      await _repository.update(location);
      final index = _locations.indexWhere((m) => m.id == location.id);
      if (index != -1) {
        _locations[index] = location;
        notifyListeners();
      } else {
        developer.log('Location not found in locations list');
        await loadLocations();
      }
    } catch (e) {
      developer.log('Error updating location: $e');
      await loadLocations();
    }
  }

  Future<void> deleteLocation(
      OutsideMeeting location, bool Function(OutsideMeeting) match) async {
    try {
      await _repository.delete(location);
      _locations.removeWhere(match);
      notifyListeners();
    } catch (e) {
      developer.log('Error deleting location: $e');
    }
  }

  @override
  void dispose() {
    _locations.clear();
    super.dispose();
  }
}
