
import 'package:aquahelper/model/components/heater.dart';
import 'package:aquahelper/widget/aquarium_components/lighting_item.dart';
import 'package:flutter/material.dart';

import 'package:aquahelper/model/aquarium.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../ad_helper.dart';
import '../../model/components/filter.dart';
import '../../model/components/lighting.dart';
import '../../util/datastore.dart';
import '../../util/premium.dart';
import '../../widget/aquarium_components/filter_item.dart';
import '../../widget/aquarium_components/heater_item.dart';
import 'component/create_or_edit_component.dart';

class AquariumComponents extends StatefulWidget {
  const AquariumComponents({super.key, required this.aquarium});

  final Aquarium aquarium;

  @override
  State<AquariumComponents> createState() => _AquariumComponentsState();
}

class _AquariumComponentsState extends State<AquariumComponents> {
  Filter? filter;
  Lighting? lighting;
  Heater? heater;
  Premium premium = Premium();
  bool _isPremium = false;
  BannerAd? _bannerAd;

  Future<void> loadComponents() async {
    _isPremium = await premium.isUserPremium();
    List<Filter> filterList = await Datastore.db.getFilterByAquarium(widget.aquarium.aquariumId);
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
    List<Lighting> lightingList = await Datastore.db.getLightingByAquarium(widget.aquarium.aquariumId);
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
    List<Heater> heaterList = await Datastore.db.getHeaterByAquarium(widget.aquarium.aquariumId);
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
  }

  @override
  void initState() {
    super.initState();
    loadComponents();
    _bannerAd = createBannerAd();
  }

  BannerAd? createBannerAd(){
    return BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdHelper.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadComponents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (filter != null && lighting != null && heater != null) {
            return Column(children: <Widget>[
              if(!_isPremium)
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: MediaQuery.of(context).size.width,
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              FilterItem(filter: filter!),
              LightingItem(lighting: lighting!),
              HeaterItem(heater: heater!),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateOrEditComponent(filter: filter!, lighting: lighting!, heater: heater!, aquarium: widget.aquarium),
                      ),
                    );
                  },
                  child: const Text('Komponenten bearbeiten')),
              const SizedBox(height: 10),
            ]);
          } else {
            return const Center(child: Text('Ein Fehler ist aufgetreten'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}