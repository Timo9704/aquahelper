import 'package:aquahelper/screens/measurement_form.dart';
import 'package:flutter/material.dart';

class MeasurementItem extends StatelessWidget{
  int index = 0;
  MeasurementItem(int number, {super.key}){
    index = number;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        alignment: Alignment.topLeft,
        backgroundColor: MaterialStateProperty.all<Color>(const Color(
            0xFF5D5D5D)),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MeasurementForm()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Messung $index', style: const TextStyle(fontSize: 18, color: Colors.white)),
          const Text('20.06.2023', style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }
}