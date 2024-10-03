import 'package:flutter/material.dart';

import '../../util/scalesize.dart';

class NewsItem extends StatelessWidget {
  final String date;
  final String text;

  const NewsItem({super.key, required this.date, required this.text});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = 0;
    double textSize = 18;
    textScaleFactor = ScaleSize.textScaleFactor(context);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date,
                textScaler: TextScaler.linear(textScaleFactor),
                style: TextStyle(fontSize: textSize, color: Colors.black)),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(text,
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: TextStyle(fontSize: textSize, color: Colors.black)),
            ),
          ],
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width - 20,
          decoration: const BoxDecoration(color: Colors.lightGreen),
        ),
        const SizedBox(height: 5)
      ],
    );
  }
}