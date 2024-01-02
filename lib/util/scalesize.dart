import 'package:flutter/material.dart';
import 'dart:math';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1000) * maxTextScaleFactor;
    return min(val, maxTextScaleFactor);
  }
}