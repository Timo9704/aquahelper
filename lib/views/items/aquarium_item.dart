import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../model/aquarium.dart';
import '../../util/scalesize.dart';
import '../../viewmodels/items/aquarium_item_viewmodel.dart';
import '../aquarium/aquarium_overview.dart';

class AquariumItem extends StatelessWidget {
  final Aquarium aquarium;

  const AquariumItem({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    double iconSize = MediaQuery.sizeOf(context).width < 400 ? 20 : 30;
    return ChangeNotifierProvider(
      create: (context) => AquariumItemViewModel(aquarium),
      child: Consumer<AquariumItemViewModel>(
        builder: (context, viewModel, child) => Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AquariumOverview(aquarium: viewModel.aquarium)),
                ),
                child: SizedBox(
                  height: Adaptive.h(25),
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: viewModel.aquarium.imagePath.startsWith('assets/')
                        ? Image.asset(viewModel.aquarium.imagePath,
                            fit: BoxFit.cover)
                        : viewModel.aquarium.imagePath.startsWith('https://')
                            ? CachedNetworkImage(
                                imageUrl: viewModel.aquarium.imagePath,
                                fit: BoxFit.cover)
                            : viewModel
                                .localImageCheck(viewModel.aquarium.imagePath),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: Adaptive.h(7),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.black54,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(viewModel.aquarium.name,
                              textScaler: TextScaler.linear(textScaleFactor),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 26, color: Colors.white)),
                        ),
                        Flexible(
                          flex: 1,
                          child: Text("${viewModel.aquarium.liter}L",
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 26, color: Colors.white)),
                        ),
                        Flexible(
                          flex: 1,
                          child: Stack(
                            children: <Widget>[
                              Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: iconSize,
                              ),
                              if (viewModel.taskAmount > 0)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      viewModel.taskAmount.toString(),
                                      textScaler: TextScaler.linear(textScaleFactor),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
