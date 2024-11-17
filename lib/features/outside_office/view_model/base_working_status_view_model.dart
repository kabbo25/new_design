import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/features/finish_working/model/working_status.dart';
import 'package:new_design/features/outside_office/repository/working_status/working_status_card_repository.dart';

mixin BaseWorkingStatusViewModel on ChangeNotifier {
  late final BaseStorageProvider<WorkingStatus> _repository;
  final List<WorkingStatus> _workingStatuses = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isInitialized = false;

  void initializeWorkingStatusProvider(
      BaseStorageProvider<WorkingStatus> repository) {
    _repository = repository;
    initworking();
  }

  Future<void> initworking() async {
    if (!_isInitialized) {
      developer.log('inside');
      await loadWorkingStatuses();
      _isInitialized = true;
    }
  }

  List<WorkingStatus> get workingStatuses =>
      List.unmodifiable(_workingStatuses);

  Future<void> loadWorkingStatuses() async {
    try {
      _isLoading = true;
      notifyListeners();
      final loadedStatuses = await _repository.getAll();
      _workingStatuses
        ..clear()
        ..addAll(loadedStatuses);
      developer.log('inside and ${loadedStatuses.length}');
      // await _repository.clear();
    } catch (e) {
      debugPrint('Error loading working statuses: $e');
    } finally {
      Future.delayed(const Duration(milliseconds: 500));
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveWorkingStatus(WorkingStatus status) async {
    try {
      developer.log('Saving status: ${status.toJson()}');

      // Check if a status with the same work mode exists
      final existingIndex =
          _workingStatuses.indexWhere((s) => s.workMode == status.workMode);

      await _repository.save(status);
      developer.log('Existing index: $existingIndex');

      if (_workingStatuses.isNotEmpty) {
        if (status.workMode == WorkMode.ending) {
          _workingStatuses.length > 1
              ? _workingStatuses.add(status)
              : _workingStatuses[1] = status;
        } else {
          _workingStatuses[0] = status;
        }
      } else {
        _workingStatuses.add(status);
      }

      // Log the entire _workingStatuses list after saving
      developer.log(
          '_workingStatuses after save: ${_workingStatuses.map((s) => s.toJson()).toList()}');
      notifyListeners();
    } catch (e) {
      developer.log('Error saving working status: $e');
    }
  }

  // Get finishing work status
  WorkingStatus? get finishingStatus {
    try {
      return _workingStatuses
          .lastWhere((status) => status.workMode == WorkMode.ending);
    } catch (e) {
      return null;
    }
  }

  // Get starting work status
  WorkingStatus? get startingStatus {
    try {
      developer.log(
          'staring fount ${_workingStatuses.firstWhere((status) => status.workMode == WorkMode.starting).toJson().toString()}');
      return _workingStatuses
          .firstWhere((status) => status.workMode == WorkMode.starting);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearWorkingStatuses() async {
    try {
      await _repository.clear();
      _workingStatuses.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing working statuses: $e');
    }
  }

  @override
  void dispose() {
    if (_repository is WorkingStatuscaSQLiteRepository) {
      (_repository).close();
    }
    _workingStatuses.clear();
    super.dispose();
  }
}
