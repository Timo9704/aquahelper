import 'package:flutter/material.dart';

import '../../model/aquarium.dart';
import '../../model/measurement.dart';
import '../../util/datastore.dart';


class DashboardHealthStatusViewModel extends ChangeNotifier {
  List<Aquarium> aquariums = [];

  DashboardHealthStatusViewModel() {
    checkHealthStatus();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    aquariums = dbAquariums;
    checkHealthStatus();
    notifyListeners();
  }

  checkHealthStatus() async {
    loadAquariums();

    for (int i = 0; i < aquariums.length; i++) {
      DateTime now = DateTime.now();
      DateTime interval7 = now.subtract(const Duration(days: 7));
      DateTime interval14 = now.subtract(const Duration(days: 14));
      DateTime interval30 = now.subtract(const Duration(days: 30));
      List<Measurement> list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval7.millisecondsSinceEpoch);
      if(list.isEmpty){
        list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval14.millisecondsSinceEpoch);
        if(list.isEmpty) {
          list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval30.millisecondsSinceEpoch);
          if(list.isEmpty){
            aquariums[i].healthStatus = 3;
          }else {
            aquariums[i].healthStatus = 2;
          }
        }else{
          aquariums[i].healthStatus = 1;
        }
      }else{
        aquariums[i].healthStatus = 0;
      }
      await Datastore.db.updateAquarium(aquariums[i]);
    }
    aquariums = aquariums;
  }
}
