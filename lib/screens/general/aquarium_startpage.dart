import 'package:aquahelper/util/premium.dart';
import 'package:flutter/material.dart';

import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/widget/aquarium_item.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../ad_helper.dart';
import '../../util/datastore.dart';
import 'create_or_edit_aquarium.dart';


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
      size: AdSize.banner,
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
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Alle Aquarien:', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w800)),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateOrEditAquarium()),
                ),
                icon: const Icon(Icons.add,
                  color: Colors.lightGreen,
                ),
              ),
            ],
          ),
        ),
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
                              width: MediaQuery.of(context).size.width, // Nimmt die volle Breite des Bildschirms
                              height: bannerAd!.size.height.toDouble(),
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
      );
  }

}