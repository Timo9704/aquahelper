import 'dart:async';

import 'package:aquahelper/model/custom_timer.dart';
import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/views/login/login.dart';
import 'package:aquahelper/views/tools/multitimer/timer_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:path/path.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../views/tools/multitimer/button_widget.dart';

class MultiTimerViewModel extends ChangeNotifier {
  List<Widget> timerWidgetList = [];
  List<CustomTimer> timerList = [];
  int maxSeconds = 10000;
  int seconds = 0;
  Timer? timer;
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;

  MultiTimerViewModel() {
    getAndInsertTimer();
    maxSeconds = seconds;
    seconds = maxSeconds;
    isUserPremium().then((result) {
        isPremiumUser = result;
    });

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
                      child: TimerWidget(seconds: customTimer.seconds)),
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
                    timerList.add(customTimer);
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

  Future<bool> isUserPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return (
          customerInfo.entitlements.all["Premium"] != null &&
              customerInfo.entitlements.all["Premium"]!.isActive == true);
    } catch (e) {
      return false;
    }
  }

  Future<void> showPaywall(BuildContext context) async {
    await FirebaseAnalytics.instance.logEvent(name: 'openPaywall', parameters: null);
    if (user == null) {
      showLoginRequest(context);
    } else {
      PaywallResult result = await RevenueCatUI.presentPaywallIfNeeded(
          "Premium",
          displayCloseButton: true);
      if (result == PaywallResult.purchased) {
          isPremiumUser = true;
      }
    }
    notifyListeners();
  }

  void showLoginRequest(BuildContext context) {
    if (user == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Du bist aktuell nicht angemeldet!"),
            content: const SizedBox(
              height: 80,
              child: Column(
                children: [
                  Text(
                      "Um Premium-Features zu nutzen, musst du dich anmelden. Möchtest du jetzt dein AquaHelper-Konto anlegen?"),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey)),
                child: const Text("Zurück!"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightGreen)),
                child: const Text("Jetzt anmelden!"),
                onPressed: () => {
                  Navigator.pop(context),
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LogIn())),
                },
              ),
            ],
            elevation: 0,
          );
        },
      );
    }
  }

  void startTimer({bool reset = true, context}) {
    if(!isPremiumUser){
      showPaywall(context);
    } else {
      if (reset) {
        resetTimer();
      }

      timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
            if (seconds > 0) {
              seconds--;
            } else {
              stopTimer(reset: false);
              FlutterRingtonePlayer().play(
                android: AndroidSounds.notification,
                ios: IosSounds.glass,
                asAlarm: true,
              );
            }
        },
      );
      notifyListeners();
    }
  }

  void stopTimer({bool reset = true}) {
    if(reset){
      resetTimer();
    }
    timer?.cancel();
    notifyListeners();
  }

  void resetTimer() {
    seconds = maxSeconds;
    notifyListeners();
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  Widget buildTimerButton() {
    final isRunning = timer == null ? false: timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted ?
    Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          ButtonWidget(
            text: isRunning ? 'Pause' : 'Weiter',
            onClicked: () => {
              if(isRunning){
                stopTimer(reset: false)
              }else{
                startTimer(reset: false)
              }
            },
            backgroundColor: Colors.black,
          ),
          const SizedBox(
            width: 10,
          ),
          ButtonWidget(
            text: 'Abbruch',
            onClicked: () => {stopTimer()},
            backgroundColor: Colors.black,
          )
        ])
        : ButtonWidget(
      color: isPremiumUser ? Colors.white : Colors.black,
      backgroundColor: isPremiumUser ? Colors.lightGreen : Colors.grey,
      text: '  Timer starten  ',
      onClicked: () => {startTimer()},
    );
  }

  Widget buildTimer() {
    if(seconds == 0){
      return const Icon(Icons.done, color: Colors.greenAccent, size: 110);
    }else{
      return SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: seconds / maxSeconds,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightGreen),
              strokeWidth: 12,
            ),
            Center(child: buildTimerNumber())
          ],
        ),
      );
    }
  }

  Widget buildTimerNumber() {
    String formattedSeconds = formattedTime(timeInSecond: seconds);
    return Text(
      formattedSeconds,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }


}
