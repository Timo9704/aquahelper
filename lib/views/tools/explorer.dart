import 'package:aquahelper/viewmodels/tools/explorer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Explorer extends StatelessWidget {
  const Explorer({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExplorerViewModel(),
      child: Consumer<ExplorerViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
              title: const Text("Content-Explorer"),
              backgroundColor: Colors.lightGreen),
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
                icon: Icon(Icons.mic),
                label: 'Podcasts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.web),
                label: 'Webseiten',
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
