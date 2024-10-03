import 'package:flutter/material.dart';
import '../../model/components/lighting.dart';
import '../../util/scalesize.dart';

class LightingItem extends StatelessWidget {
  //TODO: Implement this with MVVM

  final Lighting lighting;
  const LightingItem({super.key, required this.lighting});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Flexible(
      flex: 3,
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
           Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text("Beleuchtung",
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
                  child: Text(lighting.manufacturerModelName,
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text("Helligkeit",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.start),
                ),
                Expanded(
                  child: Text("${lighting.brightness} Lumen",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text("Beleuchtungsdauer",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.start),
                ),
                Expanded(
                  child: Text("${lighting.onTime} Stunden",
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
                  child: Text("${lighting.power} Watt",
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