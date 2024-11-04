import 'package:new_design/core/storage/shared_preferences_provider.dart';
import 'package:new_design/core/storage/sqlite_provider.dart';
import 'package:new_design/core/storage/storage_provider.dart';

class StorageFactory {
  static final StorageFactory _instance = StorageFactory._internal();

  factory StorageFactory() {
    return _instance;
  }

  StorageFactory._internal();

  StorageProvider via(String type) {
    switch (type.toLowerCase()) {
      case 'sqlite':
        return SQLiteProvider();
      case 'shared_preferences':
        return SharedPreferencesProvider();
      default:
        throw Exception('Unknown storage type: $type');
    }
  }
}
