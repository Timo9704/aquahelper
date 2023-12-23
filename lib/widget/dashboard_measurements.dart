import 'package:flutter/material.dart';

class DashboardMeasurements extends StatelessWidget {
  const DashboardMeasurements({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(children: [
          Text('Messungen',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Messungen\n(in 30 Tage)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Icon(Icons.check_box_outlined, color: Colors.green),
                    SizedBox(
                      height: 5,
                    ),
                    Text('30x',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                  ],
                ),
                SizedBox(
                  height: 50,
                  width: 2,
                  child: ColoredBox(
                    color: Colors.grey,
                  ),
                ),
                Column(
                  children: [
                    Text('Messungen\n(gesamt)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Icon(Icons.check_box_outlined, color: Colors.green),
                    SizedBox(
                      height: 5,
                    ),
                    Text('30x',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                        )),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
