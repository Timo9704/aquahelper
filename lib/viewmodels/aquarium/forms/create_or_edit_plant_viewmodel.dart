import 'dart:io';

import 'package:flutter/material.dart';

import '../../../model/aquarium.dart';


class CreateOrEditPlantViewModel extends ChangeNotifier {
  final Offset position;
  final int count;
  final Aquarium aquarium;
  final formKey = GlobalKey<FormState>();
  final plantNameController = TextEditingController();
  final latinNameController = TextEditingController();
  final amountController = TextEditingController();

  CreateOrEditPlantViewModel(this.aquarium, this.position, this.count){

  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }
}
