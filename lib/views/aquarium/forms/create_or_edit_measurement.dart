import 'package:aquahelper/util/image_selector.dart';
import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_measurement_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aquahelper/model/aquarium.dart';
import 'package:provider/provider.dart';

import '../../../util/scalesize.dart';

class CreateOrEditMeasurement extends StatelessWidget {
  final Aquarium aquarium;
  final String measurementId;
  final Map<String, TextEditingController> waterValuesMap = {
    'temperature': TextEditingController(),
    'ph': TextEditingController(),
    'totalHardness': TextEditingController(),
    'carbonateHardness': TextEditingController(),
    'nitrite': TextEditingController(),
    'nitrate': TextEditingController(),
    'phosphate': TextEditingController(),
    'potassium': TextEditingController(),
    'iron': TextEditingController(),
    'magnesium': TextEditingController(),
    'conductance': TextEditingController(),
    'silicate': TextEditingController(),
    'ammonium': TextEditingController(),
  };

  CreateOrEditMeasurement(
      {super.key, required this.aquarium, required this.measurementId});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => CreateOrEditMeasurementViewModel(
          aquarium, measurementId, waterValuesMap),
      child: Consumer<CreateOrEditMeasurementViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
              title: Text('Messung für ${viewModel.aquarium.name}'),
              backgroundColor: Colors.lightGreen),
          body: ListView(
            children: [
              Form(
                key: viewModel.formKey,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        String futurePath =
                            await ImageSelector().getImage(context);
                        viewModel.imagePath = futurePath;
                      },
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: viewModel.imagePath ==
                                  'assets/images/aquarium.jpg'
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Image.asset(viewModel.imagePath,
                                        fit: BoxFit.fill),
                                    const Icon(Icons.camera_alt,
                                        size: 100, color: Colors.white),
                                  ],
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    viewModel.imagePath.startsWith('https://')
                                        ? CachedNetworkImage(
                                            imageUrl: viewModel.imagePath,
                                            fit: BoxFit.fill,
                                            height: 250)
                                        : ImageSelector().localImageCheck(
                                            viewModel.imagePath),
                                    const Icon(Icons.camera_alt,
                                        size: 100, color: Colors.white),
                                  ],
                                )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: viewModel.createMode
                            ? Text('Neue Messung hinzufügen:',
                                textAlign: TextAlign.left,
                                textScaler: TextScaler.linear(textScaleFactor),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black))
                            : Text('Messung bearbeiten:',
                                textAlign: TextAlign.left,
                                textScaler: TextScaler.linear(textScaleFactor),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black))),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: viewModel.allWaterValuesWithController.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key = viewModel
                            .allWaterValuesWithController.entries
                            .elementAt(index)
                            .value
                            .entries
                            .elementAt(0)
                            .key;
                        String identifier = viewModel
                            .allWaterValuesWithController.entries
                            .elementAt(index)
                            .key;
                        double currentValue = 9999;
                        if (viewModel.allWaterValuesWithController.entries
                            .elementAt(index)
                            .value
                            .entries
                            .elementAt(0)
                            .value
                            .text
                            .isNotEmpty) {
                          currentValue = viewModel.parseTextFieldValue(viewModel
                              .allWaterValuesWithController.entries
                              .elementAt(index)
                              .value
                              .entries
                              .elementAt(0)
                              .value
                              .text);
                        }
                        return Card(
                          elevation: 10,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: viewModel.determineValueColor(
                                  identifier, currentValue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(key,
                                    textScaler: TextScaler.linear(textScaleFactor),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    )),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  controller: viewModel
                                      .allWaterValuesWithController.entries
                                      .elementAt(index)
                                      .value
                                      .entries
                                      .elementAt(0)
                                      .value,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Datum und Uhrzeit: ${DateFormat('dd.MM.yyyy – kk:mm').format(viewModel.selectedDate)}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5.0), // Radius anpassen für stärkere Abrundung
                          ),
                        ),
                      ),
                      onPressed: () => viewModel.presentDatePicker(context),
                      child: Text(
                        textScaler: TextScaler.linear(textScaleFactor),
                        'Datum/Uhrzeit ändern',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (!viewModel.createMode)
                          SizedBox(
                            width: 160,
                            child: ElevatedButton(
                              onPressed: () =>
                                  viewModel.deleteMeasurement(context),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5.0), // Radius anpassen für stärkere Abrundung
                                  ),
                                ),
                              ),
                              child: Text(
                                "Löschen",
                                textScaler: TextScaler.linear(textScaleFactor),
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightGreen),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5.0), // Radius anpassen für stärkere Abrundung
                                  ),
                                ),
                              ),
                              onPressed: () => viewModel.onPressedSave(
                                  context),
                              child: Text("Speichern",
                                  textScaler: TextScaler.linear(textScaleFactor),
                                  style: const TextStyle(color: Colors.black))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
