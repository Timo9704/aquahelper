import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/settings_startpage_viewmodel.dart';
import 'package:aquahelper/views/settings/feedback_form.dart';
import 'package:aquahelper/views/settings/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SettingsStartPage extends StatelessWidget {
  const SettingsStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => SettingsStartPageViewModel(),
      child: Consumer<SettingsStartPageViewModel>(
        builder: (context, viewModel, child) => ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Text('Über diese App',
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(textScaleFactor),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(viewModel.infoText,
                textScaler: TextScaler.linear(textScaleFactor),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const UserSettings()),
                  ),
                },
                child: Text(
                  "Benutzereinstellungen",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            if (!viewModel.isPremium)
              Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () => viewModel.premium.showPaywall(context),
                      child: Text(
                        "AquaHelper-Premium (werbefrei)",
                        textScaler: TextScaler.linear(textScaleFactor),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: viewModel.launchFAQ,
                child: Text(
                  "FAQ",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () => viewModel.version(context),
                child: Text(
                  "Software-Version",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const FeedbackForm())),
                },
                child: Text(
                  "Bugs melden & Feedback geben",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: viewModel.launchImprint,
                child: Text(
                  "Impressum",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () => viewModel.launchprivacyPolicy(),
                child: Text(
                  "Datenschutzbestimmungen",
                  textScaler: TextScaler.linear(textScaleFactor),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
