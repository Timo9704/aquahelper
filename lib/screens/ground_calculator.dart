import 'package:flutter/material.dart';
import 'infopage.dart';

class GroundCalculator extends StatefulWidget {
  const GroundCalculator({super.key});

  @override
  State<GroundCalculator> createState() => _GroundCalculatorState();
}

class _GroundCalculatorState extends State<GroundCalculator> {
  String? _selectedGround = "Soil";
  final List<String> _groundNames = ["Soil", "Kies", "Sand"];

  String ergebnis = "";

  final _aquariumHeightController = TextEditingController();
  final _aquariumDepthController = TextEditingController();
  final _startHeightController = TextEditingController();
  final _endHeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void calculateGround() {
    int start = int.parse(_startHeightController.text);
    int end = int.parse(_endHeightController.text);
    double rectVol = 0;
    if(start > 0){
      rectVol = start * int.parse(_aquariumDepthController.text) * int.parse(_aquariumHeightController.text) / 1000;
      end -= start;
    }
    double triangleVol = (end * int.parse(_aquariumDepthController.text) / 2) *
        int.parse(_aquariumHeightController.text) /
        1000;
    triangleVol += rectVol;
    String result = "";

    if (_selectedGround == "Soil") {
      result = "${triangleVol.round()} Liter Soil";
    } else if (_selectedGround == "Sand") {
      result = "${(triangleVol * 1.9).round()} Kilogramm Sand";
    } else if (_selectedGround == "Kies") {
      result = "${(triangleVol * 1.5).round()} Kilogramm Kies";
    }

    setState(() {
      ergebnis = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Bodengrund-Rechner"),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Informationen"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              }
            }),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text("Berechne die benötigte Bodengrund-Menge:",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset('assets/quader.png')),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Aquarium Länge (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _aquariumHeightController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Aquarium Tiefe (in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _aquariumDepthController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bodengrund-Höhe (vorn in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _startHeightController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2 - 25,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Bodengrund-Höhe (hinten in cm)",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _endHeightController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Wähle deine Bodengrund-Art:',
                    style: TextStyle(fontSize: 15, color: Colors.black)),
                DropdownButton<String>(
                  value: _selectedGround,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGround = newValue;
                    });
                  },
                  items: _groundNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(fontSize: 15, color: Colors.black)),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Du benötigst ungefähr: $ergebnis",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () => {calculateGround()},
                      child: const Text("Berechnen")),
                )
              ],
            ),
          ),
        ));
  }
}
