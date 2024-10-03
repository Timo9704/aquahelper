import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  const IconTextButton(
      {super.key,
        required this.imagePath,
        required this.text,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {


    //TODO: switch to MVVM, this time just do it here
    double imageSize = MediaQuery.sizeOf(context).height.toInt() < 700 ? 100 : 120;

    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imagePath, width: imageSize, height: imageSize),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
