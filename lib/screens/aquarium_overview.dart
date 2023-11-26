import 'dart:io';

import 'package:aquahelper/model/measurement.dart';
import 'package:aquahelper/screens/chart_analysis.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:flutter/material.dart';

import '../model/aquarium.dart';
import '../widget/measurement_item.dart';
import 'measurement_form.dart';

class AquariumOverview extends StatefulWidget{
  final Aquarium aquarium;

  const AquariumOverview({Key? key, required this.aquarium}) : super(key: key);

  @override
  _AquariumOverviewState createState() => _AquariumOverviewState();
}

class _AquariumOverviewState extends State<AquariumOverview>{
  List<Measurement> measurementList = [];

  @override
  void initState(){
    super.initState();
    loadMeasurements();
  }

  void loadMeasurements() async {
    List<Measurement> dbMeasurements = await DBHelper.db.getMeasurmentsList(
        widget.aquarium);
    setState(() {
      measurementList = dbMeasurements;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.aquarium.name),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Image.file(File(widget.aquarium.imagePath), fit: BoxFit.cover)
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alle Messungen:', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w800)),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MeasurementForm(measurementId: '',aquarium: widget.aquarium)),
                    );
                  },
                  icon: const Icon(Icons.add,
                    color: Colors.lightGreen,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: measurementList.length,
              itemBuilder: (context, index) {
                return MeasurementItem(measurement: measurementList.elementAt(index), aquarium: widget.aquarium);
              },
            ),
          ),
          ElevatedButton(onPressed: () => {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const ChartAnalysis()))
          }, child: const Text("Wasserwert-Verlauf"))
        ],
      ),
    );
  }
}