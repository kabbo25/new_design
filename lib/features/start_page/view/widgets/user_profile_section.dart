import 'package:flutter/material.dart';

import '../../../../theme/app_text_styles.dart';

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage('https://via.placeholder.com/80'),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Good Morning ', style: AppTextStyles.heading2),
              Text('👋', style: TextStyle(fontSize: 20)),
            ],
          ),
          Text('Muntasha', style: AppTextStyles.heading1),
          SizedBox(height: 8),
          Text(
            'Where are you working from today?',
            style: AppTextStyles.subtitle1,
          ),
          SizedBox(height: 4),
          Text(
            'Wed, 29 May',
            style: AppTextStyles.subtitle2,
          ),
        ],
      ),
    );
  }
}
