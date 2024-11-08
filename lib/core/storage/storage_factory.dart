import 'package:new_design/core/storage/base_storage_provider.dart';
import 'package:new_design/core/storage/models/storable.dart';
import 'package:new_design/features/finish_working/model/outside_meeting.dart';
import 'package:new_design/features/outside_office/repository/outside_meeting_list/meeting_shared_prefs_repository.dart';
import 'package:new_design/features/outside_office/repository/outside_meeting_list/meeting_sqlite_repository.dart';

enum StorageType { sqlite, sharedPreferences }

class StorageProviderFactory {
  static BaseStorageProvider<T> create<T extends Storable>(
      StorageType storageType) {
    switch (storageType) {
      case StorageType.sqlite:
        if (T == OutsideMeeting) {
          return MeetingStorageProvider() as BaseStorageProvider<T>;
        }
        // if (T == WorkingStatus) {
        //   return WorkingStatusProvider() as BaseStorageProvider<T>;
        // }
        throw UnsupportedError(
            'SQLite repository for ${T.toString()} is not supported.');

      case StorageType.sharedPreferences:
        if (T == OutsideMeeting) {
          return MeetingSharedPrefsRepository() as BaseStorageProvider<T>;
        }
        throw UnsupportedError(
            'SharedPreferences repository for ${T.toString()} is not supported.');

      default:
        throw UnsupportedError('Unsupported storage type: $storageType');
    }
  }
}
