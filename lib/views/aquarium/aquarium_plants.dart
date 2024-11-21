import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/aquarium.dart';
import '../../../model/plant.dart';
import '../../../util/scalesize.dart';
import '../../viewmodels/aquarium/aquarium_plants_viewmodel.dart';
import '../widgets/aquarium_plant_card.dart';
import 'forms/create_or_edit_plantsposition.dart';

class AquariumPlants extends StatelessWidget {
  final Aquarium aquarium;

  const AquariumPlants({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    var viewModel =
    Provider.of<AquariumPlantsViewModel>(context, listen: false);
    if (viewModel.aquarium != aquarium) {
      viewModel.initPlants(aquarium);
    }
    return Consumer<AquariumPlantsViewModel>(
        builder: (context, viewModel, child) => Stack(children: [
          Column(
            children: <Widget>[
              Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: viewModel.aquarium!.imagePath.startsWith('assets/')
                        ? Image.asset(viewModel.aquarium!.imagePath,
                            fit: BoxFit.fitWidth)
                        : viewModel.aquarium!.imagePath.startsWith('https://')
                            ? CachedNetworkImage(
                                imageUrl: viewModel.aquarium!.imagePath,
                                fit: BoxFit.cover)
                            : viewModel
                                .localImageCheck(viewModel.aquarium!.imagePath),
                  ),
                ),
              ]),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    viewModel.plantList.isNotEmpty
                        ? ListView(
                            shrinkWrap: true,
                            children: viewModel.plantList
                                .map(
                                  (plant) => AquariumPlantCard(
                                    plant: plant,
                                    removeButton: false,
                                    onPlantDeleted: () => {},
                                  ),
                                )
                                .toList(),
                          )
                        : AquariumPlantCard(
                            plant: Plant(
                              '1',
                              '1',
                              1,
                              'Aquarium',
                              'Micranthemum callitrichoides "Cuba"',
                              1,
                              0,
                              0,
                            ),
                            removeButton: false,
                            onPlantDeleted: () => {},
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateOrEditPlantsPosition(aquarium: viewModel.aquarium!),
                  ),
                ).then(
                  (value) => viewModel.loadPlants(),
                );
              },
              style: ButtonStyle(
                  maximumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen)),
              child: Text(
                'Pflanzen bearbeiten',
                textScaler: TextScaler.linear(textScaleFactor),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ]),
      );
  }
}
