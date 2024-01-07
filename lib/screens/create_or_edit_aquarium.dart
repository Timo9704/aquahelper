import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:aquahelper/main.dart';
import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/screens/infopage.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:aquahelper/util/scalesize.dart';

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
  int waterType = 0;
  bool createMode = true;
  String imagePath = "assets/images/aquarium.jpg";
  late Aquarium aquarium;

  @override
  void initState() {
    super.initState();

    if (widget.aquarium != null) {
      aquarium = widget.aquarium!;
      imagePath = aquarium.imagePath;
      waterType = aquarium.waterType;
      _nameController.text = aquarium.name;
      _literController.text = aquarium.liter.toString();
      createMode = false;
    }
  }

  void syncValuesToObject() {
    if (widget.aquarium == null) {
      String uuid = const Uuid().v4().toString();
      aquarium = Aquarium(uuid, _nameController.text,
          int.parse(_literController.text), waterType, 0, imagePath);
    } else {
      aquarium.name = _nameController.text;
      aquarium.liter = int.parse(_literController.text);
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
          title: createMode
              ? const Text('Neues Aquarium')
              : const Text('Aquarium bearbeiten'),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Informationen"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              }
            }),
          ],
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
                                  Image.file(File(imagePath),
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
                                        groupValue: waterType,
                                        onChanged: (int? value) {
                                          setState(() {
                                            waterType = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Süßwasser',
                                        textScaleFactor:
                                            ScaleSize.textScaleFactor(context),
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
                                        groupValue: waterType,
                                        onChanged: (int? value) {
                                          setState(() {
                                            waterType = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Salzwasser',
                                        textScaleFactor:
                                            ScaleSize.textScaleFactor(context),
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
                                      controller: _literController,
                                      style: const TextStyle(fontSize: 20),
                                      decoration: const InputDecoration(
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
                                      controller: _literController,
                                      style: const TextStyle(fontSize: 20),
                                      decoration: const InputDecoration(
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
                                      controller: _literController,
                                      style: const TextStyle(fontSize: 20),
                                      decoration: const InputDecoration(
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
                                  onPressed: () => {
                                    DBHelper.db
                                        .deleteAquarium(aquarium.aquariumId),
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const AquaHelper()),
                                        (Route<dynamic> route) => false)
                                  },
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
                                        if (createMode)
                                          {DBHelper.db.insertAquarium(aquarium)}
                                        else
                                          {
                                            DBHelper.db.updateAquarium(aquarium)
                                          },
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const AquaHelper()))
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
