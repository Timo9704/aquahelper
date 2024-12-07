import 'package:aquahelper/model/aquarium.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../util/ad_helper.dart';
import '../../util/premium.dart';

class AquariumOverviewViewModel extends ChangeNotifier {
  late Aquarium aquarium;
  int selectedPage = 0;
  Premium premium = Premium();
  bool isPremium = false;
  BannerAd? anchoredAdaptiveAd;
  bool isLoaded = false;

  AquariumOverviewViewModel(this.aquarium, int width) {
    loadAd(width);
  }

  void setSelectedPage(int index) {
    selectedPage = index;
    notifyListeners();
  }

  Future<void> loadAd(int width) async {
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        width);

    anchoredAdaptiveAd = BannerAd(
      size: size!,
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          anchoredAdaptiveAd = ad as BannerAd;
          isLoaded = true;
          isPremium = await premium.isUserPremium();
          notifyListeners();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
    anchoredAdaptiveAd!.load();
  }
}
