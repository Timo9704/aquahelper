import 'package:flutter/material.dart';
import '../model/aquarium.dart';
import '../util/datastore.dart';
import '../util/premium.dart';

class AquariumStartpageViewModel extends ChangeNotifier {
  List<Aquarium> aquariums = [];
  Premium premium = Premium();
  bool isPremium = false;

  AquariumStartpageViewModel() {
    loadAquariums();
    isUserPremium();
  }

  void refresh(){
    loadAquariums();
  }

  void loadAquariums() async {
    aquariums = await Datastore.db.getAquariums();
    notifyListeners();
  }

  void isUserPremium() async {
    isPremium = await premium.isUserPremium();
    notifyListeners();
  }
}
