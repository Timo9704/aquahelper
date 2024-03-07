import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../util/scalesize.dart';
import '../homepage.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  FeedbackFormState createState() => FeedbackFormState();
}

class FeedbackFormState extends State<FeedbackForm> {
  final _titleController = TextEditingController();
  String title = "Was funktioniert nicht? (Kurz-Titel)";
  final _descriptionController = TextEditingController();
  String description = "Beschreibung & Schritte zur Nachstellung";
  double textScaleFactor = 0;
  int ticketType = 0;

  @override
  void initState() {
    super.initState();
  }

  String infoText =
      'Hast du einen Fehler in der App gefunden oder möchtest du ein neues Feature vorschlagen? '
      'Hier kannst du ganz einfach Bugs und Fehler melden oder neue Features vorschlagen. '
      'Bitte beschreibe den Fehler oder das Feature so genau wie möglich und verwendete eine aussagekräftige Überschrift. '
      'Bitte gebe keine personenbezogene Daten an.';

  void sendRequest(String title, String description) async {
    if(ticketType == 0) {
      title = "BUG: $title";
    }else{
      title = "FEATURE-REQUEST: $title";

    }
    if(description.isNotEmpty){
      final httpResponse = await  http.post(
        Uri.parse('https://api.trello.com/1/cards?idList=65d20760344a48e372e37eb6&key=c188c3c92a0aad1e758b0b2906333e2e&token=ATTA405c2ffdd1dee47167de493aba271230aa38376af1cd1abe8de82dfd1d9aedaaA334B02A'),
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

      if (httpResponse.statusCode == 200) {
        successSnackBar();
      } else {
        failureSnackBar();
      }
    }else{
      failureSnackBar();
    }
  }

  void successSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bug/Feedback wurde erfolgreich gesendet'),
      ),
    );
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) {return const Homepage();
        }), (route) => false);
  }

  void failureSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fehler beim Senden des Bugs/Feedback'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Bugs und Feedback melden"),
          backgroundColor: Colors.lightGreen,
        ),
        body:ListView(
        children: [
        Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(infoText,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Was möchtest du melden?",
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
                              groupValue: ticketType,
                              onChanged: (int? value) {
                                setState(() {
                                  ticketType = value!;
                                  if(ticketType == 0){
                                    title = "Was funktioniert nicht? (Kurz-Titel)";
                                    description = "Beschreibung & Schritte zur Nachstellung";
                                  }
                                });
                              },
                            ),
                            Text(
                              'Bug/Fehler',
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
                              groupValue: ticketType,
                              onChanged: (int? value) {
                                setState(() {
                                  ticketType = value!;
                                  if(ticketType == 1){
                                    title = "Welches Feature wünschst du dir? (Kurz-Titel)";
                                    description = "Beschreibung des neuen Features";
                                  }
                                });
                              },
                            ),
                            Text(
                              'Feature-Wunsch',
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
                      Text(title,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        controller: _titleController,
                        cursorColor: Colors.black,
                        maxLength: 50,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
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
                      Text(description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.center,
                        controller: _descriptionController,
                        cursorColor: Colors.black,
                        maxLines: 5,
                        maxLength: 500,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      elevation: 0,
                    ),
                    onPressed: () {
                      sendRequest(_titleController.text, _descriptionController.text);
                    },
                    child: const Text("Bug/Feedback absenden"),
                  ),
                ),
              ],
            ))]));
  }
}
