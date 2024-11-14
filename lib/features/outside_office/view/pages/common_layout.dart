import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_design/features/finish_working/view/widgets/bottom_gradient.dart';
import 'package:new_design/features/start_page/model/background_config.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';

class CommonPageLayout extends StatelessWidget {
  final List<Widget> topSection;
  final Widget timerSection;
  final Widget bottomSection;
  final BackgroundConfig backgroundConfig;
  final EdgeInsets padding;

  const CommonPageLayout({
    super.key,
    required this.topSection,
    required this.timerSection,
    required this.bottomSection,
    required this.backgroundConfig,
    this.padding = const EdgeInsets.fromLTRB(0, 40, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...topSection,
                  const Spacer(),
                  timerSection,
                  const Spacer(),
                  Stack(
                    children: [
                      Positioned.fill(
                        child: BottomGradient(config: backgroundConfig),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: bottomSection,
                          ),
                          const Gap(24),
                          const BottomNavigationSection(),
                        ],
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
