import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/homepage_viewmodel.dart';
import '../screens/general/dashboard.dart';
import '../screens/general/aquarium_startpage.dart';
import '../screens/tools/tools_startpage.dart';
import '../screens/settings/settings.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomepageViewModel(),
      child: Consumer<HomepageViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text("AquaHelper"),
            backgroundColor: Colors.lightGreen,
          ),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.grey[700],
            selectedIconTheme: IconThemeData(color: Colors.grey[700]),
            unselectedIconTheme: IconThemeData(color: Colors.grey[700]),
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Startseite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rectangle_outlined),
                label: 'Aquarien',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.filter_alt_sharp),
                label: 'Tools',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Einstellungen',
              ),
            ],
            currentIndex: viewModel.selectedPage,
            onTap: (index) {
              viewModel.setSelectedPage(index);
            },
          ),
          body: IndexedStack(
            index: viewModel.selectedPage,
            children: const [
              Dashboard(),
              AquariumStartPage(),
              ToolsStartPage(),
              Settings()
            ],
          ),
        ),
      ),
    );
  }
}
