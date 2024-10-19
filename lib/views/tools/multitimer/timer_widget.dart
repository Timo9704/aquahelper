import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/custom_timer.dart';
import '../../../viewmodels/tools/multitimer/multi_timer_widget_viewmodel.dart';

class TimerWidget extends StatelessWidget {
  final CustomTimer customTimer;
  const TimerWidget({super.key, required this.customTimer});

  @override
  Widget build(BuildContext context) {

   return ChangeNotifierProvider(
  create: (context) => MultiTimerWidgetViewModel(customTimer),
  child: Consumer<MultiTimerWidgetViewModel>(
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
      ),
   );
  }
}
