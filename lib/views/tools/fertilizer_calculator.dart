import 'package:aquahelper/viewmodels/tools/fertilizer_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FertilizerCalculator extends StatelessWidget {
  const FertilizerCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FertilizerCalculatorViewModel(),
      child: Consumer<FertilizerCalculatorViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text("AquaHelper"),
            backgroundColor: Colors.lightGreen,
          ),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.grey[700],
            selectedIconTheme: IconThemeData(color: Colors.grey[700]),
            unselectedIconTheme: IconThemeData(color: Colors.grey[700]),
            unselectedLabelStyle: TextStyle(color: Colors.grey[700]),
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.switch_left),
                label: 'Konverter',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time_filled),
                label: 'Verbrauch',
              ),
            ],
            currentIndex: viewModel.selectedPage,
            onTap: (index) {
              viewModel.setSelectedPage(index);
            },
          ),
          body: viewModel.pageOptions[viewModel.selectedPage],
        ),
      ),
    );
  }
}
