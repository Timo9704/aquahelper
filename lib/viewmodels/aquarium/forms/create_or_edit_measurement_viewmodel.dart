import 'dart:convert';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/measurement.dart';
import 'package:aquahelper/util/ad_helper.dart';
import 'package:aquahelper/util/config.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/util/premium.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_measurements_reminder_viewmodel.dart';
import 'package:aquahelper/viewmodels/dashboard_viewmodel.dart';
import 'package:aquahelper/views/aquarium/aquarium_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class CreateOrEditMeasurementViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  int activeItems = 0;
  Premium premium = Premium();
  bool isPremium = false;
  String imagePath = "assets/images/aquarium.jpg";
  bool createMode = true;
  late Measurement measurement;
  String measurementId;
  int pageCount = 0;
  DateTime selectedDate = DateTime.now();
  Map<String, Map<String, TextEditingController>> allWaterValuesWithController = {};
  InterstitialAd? interstitialAd;
  Aquarium aquarium;
  Map<String, TextEditingController> waterValuesMap;

  CreateOrEditMeasurementViewModel(this.aquarium, this.measurementId, this.waterValuesMap) {
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
    if (measurementId != '') {
      initExistingMeasurement();
      createMode = false;
    }
    createInterstitalAd();
  }

  Future<void> initExistingMeasurement() async {
    Measurement measurementDbObj =
    await Datastore.db.getMeasurementById(aquarium.aquariumId, measurementId);
    measurement = measurementDbObj;
    for(int i = 0; i < activeItems; i++){
      if(measurement.getValueByName(allWaterValuesWithController.entries.elementAt(i).key) != 9999){
        allWaterValuesWithController.entries.elementAt(i).value.entries.elementAt(0).value.text
        = measurement.getValueByName(allWaterValuesWithController.entries.elementAt(i).key).toString();
      }else{
        allWaterValuesWithController.entries.elementAt(i).value.entries.elementAt(0).value.text = "";
      }
    }
    imagePath = measurement.imagePath;
    selectedDate = DateTime.fromMillisecondsSinceEpoch(measurement.measurementDate);
    notifyListeners();
  }

  Measurement getUpdatedMeasurement() {
    Map<String ,double> updateValues = {};

    for (int i = 0; i < allWaterValuesWithController.length; i++) {
      double value = parseTextFieldValue(allWaterValuesWithController.entries.elementAt(i).value.entries.elementAt(0).value.text);
      if(value == 9999){
        continue;
      }
      final entry = {allWaterValuesWithController.entries.elementAt(i).key : value};
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
    try{
      return double.parse(value.replaceAll(RegExp(r','), '.'));
    }catch(e){
      return 9999;
    }
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
        aquarium.aquariumId,
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
        9999
    );

    mes.updateMeasurement(updateValues);

    return mes;
  }

  void createMeasurementFailure(BuildContext context) {
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

  void presentDatePicker(BuildContext context) {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      maxTime: DateTime(2100, 12, 31),
      onConfirm: (date) {
          selectedDate = date;
          notifyListeners();
      },
      currentTime: DateTime.now(),
      locale: LocaleType.de,
    );
  }

  void deleteMeasurement(BuildContext context) {
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
                    Datastore.db.deleteMeasurement(aquarium.aquariumId, measurementId);
                    Provider.of<DashboardViewModel>(context, listen: false).refresh();
                    Provider.of<AquariumMeasurementReminderViewModel>(context, listen: false).refresh();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AquariumOverview(
                                aquarium: aquarium),
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

  void createInterstitalAd() async {
    isPremium = await premium.isUserPremium();
    InterstitialAd.load(
        adUnitId: AdHelper.interstitalAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  Future<void> onPressedSave(BuildContext context) async {
    try {
      if (createMode) {
        await Datastore.db.insertMeasurement(getNewMeasurement());
      } else {
        await Datastore.db.updateMeasurement(getUpdatedMeasurement());
      }
      if(context.mounted){
        Provider.of<DashboardViewModel>(context, listen: false).refresh();
        Provider.of<AquariumMeasurementReminderViewModel>(context, listen: false).refresh();
        Navigator.pop(context);
        if (!isPremium) {
          interstitialAd?.show();
        }
      }
    } catch (e) {
      if(context.mounted){
        createMeasurementFailure(context);
      }
    }
  }

  void updateImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }
}








