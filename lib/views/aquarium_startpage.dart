import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/aquarium_startpage_viewmodel.dart';
import 'package:aquahelper/views/items/aquarium_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'aquarium/forms/create_or_edit_aquarium.dart';

class AquariumStartPage extends StatelessWidget {
  const AquariumStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    Aquarium aquarium = Aquarium('','', 0, 0, 0, 0, 0, 0, 0, 0, 0, '');
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
                  Text('Alle Aquarien:',
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800)),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateOrEditAquarium(aquarium: aquarium)),
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
