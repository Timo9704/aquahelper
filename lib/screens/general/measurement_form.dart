import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/measurement.dart';
import 'package:aquahelper/screens/aquarium/aquarium_overview.dart';
import 'package:aquahelper/config.dart';

import '../../util/datastore.dart';
import '../../util/image_selector.dart';

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
  int activeItems = 0;

  String imagePath = "assets/images/aquarium.jpg";
  bool createMode = true;
  late Measurement measurement;
  int pageCount = 0;
  DateTime selectedDate = DateTime.now();
  Map<String, Map<String, TextEditingController>> allWaterValuesWithController = {};


  Map<String, TextEditingController> waterValuesMap = {
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
  };

  @override
  void initState() {
    super.initState();
    List<bool> activeMeasurementItems = json.decode(userSettings.measurementItems).cast<bool>().toList();
    for(int i = 0; i < waterValues.length; i++){
      if(activeMeasurementItems.elementAt(i)) {
        final entry = {waterValuesTextMap.entries
            .elementAt(i)
            .key: {waterValuesTextMap.entries
            .elementAt(i)
            .value: waterValuesMap.entries
            .elementAt(i)
            .value}};
        allWaterValuesWithController.addEntries(entry.entries);
      }
    }
    activeItems = allWaterValuesWithController.length;
    if (widget.measurementId != '') {
      initExistingMeasurement();
      createMode = false;
    }
  }

  Future<void> initExistingMeasurement() async {
    Measurement measurementDbObj =
    await Datastore.db.getMeasurementById(widget.aquarium.aquariumId, widget.measurementId);
    measurement = measurementDbObj;
    for(int i = 0; i < activeItems; i++){
      allWaterValuesWithController.entries.elementAt(i).value.entries.elementAt(0).value.text
        = measurement.getValueByName(allWaterValuesWithController.entries.elementAt(i).key).toString();
    }
    setState(() {
      imagePath = measurement.imagePath;
      selectedDate = DateTime.fromMillisecondsSinceEpoch(measurement.measurementDate);
    });
  }

  Measurement getUpdatedMeasurement() {
    Map<String ,double> updateValues = {};

    for (int i = 0; i < allWaterValuesWithController.length; i++) {
      final entry = {allWaterValuesWithController.entries.elementAt(i).key : double.parse(allWaterValuesWithController.entries.elementAt(i).value.entries.elementAt(0).value.text.replaceAll(RegExp(r','), '.'))};
      updateValues.addEntries(entry.entries);
    }

    measurement.updateMeasurement(updateValues);
    measurement.updateMeasurement({"measurementDate": selectedDate.millisecondsSinceEpoch});
    measurement.updateMeasurement({"imagePath": imagePath});

    return measurement;
  }

  double parseTextFieldValue(String value){
    if(value.isEmpty){
      return 9999;
    }
    return double.parse(value.replaceAll(RegExp(r','), '.'));
  }

  Measurement getNewMeasurement() {
    Map<String ,double> updateValues = {};

    for (int i = 0; i < allWaterValuesWithController.length; i++) {
      final entry = {allWaterValuesWithController.entries.elementAt(i).key :
      parseTextFieldValue(allWaterValuesWithController.entries.elementAt(i).value.entries.elementAt(0).value.text)};
      updateValues.addEntries(entry.entries);
    }

    Measurement mes = Measurement(
        const Uuid().v4().toString(),
        widget.aquarium.aquariumId,
        9999,
        9999,
        9999,
        9999,
        9999,
        9999,
        9999,
        9999,
        9999,
        9999,
        selectedDate.millisecondsSinceEpoch,
        imagePath,
        9999,
        9999,
    );

    mes.updateMeasurement(updateValues);

    return mes;
  }

  void createMeasurementFailure() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fehlerhafte Eingabe"),
          content: const SizedBox(
            height: 80,
            child: Column(
              children: [
                Text("Kontrolliere bitte deine Eingaben! Zahlenwerte sind immer ohne Leerzeichen bzw. als Ganz- oder Kommazahl einzugeben."),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Schließen"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          elevation: 0,
        );
      },
    );
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
                    Datastore.db.deleteMeasurement(widget.aquarium.aquariumId, widget.measurementId);
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

  Color? determineValueColor(String key, double value) {
    if(userSettings.measurementLimits == 0 || value == 9999){
      return Colors.white;
    }

    final interval = waterValuesInterval[key];
    if (interval == null) {
      return Colors.red; // Falls der Schlüssel nicht existiert, gebe Rot zurück
    }

    double min = interval['min']!;
    double max = interval['max']!;
    double tolerance = 0.05; // 5% Toleranz

    if (value > min && value < max || (min == 0 && value == min)) {
      return Colors.green[300]; // Wert liegt genau im Intervall
    } else if (value == min || value == max || value <= max * (1 + tolerance) && value >= max) {
      return Colors.yellow[300]; // Wert liegt auf dem Grenzwert oder bis zu 5% darüber
    } else {
      return Colors.red[300]; // Alle anderen Fälle
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messung für ${widget.aquarium.name}'),
        backgroundColor: Colors.lightGreen
      ),
      body: ListView(children: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  String futurePath = await ImageSelector().getImage(context);
                  setState(() {
                    imagePath = futurePath;
                  });
                },
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: imagePath == 'assets/images/aquarium.jpg'
                        ? Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image.asset(imagePath, fit: BoxFit.fill),
                        const Icon(Icons.camera_alt,
                            size: 100, color: Colors.white),
                      ],
                    )
                        : Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        imagePath.startsWith('https://')
                            ? CachedNetworkImage(
                            imageUrl: imagePath,
                            fit: BoxFit.fill,
                            height: 250)
                            : ImageSelector().localImageCheck(imagePath),
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
                itemCount: allWaterValuesWithController.length,
                itemBuilder: (BuildContext context, int index) {
                  String key =  allWaterValuesWithController.entries.elementAt(index).value.entries.elementAt(0).key;
                  String identifier = allWaterValuesWithController.entries.elementAt(index).key;
                  double currentValue = 9999;
                  if(allWaterValuesWithController.entries.elementAt(index).value.entries.elementAt(0).value.text.isNotEmpty){
                    currentValue = double.parse(allWaterValuesWithController.entries.elementAt(index).value.entries.elementAt(0).value.text);
                  }
                  return Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: determineValueColor(identifier, currentValue), // Setzt die Farbe basierend auf dem Messwert
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
                            controller: allWaterValuesWithController.entries.elementAt(index).value.entries.elementAt(0).value,
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
                        onPressed: () {
                          try {
                            if (createMode) {
                              Datastore.db.insertMeasurement(
                                  getNewMeasurement());
                            } else {
                              Datastore.db.updateMeasurement(
                                  getUpdatedMeasurement());
                            }
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AquariumOverview(
                                          aquarium: widget.aquarium)),
                            );
                          } catch (e) {
                            createMeasurementFailure();
                          }
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
