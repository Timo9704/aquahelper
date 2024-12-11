import 'package:aquahelper/viewmodels/tools/osmosis_calculator_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OsmosisCalculator extends StatelessWidget {
  const OsmosisCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OsmosisCalculatorViewModel(),
      child: Consumer<OsmosisCalculatorViewModel>(
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
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.switch_left),
                label: 'Osmose-Leitungswasser',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.switch_right),
                label: 'Osmose-Wasserwechsel',
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
