import 'package:flutter/material.dart';
import 'package:new_design/features/finish_working/view/widgets/network_profile_bar.dart';
import 'package:new_design/features/finish_working/viewmodel/finish_working_view_model.dart';
import 'package:new_design/features/start_page/view/widgets/bottom_navigation_section.dart';
import 'package:provider/provider.dart';

class FinishWorkingPage extends StatelessWidget {
  const FinishWorkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinishWorkingViewModel(),
      child: const FinishWorkingView(),
    );
  }
}

class FinishWorkingView extends StatelessWidget {
  const FinishWorkingView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FinishWorkingViewModel>();
    return const Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //network status bar with circle avatar
                  NetworkProfileBar(),
                  SizedBox(height: 20),
                  //start working card
                  //finished working card
                  //My locations card that show all the location through bottom modal
                  //Timer section
                  //if any note added, it will appear here
                  //add a note elevated button
                  Stack(
                    children: [
                      // Positioned.fill(
                      //   child: BackgroundWidget(
                      //       config: viewModel.backgroundConfig),
                      // ),

                      //seet you tommorrow text
                      //text button work again
                      BottomNavigationSection(),
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
