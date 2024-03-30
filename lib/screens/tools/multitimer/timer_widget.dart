import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../signin.dart';
import 'button_widget.dart';

class TimerWidget extends StatefulWidget {
  final int seconds;
  const TimerWidget({super.key, this.seconds = 600});


  @override
  State<TimerWidget> createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  int maxSeconds = 10000;
  int seconds = 0;
  Timer? timer;
  bool isPremiumUser = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    maxSeconds = widget.seconds;
    seconds = maxSeconds;
    isUserPremium().then((result) {
      setState(() {
        isPremiumUser = result;
      });
    });
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

  Future<void> showPaywall() async {
    await FirebaseAnalytics.instance.logEvent(name: 'openPaywall', parameters: null);
    if (user == null) {
      showLoginRequest();
    } else {
      PaywallResult result = await RevenueCatUI.presentPaywallIfNeeded(
          "Premium",
          displayCloseButton: true);
      if (result == PaywallResult.purchased) {
        setState(() {
          isPremiumUser = true;
        });
      }
    }
  }

  void showLoginRequest() {
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
                  MaterialPageRoute(builder: (context) => const SignIn())),
                },
              ),
            ],
            elevation: 0,
          );
        },
      );
    }
  }

  void startTimer({bool reset = true}) {
    if(!isPremiumUser){
      showPaywall();
    } else {
      if (reset) {
        resetTimer();
      }

      timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          setState(() {
            if (seconds > 0) {
              seconds--;
            } else {
              stopTimer(reset: false);
            }
          });
        },
      );
    }
  }

  void stopTimer({bool reset = true}) {
    if(reset){
      resetTimer();
    }
    setState(() {
      timer?.cancel();
    });
  }

  void resetTimer() {
    setState(() => seconds = maxSeconds);
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimer(),
        const SizedBox(height: 20),
        buildTimerButton(),
      ],
  )
  );

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