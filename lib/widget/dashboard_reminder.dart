import 'package:flutter/material.dart';

class DashboardReminder extends StatelessWidget {
  const DashboardReminder({super.key});

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
        child: const Column(
          children: [
            Text('Alarme',
                style: TextStyle(fontSize: 15, color: Colors.black)),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Für heute keine Erinnerungen!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 19, color: Colors.black)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
