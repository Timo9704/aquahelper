import 'package:flutter/material.dart';

class DashboardNews extends StatelessWidget {

  const DashboardNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          children: [
            Text('Neuigkeiten',
              style: TextStyle(fontSize: 15, color: Colors.black)),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('21.12.23',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('AquaHelper App Version v.1.0.2',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ],),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('19.12.23',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('AUSFALL: Kurzzeitiger Ausfall der App',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ],),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('18.12.23',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('NEU: Bodengrund-Rechner in v1.0.1',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ],),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text('15.12.23',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Test-Nachricht im News-Ticker',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ],),
                ],
              ),),
        ]),
      ),
    );
  }
}
