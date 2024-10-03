import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path/path.dart';

import '../util/ad_helper.dart';
import '../util/premium.dart';

class HomepageViewModel extends ChangeNotifier {
  int _selectedPage = 0;
  Premium premium = Premium();
  bool isPremium = false;
  BannerAd? anchoredAdaptiveAd;
  bool isLoaded = false;

  int get selectedPage => _selectedPage;

  HomepageViewModel(int width) {
    loadAd(width);
  }

  void setSelectedPage(int index) {
    _selectedPage = index;
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
