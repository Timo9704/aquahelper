import 'package:aquahelper/screens/measurement_form.dart';
import 'package:flutter/material.dart';

import '../model/measurement.dart';

class MeasurementItem extends StatelessWidget{
  final Measurement measurement;
  MeasurementItem({super.key, required this.measurement});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all(10.0)
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MeasurementForm()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Messung vom', style: const TextStyle(fontSize: 18, color: Colors.black)),
          Text(measurement.measurementDate.toIso8601String(), style: TextStyle(fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }
}