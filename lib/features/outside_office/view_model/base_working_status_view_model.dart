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
      //await _repository.clear();
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
      developer.log(status.toJson().toString());
      await _repository.save(status);
      final index = _workingStatuses.indexWhere((s) => s.id == status.id);
      developer.log('index is $index');
      if (index != -1) {
        _workingStatuses[0] = status;
      } else {
        _workingStatuses.add(status);
      }
      notifyListeners();
    } catch (e) {
      developer.log('Error saving working status: $e');
    }
  }

  Future<void> deleteWorkingStatus(WorkingStatus status) async {
    try {
      await _repository.delete(status);
      _workingStatuses.removeWhere((s) => s.id == status.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting working status: $e');
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
      (_repository as WorkingStatuscaSQLiteRepository).close();
    }
    _workingStatuses.clear();
    super.dispose();
  }
}
