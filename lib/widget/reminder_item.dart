import 'package:flutter/material.dart';

class ReminderItem extends StatelessWidget {
  final String name;
  final int dueDay;

  const ReminderItem(
      {super.key, required this.name, required this.dueDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all(10.0)),
      onPressed: () {

      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(name,
              style: TextStyle(fontSize: 15, color: Colors.black)),
          Text('fällig in $dueDay Tagen',
              style: const TextStyle(fontSize: 10, color: Colors.black)
          ),
        ],
      ),
    )
    );
  }
}
