import 'package:aquahelper/views/aquarium_startpage.dart';
import 'package:aquahelper/views/dashboard.dart';
import 'package:aquahelper/views/setting_startpage.dart';
import 'package:aquahelper/views/tools_startpage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../viewmodels/homepage_viewmodel.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width.toInt();
    return ChangeNotifierProvider(
      create: (context) => HomepageViewModel(width),
      child: Consumer<HomepageViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text("AquaHelper"),
            backgroundColor: Colors.lightGreen,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomNavigationBar(
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
              if (!viewModel.isPremium &&
                  viewModel.anchoredAdaptiveAd != null &&
                  viewModel.isLoaded)
                Column(
                  children: <Widget>[
                    SizedBox(
                      height:
                          viewModel.anchoredAdaptiveAd!.size.height.toDouble(),
                      child: AdWidget(ad: viewModel.anchoredAdaptiveAd!),
                    ),
                  ],
                ),
            ],
          ),
          body: IndexedStack(
            index: viewModel.selectedPage,
            children: const [
              Dashboard(),
              AquariumStartPage(),
              ToolsStartPage(),
              SettingsStartPage()
            ],
          ),
        ),
      ),
    );
  }
}
