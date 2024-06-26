import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/aquarium.dart';
import '../model/measurement.dart';
import 'package:aquahelper/screens/general/measurement_form.dart';

class MeasurementItem extends StatelessWidget {
  final Measurement measurement;
  final Aquarium aquarium;

  const MeasurementItem(
      {super.key, required this.measurement, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all(2.0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0), // Radius anpassen für stärkere Abrundung
            ),
          ),
        ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => MeasurementForm(
                  measurementId: measurement.measurementId,
                  aquarium: aquarium)
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Messung vom',
              style: TextStyle(fontSize: 18, color: Colors.black)),
          Text(
              DateFormat('dd.MM.yyyy HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      measurement.measurementDate)),
              style: const TextStyle(fontSize: 18, color: Colors.black)
          ),
        ],
      ),
    );
  }
}
