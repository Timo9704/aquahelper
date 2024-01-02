import 'package:aquahelper/screens/ground_calculator.dart';
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
            imagePath: 'assets/soil.png',
            text: 'Bodengrund-Rechner',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GroundCalculator()),
              );
            },
          ),
          IconTextButton(
            imagePath: 'assets/soil.png',
            text: 'Düngerrechner-Rechner',
            onPressed: () {
            },
          ),
          IconTextButton(
            imagePath: 'assets/soil.png',
            text: 'KI-Assistent',
            onPressed: () {

            },
          ),
          IconTextButton(
            imagePath: 'assets/soil.png',
            text: 'CO2-Rechner',
            onPressed: () {

            },
          ),
          IconTextButton(
            imagePath: 'assets/soil.png',
            text: 'Licht-Rechner',
            onPressed: () {

            },
          ),
          IconTextButton(
            imagePath: 'assets/soil.png',
            text: 'pH-KH-CO2-Rechner',
            onPressed: () {

            },
          )
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
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imagePath, width: 100, height: 100),
            const SizedBox(height: 10),
            Text(text, style: const TextStyle(fontWeight: FontWeight.w800),),
          ],
        ),
      ),
    );
  }
}
