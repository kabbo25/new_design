import 'package:flutter/material.dart';
import 'package:new_design/core/storage/storage_factory.dart';
import 'package:new_design/features/finish_working/viewmodel/timer_tracking_view_model.dart';
import 'package:provider/provider.dart';

class TimerProvider extends StatelessWidget {
  final Widget child;

  const TimerProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimeTrackingViewModel(
        workingStatusStorageType: StorageType.sqlite,
      ),
      child: child,
    );
  }
}
