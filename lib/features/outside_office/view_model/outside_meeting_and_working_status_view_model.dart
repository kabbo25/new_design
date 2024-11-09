import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/storage/models/storable.dart';
import 'package:new_design/features/outside_office/repository/working_status/working_status_card_repository.dart';

abstract class BaseCombinedViewModel<T extends Storable> extends ChangeNotifier {
  final BaseStorageProvider<T> _locationRepository;
  final BaseStorageProvider<T> _workingStatusRepository;
  
  final List<T> _locations = [];
  final List<T> _workingStatuses = [];
  
  bool _isLoadingLocations = false;
  bool _isLoadingStatuses = false;
  bool _isInitialized = false;

  BaseCombinedViewModel({
    required BaseStorageProvider<T> locationRepository,
    required BaseStorageProvider<T> workingStatusRepository,
  })  : _locationRepository = locationRepository,
        _workingStatusRepository = workingStatusRepository {
    init();
  }

  // Getters
  bool get isLoadingLocations => _isLoadingLocations;
  bool get isLoadingStatuses => _isLoadingStatuses;
  List<T> get locations => List.unmodifiable(_locations);
  List<T> get workingStatuses => List.unmodifiable(_workingStatuses);

  // Initialization
  Future<void> init() async {
    if (!_isInitialized) {
      await Future.wait([
        loadLocations(),
        loadWorkingStatuses(),
      ]);
      _isInitialized = true;
    }
  }

  // Location Methods
  Future<void> loadLocations() async {
    try {
      _isLoadingLocations = true;
      notifyListeners();
      
      final loadedLocations = await _locationRepository.getAll();
      _locations
        ..clear()
        ..addAll(loadedLocations);
    } catch (e) {
      developer.log('Error loading locations: $e');
    } finally {
      _isLoadingLocations = false;
      notifyListeners();
    }
  }

  Future<void> addLocation(T location) async {
    try {
      await _locationRepository.save(location);
      _locations.add(location);
      notifyListeners();
    } catch (e) {
      developer.log('Error adding location: $e');
    }
  }

  Future<void> updateLocation(T location) async {
    try {
      await _locationRepository.update(location);
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

  Future<void> deleteLocation(T location, bool Function(T) match) async {
    try {
      await _locationRepository.delete(location);
      _locations.removeWhere(match);
      notifyListeners();
    } catch (e) {
      developer.log('Error deleting location: $e');
    }
  }

  // Working Status Methods
  Future<void> loadWorkingStatuses() async {
    try {
      _isLoadingStatuses = true;
      notifyListeners();
      
      final loadedStatuses = await _workingStatusRepository.getAll();
      _workingStatuses
        ..clear()
        ..addAll(loadedStatuses);
    } catch (e) {
      debugPrint('Error loading working statuses: $e');
    } finally {
      _isLoadingStatuses = false;
      notifyListeners();
    }
  }

  Future<void> saveWorkingStatus(T status) async {
    try {
      await _workingStatusRepository.save(status);
      final index = _workingStatuses.indexWhere((s) => s.id == status.id);
      if (index != -1) {
        _workingStatuses[index] = status;
      } else {
        _workingStatuses.add(status);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving working status: $e');
    }
  }

  Future<void> deleteWorkingStatus(T status) async {
    try {
      await _workingStatusRepository.delete(status);
      _workingStatuses.removeWhere((s) => s.id == status.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting working status: $e');
    }
  }

  Future<void> clearWorkingStatuses() async {
    try {
      await _workingStatusRepository.clear();
      _workingStatuses.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing working statuses: $e');
    }
  }

  @override
  void dispose() {
    if (_workingStatusRepository is WorkingStatuscaSQLiteRepository) {
      (_workingStatusRepository as WorkingStatuscaSQLiteRepository).close();
    }
    _locations.clear();
    _workingStatuses.clear();
    super.dispose();
  }
}