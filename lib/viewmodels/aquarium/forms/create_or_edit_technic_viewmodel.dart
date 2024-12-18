import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/components/filter.dart';
import 'package:aquahelper/model/components/heater.dart';
import 'package:aquahelper/model/components/lighting.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_technic_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class CreateOrEditTechnicViewModel extends ChangeNotifier {
  Filter filter;
  Lighting lighting;
  Heater heater;
  Aquarium aquarium;

  final filterFormKey = GlobalKey<FormState>();
  late TextEditingController manufacturerModelNameController;
  late TextEditingController filtertypeController;
  late TextEditingController flowRateController;
  late TextEditingController powerController;
  late TextEditingController lastMaintenanceController;
  late String selectedFilterType = "Innenfilter";
  final List<String> filterTypes = ["Innenfilter", "Außenfilter", "Hang-On-Filter", "Bodenfilter", "Lufthebe-Filter", "HMF"];

  final lightFormKey = GlobalKey<FormState>();
  late TextEditingController lightManufacturerModelNameController;
  late TextEditingController lightBrightnessController;
  late TextEditingController lightOnTimeController;
  late TextEditingController lightPowerController;

  final heaterFormKey = GlobalKey<FormState>();
  late TextEditingController heaterManufacturerModelNameController;
  late TextEditingController heaterPowerController;

  CreateOrEditTechnicViewModel(this.filter, this.lighting, this.heater, this.aquarium){
    manufacturerModelNameController = TextEditingController(text: filter.manufacturerModelName);
    filtertypeController = TextEditingController(text: filter.filterType.toString());
    flowRateController = TextEditingController(text: filter.flowRate.toString());
    powerController = TextEditingController(text: filter.power.toString());
    lastMaintenanceController = TextEditingController(text: DateFormat('dd.MM.yyyy').format(DateTime.fromMillisecondsSinceEpoch(filter.lastMaintenance)));
    selectedFilterType = filterTypes[filter.filterType];

    lightManufacturerModelNameController = TextEditingController(text: lighting.manufacturerModelName);
    lightBrightnessController = TextEditingController(text: lighting.brightness.toString());
    lightOnTimeController = TextEditingController(text: lighting.onTime.toString());
    lightPowerController = TextEditingController(text: lighting.power.toString());

    heaterManufacturerModelNameController = TextEditingController(text: heater.manufacturerModelName);
    heaterPowerController = TextEditingController(text: heater.power.toString());

    aquarium = aquarium;
  }

  @override
  void dispose() {
    manufacturerModelNameController.dispose();
    filtertypeController.dispose();
    flowRateController.dispose();
    powerController.dispose();
    lastMaintenanceController.dispose();

    lightManufacturerModelNameController.dispose();
    lightBrightnessController.dispose();
    lightOnTimeController.dispose();
    lightPowerController.dispose();

    heaterManufacturerModelNameController.dispose();
    heaterPowerController.dispose();
    super.dispose();
  }

  setFilterType(String value){
    selectedFilterType = value;
    notifyListeners();
  }

  saveFilter(BuildContext context) async {
    if (filterFormKey.currentState!.validate()) {
      await Datastore.db.updateFilter(getEditedFilter());
      if(context.mounted){
        Provider.of<AquariumTechnicViewModel>(context, listen: false).refresh();
        Navigator.pop(context);
      }

    }
  }

  saveLighting(BuildContext context) async {
    if (lightFormKey.currentState!.validate()) {
      await Datastore.db.updateLighting(getEditedLighting());
      if(context.mounted){
        Provider.of<AquariumTechnicViewModel>(context, listen: false).refresh();
        Navigator.pop(context);
      }
    }
  }

  saveHeater(BuildContext context) async {
    if (heaterFormKey.currentState!.validate()) {
      await Datastore.db.updateHeater(getEditedHeater());
      if(context.mounted){
        Provider.of<AquariumTechnicViewModel>(context, listen: false).refresh();
        Navigator.pop(context);
      }
    }
  }

  double parseTextFieldValue(TextEditingController controller){
    if(controller.text.isEmpty){
      controller.text = "0.0";
      return 0.0;
    }
    controller.text = controller.text.replaceAll(RegExp(r','), '.');
    return double.parse(controller.text);
  }

  getEditedFilter() {
    DateFormat format = DateFormat("dd.MM.yyyy");
    DateTime date = format.parse(lastMaintenanceController.text);
    int lastMaintainanceEpoch = date.millisecondsSinceEpoch;

    if(filter.filterId == "") {
      return Filter(
        const Uuid().v4().toString(),
        aquarium.aquariumId,
        manufacturerModelNameController.text,
        int.parse(filtertypeController.text),
        parseTextFieldValue(powerController),
        parseTextFieldValue(flowRateController),
        lastMaintainanceEpoch,
      );
    }else{
      return Filter(
        filter.filterId,
        aquarium.aquariumId,
        manufacturerModelNameController.text,
        filterTypes.indexOf(selectedFilterType),
        parseTextFieldValue(powerController),
        parseTextFieldValue(flowRateController),
        lastMaintainanceEpoch,
      );
    }
  }

  getEditedLighting() {
    if(lighting.lightingId == "") {
      return Lighting(
          const Uuid().v4().toString(),
          aquarium.aquariumId,
          lightManufacturerModelNameController.text,
          0,
          int.parse(lightBrightnessController.text),
          parseTextFieldValue(lightOnTimeController),
          parseTextFieldValue(lightPowerController)
      );
    }else{
      return Lighting(
          lighting.lightingId,
          aquarium.aquariumId,
          lightManufacturerModelNameController.text,
          0,
          int.parse(lightBrightnessController.text),
          parseTextFieldValue(lightOnTimeController),
          parseTextFieldValue(lightPowerController)
      );
    }
  }

  getEditedHeater() {
    if(heater.heaterId == "") {
      return Heater(
          const Uuid().v4().toString(),
          aquarium.aquariumId,
          heaterManufacturerModelNameController.text,
          parseTextFieldValue(heaterPowerController)
      );
    }else{
      return Heater(
          heater.heaterId,
          aquarium.aquariumId,
          heaterManufacturerModelNameController.text,
          parseTextFieldValue(heaterPowerController)
      );
    }
  }

  Future<void> resetComponents(BuildContext context) async {
    await Datastore.db.updateFilter(Filter(
      filter.filterId,
      aquarium.aquariumId,
      "",
      0,
      0,
      0,
      DateTime.now().millisecondsSinceEpoch,
    ));
    await Datastore.db.updateLighting(Lighting(
        lighting.lightingId,
        aquarium.aquariumId,
        "",
        0,
        0,
        0,
        0
    ));
    await Datastore.db.updateHeater(Heater(
        heater.heaterId,
        aquarium.aquariumId,
        "",
        0
    ));
    notifyListeners();
    if(context.mounted){
      Provider.of<AquariumTechnicViewModel>(context, listen: false).refresh();
      Navigator.pop(context);
    }
  }
}
