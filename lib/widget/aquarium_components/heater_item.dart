import 'package:flutter/material.dart';

import '../../model/components/heater.dart';
import '../../util/scalesize.dart';

class HeaterItem extends StatelessWidget {
  final Heater heater;
  const HeaterItem({super.key, required this.heater});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Heizer",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
                  textAlign: TextAlign.start),
            ]),
            Row(
              children: [
                Expanded(
                  child: Text("Hersteller & Modell:",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.start),
                ),
                Expanded(
                  child: Text(heater.manufacturerModelName,
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text("Leistung:",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.start),
                ),
                Expanded(
                  child: Text("${heater.power} Watt",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}