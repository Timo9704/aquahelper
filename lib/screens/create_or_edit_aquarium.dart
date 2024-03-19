import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:aquahelper/main.dart';
import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/scalesize.dart';

import '../util/datastore.dart';

class CreateOrEditAquarium extends StatefulWidget {
  final Aquarium? aquarium;

  const CreateOrEditAquarium({super.key, this.aquarium});

  @override
  CreateOrEditAquariumState createState() => CreateOrEditAquariumState();
}

class CreateOrEditAquariumState extends State<CreateOrEditAquarium> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _literController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _depthController = TextEditingController();
  int waterType = 0;
  int co2Type = 0;
  double textScaleFactor = 0;
  bool createMode = true;
  String imagePath = "assets/images/aquarium.jpg";
  late Aquarium aquarium;
  User? user = Datastore.db.user;

  @override
  void initState() {
    super.initState();

    if (widget.aquarium != null) {
      aquarium = widget.aquarium!;
      imagePath = aquarium.imagePath;
      waterType = aquarium.waterType;
      co2Type = aquarium.co2Type;
      _nameController.text = aquarium.name;
      _literController.text = aquarium.liter.toString();
      _widthController.text = aquarium.width.toString();
      _heightController.text = aquarium.height.toString();
      _depthController.text = aquarium.depth.toString();
      createMode = false;
    }
  }

  void syncValuesToObject() {
    if (widget.aquarium == null) {
      String uuid = const Uuid().v4().toString();
      aquarium = Aquarium(
          uuid,
          _nameController.text,
          int.parse(_literController.text.isEmpty ? "0" : _literController.text),
          waterType,
          co2Type,
          int.parse(_widthController.text.isEmpty ? "0" : _widthController.text),
          int.parse(_heightController.text.isEmpty ? "0" : _heightController.text),
          int.parse(_depthController.text.isEmpty ? "0" : _depthController.text),
          int.parse("0"),
          imagePath);
    } else {
      aquarium.waterType = waterType;
      aquarium.name = _nameController.text;
      aquarium.liter = int.parse(_literController.text.isEmpty ? "0" : _literController.text);
      aquarium.co2Type = co2Type;
      aquarium.width = int.parse(_widthController.text.isEmpty ? "0" : _widthController.text);
      aquarium.height = int.parse(_heightController.text.isEmpty ? "0" : _heightController.text);
      aquarium.depth = int.parse(_depthController.text.isEmpty ? "0" : _depthController.text);
      aquarium.imagePath = imagePath;
    }
  }

  Future<void> getImage({required BuildContext context}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
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
        ],
      );
      final directory = await getExternalStorageDirectory();
      final newImagePath = '${directory?.path}/images/AquaAffin';
      final imageName = DateTime.now().toIso8601String();
      final newImage = File('$newImagePath/$imageName.jpg');

      if (!await newImage.parent.exists()) {
        await newImage.parent.create(recursive: true);
      }

      File(image.path).copy(newImage.path);

      if(user != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child('${user?.uid}/$imageName.jpg');
        final file = File(croppedImage!.path);
        await imageRef.putFile(file);
        final path = await imageRef.getDownloadURL();
        setState(() {
          imagePath = path;
        });
      } else {
        setState(() {
          imagePath = croppedImage!.path;
        });
      }
    }
  }

  void _deleteAquarium() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Warnung"),
          content: const Text("Willst du dieses Aquarium wirklich löschen?"),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Nein"),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)),
                  onPressed: () {
                    Datastore.db.deleteAquarium(aquarium.aquariumId);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const AquaHelper()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text("Ja"),
                ),
              ],
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: createMode
              ? const Text('Neues Aquarium')
              : const Text('Aquarium bearbeiten'),
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => {getImage(context: context)},
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: imagePath == 'assets/images/aquarium.jpg'
                            ? Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Image.asset(imagePath, fit: BoxFit.fill),
                                  const Icon(Icons.camera_alt,
                                      size: 100, color: Colors.white),
                                ],
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  imagePath.startsWith('https://')
                                      ? CachedNetworkImage(imageUrl:imagePath,
                                          fit: BoxFit.fill, height: 250)
                                  : Image.file(File(imagePath),
                                      fit: BoxFit.fill, height: 250),
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
                                        groupValue: waterType,
                                        onChanged: (int? value) {
                                          setState(() {
                                            waterType = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Süßwasser',
                                        textScaler:
                                            TextScaler.linear(textScaleFactor),
                                        style: const TextStyle(
                                          fontSize: 25,
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
                                        groupValue: waterType,
                                        onChanged: (int? value) {
                                          setState(() {
                                            waterType = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Salzwasser',
                                        textScaler:
                                            TextScaler.linear(textScaleFactor),
                                        style: const TextStyle(
                                          fontSize: 25,
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
                                cursorColor: Colors.black,
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
                                cursorColor: Colors.black,
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
                                "Hat das Aquarium eine CO2-Versorgung?",
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
                                        groupValue: co2Type,
                                        onChanged: (int? value) {
                                          setState(() {
                                            co2Type = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'nein',
                                        textScaler:
                                            TextScaler.linear(textScaleFactor),
                                        style: const TextStyle(
                                          fontSize: 20,
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
                                        groupValue: co2Type,
                                        onChanged: (int? value) {
                                          setState(() {
                                            co2Type = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'bio./chem.',
                                        textScaler:
                                            TextScaler.linear(textScaleFactor),
                                        style: const TextStyle(
                                          fontSize: 20,
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
                                        groupValue: co2Type,
                                        onChanged: (int? value) {
                                          setState(() {
                                            co2Type = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Druckgas',
                                        textScaler:
                                            TextScaler.linear(textScaleFactor),
                                        style: const TextStyle(
                                          fontSize: 20,
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
                              const Text("Welche Maße hat das Aquarium?",
                                  style: TextStyle(
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
                                      controller: _widthController,
                                      cursorColor: Colors.black,
                                      style: const TextStyle(fontSize: 20),
                                      decoration: const InputDecoration(
                                        floatingLabelStyle:
                                            TextStyle(color: Colors.lightGreen),
                                        labelText: "Länge",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
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
                                      controller: _heightController,
                                      cursorColor: Colors.black,
                                      style: const TextStyle(fontSize: 20),
                                      decoration: const InputDecoration(
                                        floatingLabelStyle:
                                            TextStyle(color: Colors.lightGreen),
                                        labelText: "Tiefe",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
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
                                      controller: _depthController,
                                      cursorColor: Colors.black,
                                      style: const TextStyle(fontSize: 20),
                                      decoration: const InputDecoration(
                                        floatingLabelStyle:
                                            TextStyle(color: Colors.lightGreen),
                                        labelText: "Höhe",
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
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
                            if (!createMode)
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () => _deleteAquarium(),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.grey),
                                  ),
                                  child: const Text("Löschen"),
                                ),
                              ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  onPressed: () => {
                                        syncValuesToObject(),
                                        if (createMode) {
                                            Datastore.db.insertAquarium(aquarium),
                                        }
                                        else {
                                          Datastore.db.updateAquarium(aquarium)
                                        },
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const AquaHelper()))
                                      },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
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
        ));
  }
}

