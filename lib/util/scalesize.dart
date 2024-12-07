import 'dart:math';
import 'package:flutter/material.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2.0}) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    double geometricMean = sqrt((width * 0.5) * (height * 1)) / 360;

    double val = geometricMean;

    return min(val, maxTextScaleFactor);
  }
}