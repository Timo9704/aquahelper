import 'package:aquahelper/viewmodels/tools/multi_timer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatelessWidget {
  final int seconds;
  const TimerWidget({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) => Consumer<MultiTimerViewModel>(
        builder: (context, viewModel, child) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              viewModel.buildTimer(),
              const SizedBox(height: 20),
              viewModel.buildTimerButton(),
            ],
          ),
        ),
      );
}
