import 'package:aquahelper/util/image_selector.dart';
import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_aquarium_viewmodel.dart';
import 'package:aquahelper/viewmodels/dashboard_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:aquahelper/model/aquarium.dart';

import 'package:aquahelper/util/scalesize.dart';
import 'package:provider/provider.dart';

class CreateOrEditAquarium extends StatelessWidget {
  final Aquarium aquarium;

  const CreateOrEditAquarium({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    DashboardViewModel dashboardViewModel =
    Provider.of<DashboardViewModel>(context, listen: true);
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => CreateOrEditAquariumViewModel(aquarium, dashboardViewModel),
      child: Consumer<CreateOrEditAquariumViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: viewModel.createMode
                ? const Text('Neues Aquarium')
                : const Text('Aquarium bearbeiten'),
            backgroundColor: Colors.lightGreen,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(0),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String futurePath =
                            await ImageSelector().getImage(context);
                        viewModel.updateImagePath(futurePath);
                      },
                      child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: viewModel.imagePath ==
                                  'assets/images/aquarium.jpg'
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Image.asset(viewModel.imagePath,
                                        fit: BoxFit.fill),
                                    const Icon(Icons.camera_alt,
                                        size: 100, color: Colors.white),
                                  ],
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    viewModel.imagePath.startsWith('https://')
                                        ? CachedNetworkImage(
                                            imageUrl: viewModel.imagePath,
                                            fit: BoxFit.fill,
                                            height: 250)
                                        : ImageSelector().localImageCheck(
                                            viewModel.imagePath),
                                    const Icon(Icons.camera_alt,
                                        size: 100, color: Colors.white),
                                  ],
                                )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Art des Aquariums",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: 0,
                                          activeColor: Colors.lightGreen,
                                          groupValue: viewModel.waterType,
                                          onChanged: (int? value) {
                                            viewModel.setWaterType(value!);
                                          },
                                        ),
                                        Text(
                                          'Süßwasser',
                                          textScaler: TextScaler.linear(
                                              textScaleFactor),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: 1,
                                          activeColor: Colors.lightGreen,
                                          groupValue: viewModel.waterType,
                                          onChanged: (int? value) {
                                            viewModel.setWaterType(value!);
                                          },
                                        ),
                                        Text(
                                          'Salzwasser',
                                          textScaler: TextScaler.linear(
                                              textScaleFactor),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Wie heißt das Aquarium?",
                                    textScaler: TextScaler.linear(textScaleFactor),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    )),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  controller: viewModel.nameController,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Wie viel Liter hat das Aquarium?",
                                    textScaler: TextScaler.linear(textScaleFactor),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    )),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  controller: viewModel.literController,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    fillColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hat das Aquarium eine CO2-Versorgung?",
                                  textScaler: TextScaler.linear(textScaleFactor),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: 0,
                                          activeColor: Colors.lightGreen,
                                          groupValue: viewModel.co2Type,
                                          onChanged: (int? value) {
                                            viewModel.setCo2Type(value!);
                                          },
                                        ),
                                        Text(
                                          'nein',
                                          textScaler: TextScaler.linear(
                                              textScaleFactor),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: 1,
                                          activeColor: Colors.lightGreen,
                                          groupValue: viewModel.co2Type,
                                          onChanged: (int? value) {
                                            viewModel.setCo2Type(value!);
                                          },
                                        ),
                                        Text(
                                          'bio./chem.',
                                          textScaler: TextScaler.linear(
                                              textScaleFactor),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: 2,
                                          activeColor: Colors.lightGreen,
                                          groupValue: viewModel.co2Type,
                                          onChanged: (int? value) {
                                            viewModel.setCo2Type(value!);
                                          },
                                        ),
                                        Text(
                                          'Druckgas',
                                          textScaler: TextScaler.linear(
                                              textScaleFactor),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welche Maße hat das Aquarium?",
                                    textScaler: TextScaler.linear(textScaleFactor),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    )),
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        controller: viewModel.widthController,
                                        cursorColor: Colors.black,
                                        style: const TextStyle(fontSize: 20),
                                        decoration: const InputDecoration(
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.lightGreen),
                                          labelText: "Länge",
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          fillColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        controller: viewModel.heightController,
                                        cursorColor: Colors.black,
                                        style: const TextStyle(fontSize: 20),
                                        decoration: const InputDecoration(
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.lightGreen),
                                          labelText: "Tiefe",
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey),
                                          ),
                                          fillColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        controller: viewModel.depthController,
                                        cursorColor: Colors.black,
                                        style: const TextStyle(fontSize: 20),
                                        decoration: const InputDecoration(
                                          floatingLabelStyle: TextStyle(
                                              color: Colors.lightGreen),
                                          labelText: "Höhe",
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                              BorderSide(color: Colors.grey),
                                          ),
                                          fillColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (!viewModel.createMode)
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () => viewModel.deleteAquarium(context, viewModel),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.grey),
                                    ),
                                    child: const Text("Löschen"),
                                  ),
                                ),
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                    onPressed: () => viewModel.saveAquarium(context),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.lightGreen)),
                                    child: const Text("Speichern")),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
