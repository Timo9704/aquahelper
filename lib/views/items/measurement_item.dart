import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/measurement.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/views/aquarium/forms/create_or_edit_measurement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class MeasurementItem extends StatelessWidget {
  final Measurement measurement;
  final Aquarium aquarium;

  const MeasurementItem(
      {super.key, required this.measurement, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
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
              builder: (context) => CreateOrEditMeasurement(
                  measurementId: measurement.measurementId,
                  aquarium: aquarium)
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Messung vom',
              textScaler: TextScaler.linear(textScaleFactor),
              style: const TextStyle(fontSize: 16, color: Colors.black)),
          Text(
              DateFormat('dd.MM.yyyy HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      measurement.measurementDate)),
              textScaler: TextScaler.linear(textScaleFactor),
              style: const TextStyle(fontSize: 16, color: Colors.black)
          ),
        ],
      ),
    );
  }
}
