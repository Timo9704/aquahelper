import 'package:flutter/material.dart';

class DashboardHealthStatus extends StatelessWidget {

  const DashboardHealthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        //height: 150,
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
            Text('Health Status:',
                style: TextStyle(fontSize: 15, color: Colors.black)),
            Padding(
              padding:EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child:Column(
                    children: [
                      Icon(Icons.lightbulb, size: 50,color: Colors.green),
                      SizedBox(height: 10),
                      Text('Alpen 60P')
                    ],
                  ),
                  ),
                  Expanded(
                    child: Column(
                    children: [
                      Icon(Icons.lightbulb, size: 50, color: Colors.green),
                      SizedBox(height: 10),
                      Text('Dragon Mini M')
                    ],
                  ),
                  ),
                  Expanded(
                    child: Column(
                    children: [
                      Icon(Icons.lightbulb, size: 50, color: Colors.green),
                      SizedBox(height: 10),
                      Text('Cube 20 L')
                    ],
                  ),
                  ),
              ],
            ))],
        ),)
    );
  }
}
