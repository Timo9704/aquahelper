import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../model/animals.dart';
import '../../model/aquarium.dart';
import '../../util/ad_helper.dart';
import '../../util/datastore.dart';
import '../../util/premium.dart';
import '../../views/aquarium/forms/create_or_edit_animal.dart';

class AquariumAnimalsOverviewViewModel extends ChangeNotifier {
  double textScaleFactor = 0;
  List<Animals> fishes = [];
  List<Animals> shrimps = [];
  List<Animals> snails = [];
  Premium premium = Premium();
  bool isPremium = false;
  BannerAd? bannerAd;
  Aquarium aquarium;

  AquariumAnimalsOverviewViewModel(this.aquarium) {
    loadAnimals();
    bannerAd = createBannerAd();
  }

  BannerAd? createBannerAd(){
    return BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdHelper.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  void loadAnimals() async {
    isPremium = await premium.isUserPremium();
    List<Animals> loadedAnimals =
    await Datastore.db.getAnimalsByAquarium(aquarium);
      fishes =
          loadedAnimals.where((animal) => animal.type == 'Fische').toList();
      shrimps =
          loadedAnimals.where((animal) => animal.type == 'Garnelen').toList();
      snails =
          loadedAnimals.where((animal) => animal.type == 'Schnecken').toList();
      notifyListeners();
  }

  onPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CreateOrEditAnimal(aquarium: aquarium, animal: null)),
    ).then((value) => loadAnimals());
  }

}