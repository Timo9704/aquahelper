import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageSelector {
  String? imagePath;
  User? user = FirebaseAuth.instance.currentUser;

  Future<String> getImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final ImageSource source = await pickImageFromCameraOrGallery(context);
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Bild zuschneiden',
            toolbarColor: Colors.lightGreen,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.ratio16x9
            ],
          ),
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

      await File(image.path).copy(newImage.path);

      if (user != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child('${user?.uid}/$imageName.jpg');
        final file = File(croppedImage!.path);
        await imageRef.putFile(file);
        imagePath = await imageRef.getDownloadURL();
      } else {
        imagePath = croppedImage!.path;
        try {
          await Gal.putImage(newImage.path, album: 'AquaHelper');
        } catch (e) {
          throw Exception('Fehler beim Speichern des Bildes');
        }
      }
      return imagePath!;
    } else {
      return '';
    }
  }

  Future<ImageSource> pickImageFromCameraOrGallery(BuildContext context) async {
    final completer = Completer<ImageSource>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Padding(padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
            child:
            Column(
              children: [
            SizedBox(
            width: MediaQuery.of(context).size.width,
                child:
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey)),
                  child: const Text("Bild mit Kamera aufnehmen", style: TextStyle(fontSize: 15)),
                  onPressed: () {
                    Navigator.pop(context);
                    completer.complete(ImageSource.camera);
                  },
                ),),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey)),
                  child: const Text("Bild aus Galerie auswählen", style: TextStyle(fontSize: 15)),
                  onPressed: () {
                    Navigator.pop(context);
                    completer.complete(ImageSource.gallery);
                  },
                ),)

              ],
            ),
                )
          ],
          elevation: 0,
        );
      },
    );
    return completer.future;
  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(imagePath), fit: BoxFit.fill, height: 250);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fill);
    }
  }
}
