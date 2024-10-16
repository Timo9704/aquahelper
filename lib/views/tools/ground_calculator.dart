import 'package:aquahelper/viewmodels/tools/ground_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroundCalculator extends StatelessWidget {
  const GroundCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroundCalculatorViewModel(),
      child: Consumer<GroundCalculatorViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text("Bodengrund-Rechner"),
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
                icon: Icon(Icons.bubble_chart),
                label: 'aufsteigend',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bubble_chart),
                label: 'Insel',
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
