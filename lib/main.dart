import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_design/generated/assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AttendancePage(),
    );
  }
}

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Split background
          Column(
            children: [
              // Gradient background for top portion
              Expanded(
                flex: 9, // Adjust this value to control gradient height
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(32, 255, 255, 255)
                            .withOpacity(0.1), // White with 14% opacity
                        Color(0x230176FF).withOpacity(0.14),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // White background for bottom portion
              Expanded(
                flex: 6, // Adjust this value to control white portion height
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // Decorative element
          Positioned(
            top: 100,
            left: 100,
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 0,
                height: 0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFBA09),
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFBA09).withOpacity(0.2),
                      blurRadius: 200,
                      spreadRadius: 150,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {},
                      ),
                      Container(
                        // Removed Expanded to prevent full width
                        margin: const EdgeInsets.only(
                            left: 30), // Add some space after menu
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          // Prevents row from expanding
                          children: [
                            Icon(Icons.wifi,
                                size: 16, color: Colors.green[600]),
                            const SizedBox(width: 8),
                            const Text(
                              'Connected to DSi network',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(), // Pushes everything to the left
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Profile section
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/80',
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Good Morning ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '👋',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const Text(
                          'Muntasha',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Where are you working from today?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Wed, 29 May',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Location options
                  LocationOption(
                    icon: Assets.pngOfficeFigma,
                    title: 'Office',
                    subtitle: 'At your office premises',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  LocationOption(
                    icon: Assets.pngHome,
                    title: 'Home',
                    subtitle: 'At your home',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  LocationOption(
                    icon: Assets.pngOutside,
                    title: 'Outside',
                    subtitle: 'Out for office work',
                    onTap: () {},
                  ),

                  const SizedBox(height: 32),

                  // Last working day card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Last working day',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Office • Tue, 28 May • 08:13:26',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom navigation
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BottomNavItem(
                        svgPath: Assets.svgsStartPage,
                        label: 'Start Page',
                        isSelected: false,
                      ),
                      BottomNavItem(
                        svgPath: Assets.svgsAttendence,
                        label: 'My Attendance',
                        isSelected: false,
                      ),
                      BottomNavItem(
                        svgPath: Assets.svgsSetting,
                        label: 'Settings',
                        isSelected: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationOption extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const LocationOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // SvgPicture.asset(
            //   icon, // Replace with your SVG asset path
            //   width: 48,
            //   height: 48,
            // ),
            Image.asset(
              icon,
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const BottomNavItem({
    super.key,
    required this.svgPath,
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 20,
            height: 20,
            // You can change the color based on selection
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
