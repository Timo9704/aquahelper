import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../model/aquarium.dart';
import 'package:aquahelper/util/dbhelper.dart';


class CreateOrEditAquarium extends StatefulWidget {
  const CreateOrEditAquarium({Key? key}) : super(key: key);

  @override
  _CreateOrEditAquariumState createState() => _CreateOrEditAquariumState();
}

class _CreateOrEditAquariumState extends State<CreateOrEditAquarium> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _literController = TextEditingController();
  int selectedOption = 1;
  String imagePath = "assets/images/aquarium.jpg";

  Future<void> getImage({required BuildContext context}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Bild zuschneiden',
              toolbarColor: Colors.lightGreen,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      GallerySaver.saveImage(croppedImage!.path, albumName: "AquaHelper");
      setState(() {
        imagePath = croppedImage!.path;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Neues Aquarium'),
        ),
        body: SingleChildScrollView(child: Container(
          padding: const EdgeInsets.all(0),
          child: Form(
            key: _formKey,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              GestureDetector(
                onTap: () => {
                  getImage(context: context)
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
                  child: imagePath == 'assets/images/aquarium.jpg'
                    ? Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                          Image.asset(imagePath,
                            fit: BoxFit.fill
                          ), // Standard-Bild
                          Icon(Icons.camera_alt, size: 100, color: Colors.white), // Kamera-Icon
                      ],
                    )
                    : Image.file(File(imagePath!), fit: BoxFit.fill, height: 250)
              ),),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: const Text('Süßwasser'),
                                  leading: Radio<int>(
                                    value: 1,
                                    groupValue: selectedOption,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('Salzwasser'),
                                  leading: Radio<int>(
                                    value: 2,
                                    groupValue: selectedOption,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedOption = value!;
                                      });
                                    },
                                  ),
                                ),
                              )
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
                          const Text("Wie heißt das Aquarium?",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _nameController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
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
                          const Text("Wie viel Liter hat das Aquarium?",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              )),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: _literController,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 180,
                          child: ElevatedButton(
                            onPressed: () => {},
                            child: const Text("Löschen"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: ElevatedButton(
                              onPressed: () => {
                              },
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
        ));
  }
}
