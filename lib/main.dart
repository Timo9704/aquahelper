import 'package:aquahelper/screens/create_or_edit_aquarium.dart';
import 'package:aquahelper/screens/homepage.dart';
import 'package:aquahelper/screens/infopage.dart';
import 'package:aquahelper/widget/aquarium_item.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:aquahelper/util/dbhelper.dart';

import 'model/aquarium.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.db.initDB();
  runApp(const AquaHelper());
}

class AquaHelper extends StatelessWidget {
  const AquaHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaHelper',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen
      ),
      home: const Homepage(),
    );
  }
}
