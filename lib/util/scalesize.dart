import 'package:flutter/material.dart';
import 'dart:math';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 700) * maxTextScaleFactor;
    return max(1.3, min(val, maxTextScaleFactor));
  }
}