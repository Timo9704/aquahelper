import 'dart:async';

import 'package:aquahelper/model/custom_timer.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/views/tools/multitimer/timer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class MultiTimerViewModel extends ChangeNotifier {
  List<Widget> timerWidgetList = [];
  List<CustomTimer> timerList = [];
  int maxSeconds = 0;
  int seconds = 0;
  Timer? timer;
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;

  MultiTimerViewModel() {
    getAndInsertTimer();

  }

  void getAndInsertTimer(){
    Datastore.db.getCustomTimer().then((value) => {
      if(value != null && value.isNotEmpty){
        value.forEach((element) {
          CustomTimer customTimer = CustomTimer(element.id, element.name, element.seconds);
          addCustomTimerWidget(customTimer);
          timerList.add(CustomTimer(element.id, element.name, element.seconds));
        })
      }
    });
  }

  void fillTimerList() {
      timerList.clear();
      timerWidgetList.clear();
      getAndInsertTimer();
      notifyListeners();
  }

  void addCustomTimerWidget(CustomTimer customTimer){
      timerWidgetList.add(
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TimerWidget(customTimer: customTimer)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(customTimer.name, style: const TextStyle(fontSize: 30)),
                        const SizedBox(height: 5),
                        IconButton(onPressed: () => {
                          Datastore.db.deleteCustomTimer(customTimer),
                          fillTimerList(),
                        }, icon: const Icon(Icons.delete, color: Colors.red, size: 30)),
                      ],),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )
      );
    notifyListeners();
  }

  void addTimer(BuildContext context){
    TextEditingController nameController = TextEditingController();
    TextEditingController durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Neuen Timer hinzufügen"),
          content: SizedBox(
            height: 210,
            child: Column(
              children: [
                const Text("Um einen neuen Timer hinzuzufügen, gib bitte den Namen und die Dauer in ganzen Minuten ein."),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Bezeichnung',
                    labelStyle: TextStyle(
                        color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    fillColor: Colors.white,
                  ),
                  controller: nameController,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Dauer in Minuten',
                    labelStyle: TextStyle(
                        color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    fillColor: Colors.white,
                  ),
                  controller: durationController,
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Schließen"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen)),
              child: const Text("Hinzufügen"),
              onPressed: () {
                if(nameController.value.text.isNotEmpty && durationController.value.text.isNotEmpty) {
                  try {
                    int duration = int.parse(durationController.value.text) * 60;
                    CustomTimer customTimer = CustomTimer(const Uuid().v4(), nameController.value.text, duration);
                    addCustomTimerWidget(customTimer);
                    maxSeconds = customTimer.seconds;
                    timerList.add(customTimer);
                    notifyListeners();
                    Navigator.pop(context);
                  } catch(e) {
                    showFailureDialog(context);
                  }
                }
              },
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  void showFailureDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Fehler beim Hinzufügen"),
          content: const Text("Bitte fülle alle Felder aus und gib die Dauer in ganzen Minuten ein."),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Schließen"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          elevation: 0,
        );
      },
    );
  }
}
