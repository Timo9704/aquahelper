import 'package:aquahelper/model/user_settings.dart';
import 'package:aquahelper/screens/usermanagement/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../util/config.dart';
import '../../util/firebasehelper.dart';
import '../../viewmodels/settings/user_settings_viewmodel.dart';
import '../../views/homepage.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserSettingsViewModel(),
      child: Consumer<UserSettingsViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Benutzereinstellungen"),
            backgroundColor: Colors.lightGreen,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Column(children: [
                  Text(viewModel.loginText,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 16)),
                ]),
              ),
              const SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Icon(Icons.account_circle,
                        size: 50, color: Colors.lightGreen),
                    viewModel.user?.email != null
                        ? Text(
                            viewModel.user!.email!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Du bist nicht angemeldet!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                  ]),
              if (viewModel.user != null)
                ExpansionTile(
                  title: const Text('Konto-Einstellungen'),
                  subtitle: const Text('Passwort, Premium, Löschung'),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        viewModel.isPremiumUser
                            ? const Column(
                                children: [
                                  Text(
                                    'Premium-Version',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Dein Abo kannst du über den Play Store verwalten.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Free-Version',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => viewModel.showDeleteRequest(context),
                        child: const Text(
                          'AquaHelper-Konto löschen',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              viewModel.user != null
                  ? ElevatedButton(
                      onPressed: () => {
                        FirebaseHelper.db.signOut(),
                        Purchases.logOut(),
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Homepage()))
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[300]!)),
                      child: const Text(
                        'Ausloggen',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SignIn()))
                      },
                      child: const Text(
                        'Bei AquaHelper anmelden',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(viewModel.infoText,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    ExpansionTile(
                      title: const Text('Messung-Einstellungen'),
                      subtitle: const Text('Wähle deine Wasserwerte aus!'),
                      children: <Widget>[
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.5,
                          ),
                          itemCount: waterValues.length,
                          itemBuilder: (BuildContext context, int index) {
                            String key = waterValuesTextMap.entries
                                .elementAt(index)
                                .value;
                            return Column(
                              children: [
                                Text(key),
                                Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.all(
                                      Colors.lightGreen),
                                  value: viewModel.measurementItemsList[index],
                                  onChanged: (bool? value) => {
                                    viewModel.measurementItemsList[index] =
                                        value!,
                                    viewModel.us.measurementItems = viewModel
                                        .measurementItemsList
                                        .toString(),
                                    viewModel.saveSettings()
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Messwerte-Limits'),
                      subtitle:
                          const Text('Stelle deine Messwerte-Limits ein!'),
                      children: <Widget>[
                        Column(
                          children: [
                            const Text(
                                'Grenzwerte für Wasserwerte visuell dargestellen?\n grün = optimal, gelb = grenzwertig, rot = schlecht'),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.all(Colors.lightGreen),
                              value: viewModel.measurementLimits,
                              onChanged: (bool? value) {
                                viewModel.measurementLimits = value!;
                                viewModel.us.measurementLimits = value ? 1 : 0;
                                viewModel.saveSettings();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
