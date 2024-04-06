import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/components/filter.dart';
import '../../util/scalesize.dart';

class FilterItem extends StatelessWidget {

  final Filter filter;
  FilterItem({super.key, required this.filter});

  final List<String> _filterTypes = ["Innenfilter", "Außenfilter", "Hang-On-Filter", "Bodenfilter", "Lufthebe-Filter", "HMF"];

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Filter",
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
                  child: Text(filter.manufacturerModelName,
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text("Filtertyp",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.start),
                ),
                Expanded(
                  child: Text(_filterTypes[filter.filterType],
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text("Fördermenge",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.start),
                ),
                Expanded(
                  child: Text("${filter.flowRate} L/h",
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
                  child: Text("${filter.power} Watt",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text("letzte Reinigung:",
                      textScaler: TextScaler.linear(textScaleFactor),
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.start),
                ),
                Expanded(
                  child: Text(DateFormat('dd.MM.yyyy')
                    .format(DateTime.fromMillisecondsSinceEpoch(filter.lastMaintenance)),
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