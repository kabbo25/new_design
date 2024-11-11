import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:new_design/core/storage/base_storage_provider.dart';

import '../model/note.dart';

mixin NoteViewModelMixin on ChangeNotifier {
  late final BaseStorageProvider<Note> _repository;
  final List<Note> _noteList = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  List<Note> get noteList => List.unmodifiable(_noteList);

  void initializeNoteProvider(BaseStorageProvider<Note> repository) {
    _repository = repository;
    initNotes();
  }

  Future<void> initNotes() async {
    if (!_isInitialized) {
      developer.log('Initializing notes');
      await loadNotes();
      _isInitialized = true;
    }
  }

  Future<void> loadNotes() async {
    try {
      _isLoading = true;
      notifyListeners();

      final loadedNotes = await _repository.getAll();
      _noteList
        ..clear()
        ..addAll(loadedNotes);

      developer.log('Loaded ${loadedNotes.length} notes');
    } catch (e) {
      debugPrint('Error loading notes: $e');
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveNote(Note note) async {
    try {
      developer.log('Saving note: ${note.toJson()}');

      // Check if note with same ID exists
      final existingIndex = _noteList.indexWhere((n) => n.id == note.id);

      await _repository.save(note);

      if (existingIndex != -1) {
        _noteList[existingIndex] = note;
      } else {
        _noteList.add(note);
      }

      notifyListeners();
    } catch (e) {
      developer.log('Error saving note: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _repository.delete(noteId as Note);
      _noteList.removeWhere((note) => note.id == noteId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting note: $e');
      rethrow;
    }
  }

  Future<void> clearNotes() async {
    try {
      await _repository.clear();
      _noteList.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing notes: $e');
      rethrow;
    }
  }

  Note? getNoteById(String id) {
    try {
      return _noteList.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _noteList.clear();
    super.dispose();
  }
}
