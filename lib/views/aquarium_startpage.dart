import 'package:aquahelper/views/items/aquarium_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/general/create_or_edit_aquarium.dart';
import '../viewmodels/aquarium_startpage_viewmodel.dart';

class AquariumStartPage extends StatelessWidget {
  const AquariumStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AquariumStartpageViewModel(),
      child: Consumer<AquariumStartpageViewModel>(
        builder: (context, viewModel, child) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Alle Aquarien:',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateOrEditAquarium()),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.lightGreen,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: viewModel.aquariums.isEmpty
                  ? const Center(
                      child: Text(
                        "Lege dein erstes Aquarium an!",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: viewModel.aquariums.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            AquariumItem(
                                aquarium: viewModel.aquariums.elementAt(index)),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
