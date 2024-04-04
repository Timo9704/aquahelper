import 'package:aquahelper/screens/tools/multitimer/timer_widget.dart';
import 'package:aquahelper/model/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../util/datastore.dart';

class MultiTimer extends StatefulWidget {
  const MultiTimer({super.key});

  @override
  State<MultiTimer> createState() => MultiTimerState();
}

class MultiTimerState extends State<MultiTimer> {
  List<Widget> timerWidgetList = [];
  List<CustomTimer> timerList = [];

  @override
  void initState() {
    super.initState();
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
    setState(() {
      timerList.clear();
      timerWidgetList.clear();
      getAndInsertTimer();
    });
  }

  void addCustomTimerWidget(CustomTimer customTimer){
    setState(() {
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
    });
  }

  void addTimer(){
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
                    showFailureDialog();
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

  void showFailureDialog(){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Multi-Timer"),
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text("Hier kannst du mehrere Timer gleichzeitig laufen lassen. So behältst du den Überblick über alle laufenden Messungen.", style: TextStyle(fontSize: 16),textAlign: TextAlign.justify),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: timerWidgetList,
                ),
                const SizedBox(
                  height: 20,
                ),
                IconButton(onPressed: () => {addTimer()}, icon: const Icon(Icons.add_circle, color: Colors.lightGreen, size: 50,)),
                const Text("Timer hinzufügen", style: TextStyle(fontSize: 20)),
                if(timerWidgetList.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () => {
                            for(int i = 0; i < timerList.length; i++) {
                              Datastore.db.insertCustomTimer(timerList[i]),
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          ),
                          child: const Text("Timer als Vorlage speichern")),
                    ],
                  )
              ],
          ),
        )));
  }
}