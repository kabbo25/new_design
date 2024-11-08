import 'dart:convert';

import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/storage/models/storable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseSharedPrefsProvider<T extends Storable>
    implements BaseStorageProvider<T> {
  String get storageKey;
  T fromJson(Map<String, dynamic> json);

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<void> save(T item) async {
    final items = await getAll();
    items.add(item);
    await _saveAll(items);
  }

  @override
  Future<List<T>> getAll() async {
    final prefs = await _prefs;
    final String? jsonString = prefs.getString(storageKey);

    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> delete(T item) async {
    final items = await getAll();
    items.removeWhere((i) => i.id == item.id);
    await _saveAll(items);
  }

  @override
  Future<void> update(T item) async {
    final items = await getAll();
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveAll(items);
    }
  }

  // @override
  // Future<T?> getById(String id) async {
  //   final items = await getAll();
  //   return items.cast<T?>().firstWhere(
  //         (item) => item?.id == id,
  //         orElse: () => null,
  //       );
  // }

  Future<void> _saveAll(List<T> items) async {
    final prefs = await _prefs;
    final jsonString = jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString(storageKey, jsonString);
  }
}
