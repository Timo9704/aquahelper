import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: Image.asset('assets/images/aquarium.jpg'),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('AquaHelper-Dashboard',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w800)),
        const SizedBox(
          height: 10,
        ),
        const Text('Hier findest du alle Informationen zu deinen Aquarien:',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, color: Colors.black)),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 206,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Neuigkeiten',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black)),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                          child: const Text('Alarme',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black)),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Messungen',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                            )),
                      ),
                    ]),),
              ])
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Health Status:',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black)),
              ),
            ),
      ],
    );
  }
}
