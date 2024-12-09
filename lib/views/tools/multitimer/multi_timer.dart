import 'package:aquahelper/util/datastore.dart';
import 'package:aquahelper/viewmodels/tools/multi_timer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultiTimer extends StatelessWidget {
  const MultiTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MultiTimerViewModel(),
      child: Consumer<MultiTimerViewModel>(
        builder: (context, viewModel, child) => Scaffold(
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
                  const Text(
                      "Hier kannst du mehrere Timer gleichzeitig laufen lassen. So behältst du den Überblick über alle laufenden Messungen.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: viewModel.timerWidgetList,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IconButton(
                      onPressed: () => {viewModel.addTimer(context)},
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.lightGreen,
                        size: 50,
                      )),
                  const Text("Timer hinzufügen",
                      style: TextStyle(fontSize: 20)),
                  if (viewModel.timerWidgetList.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () => {
                                  for (int i = 0;
                                      i < viewModel.timerList.length;
                                      i++)
                                    {
                                      Datastore.db.insertCustomTimer(
                                          viewModel.timerList[i]),
                                    },
                                    viewModel.showMessageSnackbar("Timer erfolgreich gespeichert", context),
                                },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.grey),
                            ),
                            child: const Text("Timer als Vorlage speichern")),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
