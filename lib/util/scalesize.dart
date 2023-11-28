import 'package:flutter/material.dart';
import 'dart:math';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 2000) * maxTextScaleFactor;
    return max(0.9, min(val, maxTextScaleFactor));
  }
}