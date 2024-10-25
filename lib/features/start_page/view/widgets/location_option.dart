import 'package:flutter/material.dart';

import '../../../../theme/app_decorations.dart';
import '../../../../theme/app_text_styles.dart';
import '../../model/attendance_location.dart';

class LocationOption extends StatelessWidget {
  final AttendanceLocation location;
  final VoidCallback onTap;

  const LocationOption({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.cardDecoration,
        child: Row(
          children: [
            Image.asset(
              location.icon,
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location.title, style: AppTextStyles.heading2),
                  Text(location.subtitle, style: AppTextStyles.subtitle2),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
