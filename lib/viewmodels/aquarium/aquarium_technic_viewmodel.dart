import 'package:flutter/material.dart';
import '../../model/aquarium.dart';
import '../../model/components/filter.dart';
import '../../model/components/heater.dart';
import '../../model/components/lighting.dart';
import '../../util/datastore.dart';

class AquariumTechnicViewModel extends ChangeNotifier {
  Filter? filter;
  Lighting? lighting;
  Heater? heater;
  Aquarium? aquarium;

  initAquariumTechnic(Aquarium initAquarium) {
    aquarium = initAquarium;
    refresh();
  }

  void refresh() {
    loadComponents();
  }

  Future<void> loadComponents() async {
    List<Filter> filterList = await Datastore.db.getFilterByAquarium(aquarium!.aquariumId);
    if(filterList.isNotEmpty) {
      filter = filterList.first;
    }else{
      filter = Filter(
        "",
        "",
        "",
        0,
        0,
        0,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
    List<Lighting> lightingList = await Datastore.db.getLightingByAquarium(aquarium!.aquariumId);
    if(lightingList.isNotEmpty) {
      lighting = lightingList.first;
    }else{
      lighting = Lighting(
          "",
          "",
          "",
          0,
          0,
          0,
          0
      );
    }
    List<Heater> heaterList = await Datastore.db.getHeaterByAquarium(aquarium!.aquariumId);
    if(heaterList.isNotEmpty) {
      heater = heaterList.first;
    }else{
      heater = Heater(
          "",
          "",
          "",
          0
      );
    }
    notifyListeners();
  }
}
