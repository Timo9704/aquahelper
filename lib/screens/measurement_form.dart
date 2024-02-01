import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/measurement.dart';
import 'package:aquahelper/screens/aquarium_overview.dart';
import 'package:aquahelper/util/dbhelper.dart';

class MeasurementForm extends StatefulWidget {
  final Aquarium aquarium;
  final String measurementId;

  const MeasurementForm(
      {super.key, required this.measurementId, required this.aquarium});

  @override
  MeasurementFormState createState() => MeasurementFormState();
}

class MeasurementFormState extends State<MeasurementForm> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> controllerList = [];
  String imagePath = "assets/images/aquarium.jpg";
  bool createMode = true;
  late Measurement measurement;
  int pageCount = 0;
  DateTime selectedDate = DateTime.now();

  List<String> waterValues = [
    'Temperatur in °C',
    'pH-Wert',
    'Gesamthärte - GH',
    'Karbonathärte - KH',
    'Nitrit - NO2',
    'Nitrat - NO3',
    'Phosphat - PO4',
    'Kalium - K',
    'Eisen - FE',
    'Magnesium - MG',
  ];

  @override
  void initState() {
    super.initState();
    initTextControllerList();
    if (widget.measurementId != '') {
      initExistingMeasurement();
      createMode = false;
    }
  }

  void initTextControllerList() {
    for (int i = 0; i < waterValues.length; i++) {
      controllerList.add(TextEditingController());
      controllerList.elementAt(i).text = '0';
    }
  }

  Future<void> initExistingMeasurement() async {
    Measurement measurementDbObj =
    await DBHelper.db.getMeasurementById(widget.measurementId);
    measurement = measurementDbObj;
    controllerList.elementAt(0).text = measurement.temperature.toString();
    controllerList.elementAt(1).text = measurement.ph.toString();
    controllerList.elementAt(2).text = measurement.totalHardness.toString();
    controllerList.elementAt(3).text = measurement.carbonateHardness.toString();
    controllerList.elementAt(4).text = measurement.nitrite.toString();
    controllerList.elementAt(5).text = measurement.nitrate.toString();
    controllerList.elementAt(6).text = measurement.phosphate.toString();
    controllerList.elementAt(7).text = measurement.potassium.toString();
    controllerList.elementAt(8).text = measurement.iron.toString();
    controllerList.elementAt(9).text = measurement.magnesium.toString();
    setState(() {
      imagePath = measurement.imagePath;
      selectedDate = DateTime.fromMillisecondsSinceEpoch(measurement.measurementDate);
    });
  }

  Map<String, dynamic> getAllTextInputs() {
    List<double> measurementInputs = [];

    for (int i = 0; i < waterValues.length; i++) {
      controllerList.add(TextEditingController());
      measurementInputs.add(double.parse(controllerList.elementAt(i).text));
    }
    Map<String, dynamic> valueMap;
    if (!createMode) {
      valueMap = {
        'measurementId': widget.measurementId,
        'aquariumId': widget.aquarium.aquariumId,
        'temperature': measurementInputs.elementAt(0),
        'ph': measurementInputs.elementAt(1),
        'totalHardness': measurementInputs.elementAt(2),
        'carbonateHardness': measurementInputs.elementAt(3),
        'nitrite': measurementInputs.elementAt(4),
        'nitrate': measurementInputs.elementAt(5),
        'phosphate': measurementInputs.elementAt(6),
        'potassium': measurementInputs.elementAt(7),
        'iron': measurementInputs.elementAt(8),
        'magnesium': measurementInputs.elementAt(9),
        'measurementDate': selectedDate.millisecondsSinceEpoch,
        'imagePath': measurement.imagePath
      };
    } else {
      valueMap = {
        'measurementId': const Uuid().v4().toString(),
        'aquariumId': widget.aquarium.aquariumId,
        'temperature': measurementInputs.elementAt(0),
        'ph': measurementInputs.elementAt(1),
        'totalHardness': measurementInputs.elementAt(2),
        'carbonateHardness': measurementInputs.elementAt(3),
        'nitrite': measurementInputs.elementAt(4),
        'nitrate': measurementInputs.elementAt(5),
        'phosphate': measurementInputs.elementAt(6),
        'potassium': measurementInputs.elementAt(7),
        'iron': measurementInputs.elementAt(8),
        'magnesium': measurementInputs.elementAt(9),
        'measurementDate': selectedDate.millisecondsSinceEpoch,
        'imagePath': imagePath
      };
    }

    return valueMap;
  }

  Future<void> getImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Bild zuschneiden',
              toolbarColor: Colors.lightGreen,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      //GallerySaver.saveImage(croppedImage!.path, albumName: "AquaHelper");
      final directory = await getExternalStorageDirectory();
      final newImagePath = '${directory?.path}/images/AquaAffin';
      final newImage = File('$newImagePath/test1.jpg');

      if (!await newImage.parent.exists()) {
        await newImage.parent.create(recursive: true);
      }

      File(image.path).copy(newImage.path);

      setState(() {
        imagePath = croppedImage!.path;
      });
    }
  }

  void _presentDatePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      maxTime: DateTime(2100, 12, 31),
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      currentTime: DateTime.now(),
      locale: LocaleType.de,
    );
  }

  void _deleteMeasurement() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warnung"),
          content:  const Text("Willst du diese Messung wirklich löschen?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Nein"),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () {
                    DBHelper.db.deleteMeasurement(widget.measurementId);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AquariumOverview(
                                aquarium: widget.aquarium),
                      ),
                    );
                  },
                  child: const Text("Ja"),
                ),
              ],
            ),
          ],
          elevation: 0,
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasserwerte'),
        backgroundColor: Colors.lightGreen
      ),
      body: ListView(children: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => {getImage(context: context)},
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: imagePath == 'assets/images/aquarium.jpg'
                        ? Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image.asset(imagePath,
                            fit: BoxFit.fill), // Standard-Bild
                        const Icon(Icons.camera_alt,
                            size: 100, color: Colors.white),
                      ],
                    )
                        : Image.file(File(imagePath), fit: BoxFit.cover)),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: createMode
                      ? const Text(' Neue Messung hinzufügen:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, color: Colors.black))
                      : const Text(' Messung bearbeiten:',
                      textAlign: TextAlign.left,
                      style:
                      TextStyle(fontSize: 20, color: Colors.black))),
              const SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: waterValues.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = waterValues[index];
                  return Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(key,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: controllerList.elementAt(index),
                            cursorColor: Colors.black,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                            ),
                          )
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
                'Datum und Uhrzeit: ${DateFormat('dd.MM.yyyy – kk:mm').format(selectedDate)}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0), // Radius anpassen für stärkere Abrundung
                    ),
                  ),
                ),
                onPressed: _presentDatePicker,
                child: const Text('Datum und Uhrzeit wählen', style: TextStyle(color: Colors.black),),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!createMode)
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () => _deleteMeasurement(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0), // Radius anpassen für stärkere Abrundung
                            ),
                          ),
                        ),
                        child: const Text("Löschen", style: TextStyle(color: Colors.black),),
                      ),
                    ),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0), // Radius anpassen für stärkere Abrundung
                            ),
                          ),
                        ),
                        onPressed: () => {
                          if (createMode) {
                              DBHelper.db.insertMeasurement(
                                  Measurement.fromMap(
                                      getAllTextInputs())),
                            } else {
                              DBHelper.db.updateMeasurement(
                                  Measurement.fromMap(
                                      getAllTextInputs())),
                          },
                          Navigator.of(context).pop(),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AquariumOverview(
                                        aquarium: widget.aquarium)),
                          )
                        },
                        child: const Text("Speichern", style: TextStyle(color: Colors.black))),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
      ),
    );
  }
}
