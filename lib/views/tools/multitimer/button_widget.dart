import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget{
  final String text;
  final VoidCallback onClicked;
  final Color backgroundColor;
  final Color color;

  const ButtonWidget({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.backgroundColor = Colors.lightGreen,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backgroundColor: backgroundColor,
        ),
        onPressed: onClicked,
        child: Text(
          text,
          style: TextStyle(fontSize: 17, color: color),
        ),
      );
}