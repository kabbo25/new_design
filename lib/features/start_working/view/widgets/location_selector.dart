import 'package:flutter/material.dart';
import 'package:new_design/features/start_working/model/start_working_location.dart';

class LocationOptionsSection extends StatelessWidget {
  final List<StartWorkingLocation> locations;

  const LocationOptionsSection({
    super.key,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          locations.map((location) => _buildLocationOption(location)).toList(),
    );
  }

  Widget _buildLocationOption(StartWorkingLocation location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
