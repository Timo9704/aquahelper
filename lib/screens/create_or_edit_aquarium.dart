import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../model/aquarium.dart';
import 'package:aquahelper/util/dbhelper.dart';


class CreateOrEditAquarium extends StatefulWidget {
  final Aquarium? aquarium;

  const CreateOrEditAquarium({Key? key, this.aquarium}) : super(key: key);

  @override
  _CreateOrEditAquariumState createState() => _CreateOrEditAquariumState();
}

class _CreateOrEditAquariumState extends State<CreateOrEditAquarium> {
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
      _nameController.text = aquarium.name;
      _literController.text = aquarium.liter.toString();
      waterType = aquarium.waterType;
      createMode = false;
      print("Set createMode false");
    }
  }

  void syncValuesToObject(){
    if(widget.aquarium == null){
      aquarium = new Aquarium(3, _nameController.text, int.parse(_literController.text), waterType, imagePath);
    }else{
      aquarium.name = _nameController.text;
      aquarium.liter = int.parse(_literController.text);
      aquarium.imageUrl = imagePath;
    }
  }

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
      //GallerySaver.saveImage(croppedImage!.path, albumName: "AquaHelper");
      final directory = await getExternalStorageDirectory();
      final newImagePath = '${directory?.path}/images/AquaAffin';
      final newImage = File('$newImagePath/test1.jpg');

      // Erstellen Sie das Verzeichnis, falls es nicht existiert
      if (!await newImage.parent.exists()) {
        await newImage.parent.create(recursive: true);
      }

      // Kopieren Sie das Bild vom ursprünglichen Pfad in den neuen Pfad
      File(image!.path).copy(newImage.path);

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
                    borderRadius: const BorderRadius.only(
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
                          const Icon(Icons.camera_alt, size: 100, color: Colors.white),
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
                                    value: 0,
                                    groupValue: waterType,
                                    onChanged: (int? value) {
                                      setState(() {
                                        waterType = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('Salzwasser'),
                                  leading: Radio<int>(
                                    value: 1,
                                    groupValue: waterType,
                                    onChanged: (int? value) {
                                      setState(() {
                                        waterType = value!;
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
                            onPressed: () => {
                              DBHelper.db.deleteAquarium(aquarium.aquariumId),
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                builder: (BuildContext context) => AquaHelperStartPage()))
                            },
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
                                syncValuesToObject(),
                                if(createMode){
                                  print(aquarium.toMap().toString()),
                                  DBHelper.db.insertAquarium(aquarium)
                                }else{
                                  DBHelper.db.updateAquarium(aquarium)
                                },
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => AquaHelperStartPage()))},
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
