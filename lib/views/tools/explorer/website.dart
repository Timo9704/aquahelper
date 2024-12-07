import 'package:aquahelper/viewmodels/tools/explorer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Websites extends StatelessWidget {
  const Websites({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorerViewModel>(
      builder: (context, viewModel, child) => Column(
        children: [
          const SizedBox(height: 10),
          const Text('Hier findest du interessante Webseiten:',
              style: TextStyle(fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.websites.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                viewModel.launchWebsites(
                                    viewModel.websites[index][0]['url']);
                              },
                              child:
                                  Text(viewModel.websites[index][0]['name'])),
                        ),
                        const SizedBox(height: 10),
                        Text(viewModel.websites[index][0]['description'],
                            style: const TextStyle(fontSize: 10))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
