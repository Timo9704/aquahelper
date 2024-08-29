import 'package:aquahelper/util/premium.dart';
import 'package:flutter/material.dart';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/widget/aquarium_item.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../ad_helper.dart';
import '../../util/datastore.dart';


class AquariumStartPage extends StatefulWidget {
  const AquariumStartPage({super.key});

  final String title = 'AquaHelper';

  @override
  State<AquariumStartPage> createState() => _AquariumStartPageState();
}

class _AquariumStartPageState extends State<AquariumStartPage> {
  List<Aquarium> aquariums = [];
  Premium premium = Premium();
  bool _isPremium = false;



  @override
  void initState(){
    super.initState();
    loadAquariums();
    createBannerAd();
  }

  BannerAd? createBannerAd(){
    return BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdHelper.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  void loadAquariums() async {
    _isPremium = await premium.isUserPremium();
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      aquariums = dbAquariums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: aquariums.isEmpty
                ? const Center(
              child: Text("Lege dein erstes Aquarium an!",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            )
                : ListView.builder(
              itemCount: aquariums.length,
              itemBuilder: (context, index) {
                premium.isUserPremium();
                BannerAd? bannerAd = createBannerAd();
                  return Column(
                    children:[
                      AquariumItem(aquarium: aquariums.elementAt(index)),
                      if(!_isPremium)
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              height: bannerAd!.size.height.toDouble(),
                              width: bannerAd.size.width.toDouble()-20,
                              child: AdWidget(ad: bannerAd),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                    ]
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

}