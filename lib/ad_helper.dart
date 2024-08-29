import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5870599475018009/1442923345';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5870599475018009/1442923345';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) => print('Ad failed to load: ${ad.adUnitId}, $error'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
  );

}