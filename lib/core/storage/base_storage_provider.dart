import 'package:new_design/core/storage/models/storable.dart';

abstract class BaseStorageProvider<T extends Storable> {
  Future<void> save(T item);
  Future<List<T>> getAll();
  Future<void> delete(T item);
  Future<void> update(T item);
  //Future<T?> getById(String id);
  Future<void> clear();
}
