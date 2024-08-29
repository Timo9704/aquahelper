import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5870599475018009/1442923345';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5870599475018009/1442923345';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (ad) => {},
    onAdFailedToLoad: (ad, error) => {},
    onAdOpened: (ad) => {},
  );
}