import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

class FeedbackFormViewModel extends ChangeNotifier {
  final mailController = TextEditingController();
  final titleController = TextEditingController();
  String title = "Was funktioniert nicht? (Kurz-Titel)";
  final descriptionController = TextEditingController();
  String description = "Beschreibung & Schritte zur Nachstellung";
  double textScaleFactor = 0;
  int ticketType = 0;
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  String infoText =
      'Hast du einen Fehler in der App gefunden oder möchtest du ein neues Feature vorschlagen? '
      'Hier kannst du ganz einfach Bugs und Fehler melden oder neue Features vorschlagen. '
      'Bitte beschreibe den Fehler oder das Feature so genau wie möglich und verwendete eine aussagekräftige Überschrift. '
      'Gebe gerne deine E-Mail für Rückfragen an!';

  FeedbackFormViewModel() {
    initPackageInfo();
  }

  void setTicketType(int type){
    ticketType = type;
    notifyListeners();
  }

  Future<void> initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  void sendRequest(String mail, String title, String description, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    String local = "Ja";

    if(user != null && user.uid.isNotEmpty){
      local = "Nein";
    }

    if(ticketType == 0) {
      title = "BUG: $title";
    }else{
      title = "FEATURE-REQUEST: $title";

    }
    if(description.isNotEmpty){
      description += "\n App-Version: ${packageInfo.version}\n Lokal: $local \n Email: $mail";
      const idList = String.fromEnvironment('TRELLO_LIST_KEY');
      const apiKey = String.fromEnvironment('TRELLO_API_KEY');
      const apiToken = String.fromEnvironment('TRELLO_API_TOKEN');

      final httpResponse = await  http.post(
        Uri.parse('https://api.trello.com/1/cards?idList=$idList&key=$apiKey&token=$apiToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          "name": title,
          "desc": description,
          "pos": "top",
          "idLabels": "65b7812e9217e9bccd548217",
        }),
      );

      if(context.mounted) {
        if (httpResponse.statusCode == 200) {
          successSnackBar(context);
        } else {
          failureSnackBar(context);
        }
      }
    }else{
      failureSnackBar(context);
    }
  }

  void successSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.lightGreen,
        content: Text('Bug/Feedback wurde erfolgreich gesendet'),
      ),
    );
    Navigator.pop(context);
  }

  void failureSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fehler beim Senden des Bugs/Feedback'),
      ),
    );
  }


}