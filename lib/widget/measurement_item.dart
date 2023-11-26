import 'package:aquahelper/screens/measurement_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/aquarium.dart';
import '../model/measurement.dart';

class MeasurementItem extends StatelessWidget{
  final Measurement measurement;
  final Aquarium aquarium;
  MeasurementItem({super.key, required this.measurement, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all(10.0)
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MeasurementForm(measurementId: measurement.measurementId, aquarium: aquarium)),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Messung vom', style: const TextStyle(fontSize: 18, color: Colors.black)),
          Text(DateFormat('dd.MM.yyyy').format(DateTime.fromMillisecondsSinceEpoch(measurement.measurementDate)), style: TextStyle(fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }
}