import 'package:aquahelper/screens/tools/explorer/explorer.dart';
import 'package:aquahelper/screens/tools/fertilizer_calculator.dart';
import 'package:aquahelper/screens/tools/ground_calculator.dart';
import 'package:aquahelper/screens/tools/light_calculator.dart';
import 'package:flutter/material.dart';


class ToolsStartPage extends StatefulWidget {
  const ToolsStartPage({super.key});

  @override
  State<ToolsStartPage> createState() => _ToolsStartPageState();
}

class _ToolsStartPageState extends State<ToolsStartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        children: [
          IconTextButton(
            imagePath: 'assets/buttons/soil_calculator.png',
            text: 'Bodengrund-Rechner',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GroundCalculator()),
              );
            },
          ),
          IconTextButton(
            imagePath: 'assets/buttons/fertilizer_calculator.png',
            text: 'Dünger-Rechner',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FertilizerCalculator()),
              );
            },
          ),
          IconTextButton(
            imagePath: 'assets/buttons/explorer.png',
            text: 'Content-Explorer',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Explorer()),
              );
            },
          ),
          IconTextButton(
            imagePath: 'assets/buttons/light_calculator.png',
            text: 'Licht-Rechner',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LightCalculator()),
              );
            },
          ),
          /*IconTextButton(
            imagePath: 'assets/buttons/ai_assistant.png',
            text: 'KI-Assistant',
            onPressed: () {

            },
          ),*/
          /*IconTextButton(
            imagePath: 'assets/soil.png',
            text: 'CO2-Rechner',
            onPressed: () {

            },
          ),*/
          /*IconTextButton(
            imagePath: 'assets/soil.png',
            text: 'pH-KH-CO2-Rechner',
            onPressed: () {

            },
          )*/
        ]);
  }
}

class IconTextButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  const IconTextButton(
      {super.key, required this.imagePath, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imagePath, width: 120, height: 120),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w800),),
          ],
        ),
      ),
    );
  }
}
