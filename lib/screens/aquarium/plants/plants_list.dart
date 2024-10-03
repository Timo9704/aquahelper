import 'dart:io';

import 'package:aquahelper/screens/aquarium/plants/plant_cards.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../util/ad_helper.dart';
import '../../../model/aquarium.dart';
import '../../../model/plant.dart';
import '../../../util/datastore.dart';
import '../../../util/premium.dart';
import '../../../util/scalesize.dart';
import 'create_or_edit_plants_tap.dart';

class PlantsList extends StatefulWidget {
  const PlantsList({super.key, required this.aquarium});

  final Aquarium aquarium;

  @override
  PlantsListState createState() => PlantsListState();
}

class PlantsListState extends State<PlantsList> {
  double textScaleFactor = 0;
  List<Plant> plantList = [];
  Premium premium = Premium();
  bool _isPremium = false;
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadPlants();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate() - 20);

    _anchoredAdaptiveAd = BannerAd(
      size: size!,
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  loadPlants() async {
    _isPremium = await premium.isUserPremium();
    List<Plant> loadedPlants =
        await Datastore.db.getPlantsByAquarium(widget.aquarium);
    setState(() {
      plantList = loadedPlants;
    });
  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(widget.aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Stack(children: [
      Column(
        children: <Widget>[
          Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: widget.aquarium.imagePath.startsWith('assets/')
                    ? Image.asset(widget.aquarium.imagePath,
                        fit: BoxFit.fitWidth)
                    : widget.aquarium.imagePath.startsWith('https://')
                        ? CachedNetworkImage(
                            imageUrl: widget.aquarium.imagePath,
                            fit: BoxFit.cover)
                        : localImageCheck(widget.aquarium.imagePath),
              ),
            ),
          ]),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (!_isPremium && _anchoredAdaptiveAd != null && _isLoaded)
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: _anchoredAdaptiveAd!.size.height.toDouble(),
                        child: AdWidget(ad: _anchoredAdaptiveAd!),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                plantList.isNotEmpty
                    ? ListView(
                        shrinkWrap: true,
                        children: plantList
                            .map((plant) => PlantCard(
                                  plant: plant,
                                  removeButton: false,
                                  onPlantDeleted: () => {},
                                ))
                            .toList(),
                      )
                    : PlantCard(
                        plant: Plant(
                          '1',
                          '1',
                          1,
                          'Aquarium',
                          'Micranthemum callitrichoides "Cuba"',
                          1,
                          0,
                          0,
                        ),
                        removeButton: false,
                        onPlantDeleted: () => {},
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateOrEditPlantsTap(aquarium: widget.aquarium))).then(
              (value) => loadPlants(),
            );
          },
          style: ButtonStyle(
              maximumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 50)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.lightGreen)),
          child: Text('Pflanzen bearbeiten',
              textScaler: TextScaler.linear(textScaleFactor),
              style: const TextStyle(
                fontSize: 20,
              )),
        ),
      ),
    ]);
  }
}
