import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_plantsposition_viewmodel.dart';
import 'package:aquahelper/views/aquarium/forms/create_or_edit_plant.dart';
import 'package:aquahelper/views/widgets/aquarium_plant_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrEditPlantsPosition extends StatelessWidget {
  final Aquarium aquarium;

  const CreateOrEditPlantsPosition({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => CreateOrEditPlantsPositionViewModel(aquarium),
      child: Consumer<CreateOrEditPlantsPositionViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Pflanzen bearbeiten"),
            backgroundColor: Colors.lightGreen,
          ),
          body: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateOrEditPlant(
                                  aquarium: viewModel.aquarium,
                                  position: details.localPosition,
                                  count: viewModel.plantCount,
                                ),
                              ))
                          .then((value) async => await viewModel.loadPlants());
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 230,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child:
                            viewModel.aquarium.imagePath.startsWith('assets/')
                                ? Image.asset(viewModel.aquarium.imagePath,
                                    fit: BoxFit.cover)
                                : viewModel.aquarium.imagePath
                                        .startsWith('https://')
                                    ? CachedNetworkImage(
                                        imageUrl: viewModel.aquarium.imagePath,
                                        fit: BoxFit.cover)
                                    : viewModel.localImageCheck(
                                        viewModel.aquarium.imagePath),
                      ),
                    ),
                  ),
                  ...viewModel.positions.map((Offset position) => Positioned(
                        left: position.dx - 25,
                        top: position.dy - 20,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Text(
                              '${viewModel.positions.indexOf(position) + 1}',
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Text(
                  'Tippe auf die Stelle im Aquarium, an der sich die Pflanze befindet, um eine Pflanze hinzuzufügen.',
                  textAlign: TextAlign.justify,
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      shrinkWrap: true,
                      children: viewModel.plantList
                          .map((plant) => AquariumPlantCard(
                                plant: plant,
                                removeButton: true,
                                onPlantDeleted: viewModel.removePlant,
                              ))
                          .toList(),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
