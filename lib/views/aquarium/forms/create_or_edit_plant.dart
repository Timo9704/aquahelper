import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_plant_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CreateOrEditPlant extends StatelessWidget {
  final Offset position;
  final int count;
  final Aquarium aquarium;

  const CreateOrEditPlant(
      {super.key,
      required this.aquarium,
      required this.position,
      required this.count});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) =>
          CreateOrEditPlantViewModel(aquarium, position, count),
      child: Consumer<CreateOrEditPlantViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
          appBar: AppBar(
            title: const Text("Pflanzen bearbeiten"),
            backgroundColor: Colors.lightGreen,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SizedBox(
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
                    Positioned(
                      left: viewModel.position.dx - 25,
                      top: viewModel.position.dy - 20,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Text(
                            '${viewModel.count}',
                            textScaler: TextScaler.linear(textScaleFactor),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Form(
                  key: viewModel.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: viewModel.plantNameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightGreen),
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte einen Namen eingeben';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: viewModel.latinNameController,
                          decoration: const InputDecoration(
                            labelText: 'Lateinischer Name',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightGreen),
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bitte einen lateinischen Namen eingeben';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: viewModel.amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Anzahl der Pflanzen',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightGreen),
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null) {
                              return 'Bitte eine Zahl eingeben';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(
                                        Colors.lightGreen),
                                minimumSize: WidgetStateProperty.all<Size>(
                                    const Size(200, 50)),
                              ),
                              onPressed: () => viewModel.savePlant(context),
                              child: Text('Speichern',
                                  textScaler:
                                      TextScaler.linear(textScaleFactor),
                                  style: const TextStyle(fontSize: 18)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
