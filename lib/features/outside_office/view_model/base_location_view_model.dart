import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/storage/models/storable.dart';

abstract class BaseLocationViewModel<T extends Storable> extends ChangeNotifier {
  late final BaseStorageProvider<T> _repository;
  final List<T> _locations = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isInitialized = false;

  BaseLocationViewModel(BaseStorageProvider<T> repository) {
    _repository = repository;
    init();
  }

  Future<void> init() async {
    if (!_isInitialized) {
      await loadLocations();
      _isInitialized = true;
    }
  }

  List<T> get locations => List.unmodifiable(_locations);

  Future<void> loadLocations() async {
    try {
      _isLoading = true;
      notifyListeners();
      final loadedLocations = await _repository.getAll();
      _locations.clear();
      _locations.addAll(loadedLocations);
    } catch (e) {
      developer.log('Error loading locations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLocation(T location) async {
    try {
      await _repository.save(location);
      _locations.add(location);
      notifyListeners();
    } catch (e) {
      developer.log('Error adding location: $e');
    }
  }

  Future<void> updateLocation(
    T location,
  ) async {
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

  Future<void> deleteLocation(T location, bool Function(T) match) async {
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
