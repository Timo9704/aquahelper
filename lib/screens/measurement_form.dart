// AquariumValuesPage
import 'package:flutter/material.dart';

class MeasurementForm extends StatefulWidget {
  const MeasurementForm({Key? key}) : super(key: key);

  @override
  _MeasurementFormState createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {
  final _formKey = GlobalKey<FormState>();

  Map<String, double> waterValues = {
    'Temperatur in °C': 0.0,
    'pH-Wert': 0.0,
    'Gesamthärte - GH': 0.0,
    'Karbonathärte - KH': 0.0,
    'Nitrit - NO2': 0.0,
    'Nitrat - NO3': 0.0,
    'Phosphat - PO4': 0.0,
    'Kalium - K': 0.0,
    'Eisen - FE': 0.0,
    'Magnesium - MG': 0.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wasserwerte'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: const Text('Neue Messung hinzufügen:',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://aquaristik-kosmos.de/wp-content/uploads/2022/12/Aquarium_weboptimiert_720p_low.jpg'),
                        // Bild von URL
                        //fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        children: waterValues.keys.map((key) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(key,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                    )),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    fillColor: Colors.grey,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        ).toList())
                  ),
                ],
              ),
            )));
  }
}
