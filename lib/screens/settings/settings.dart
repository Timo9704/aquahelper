import 'package:aquahelper/screens/settings/feedback_form.dart';
import 'package:aquahelper/screens/settings/user_settings.dart';
import 'package:aquahelper/util/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../util/premium.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  Premium premium = Premium();
  bool _isPremium = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    _isPremium = await premium.isUserPremium();
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  String infoText =
      'AquaHelper ist die ultimative App für alle Aquarianer und Aquascaper. '
      'Der AquaHelper bietet dir eine einfache und effiziente Möglichkeit Wasserwerte zu verfolgen und zu speichern. '
      'Du kannst wichtige Wasserparameter wie pH-Wert, Härte, Nitratgehalt und vieles mehr schnell erfassen.';

  Future<void> _launchImprint() async {
    await launchUrl(Uri.parse('https://aquaristik-kosmos.de/impressum/'));
  }

  Future<void> _launchFAQ() async {
    await launchUrl(Uri.parse('https://aquaristik-kosmos.de/aquahelper-faq/'));
  }

  Future<void> _launchprivacyPolicy() async {
    await launchUrl(Uri.parse('https://www.iubenda.com/privacy-policy/11348794'));
  }

  void _exportOrImport() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsOverflowAlignment: OverflowBarAlignment.center,
          title: const Text(
            "Exportieren oder importieren?",
            style: TextStyle(fontSize: 17),
          ),
          content: const SizedBox(
            height: 80,
            child: Column(
              children: [
                Text(
                    "Hier kannst du deine Daten exportieren oder importieren. Die Daten kannst du in einem Ordner in deinem Gerät speichern.")
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(10, 0, 10, 0))),
                    onPressed: () async {
                      if (await DBHelper.db.exportAllData() != "fail") {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Exportieren"),
                    ),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(10, 0, 10, 0))),
                    onPressed: () async {
                      if (await DBHelper.db.importAllData()) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Importieren"),
                )],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: const Text("Schließen"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  void _version() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Software-Version"),
          content: SizedBox(
            height: 60,
            child: Column(
              children: [
                Text("App-Name: ${_packageInfo.appName}"),
                Text("Versionsnummer: ${_packageInfo.version}"),
                Text("Build-Nummer: ${_packageInfo.buildNumber}"),
              ],
            ),
          ),
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        const Text('Über diese App',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(infoText,
            textAlign: TextAlign.justify, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              shape:
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () => {
              Navigator.push(
                context, MaterialPageRoute(
                    builder: (BuildContext context) => const UserSettingsPage())),
            },
            child: const Text("Benutzereinstellungen", style: TextStyle(color: Colors.black)),
          ),
        ),
        if(!_isPremium)
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
                    shape:
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () => premium.showPaywall(context),
                  child: const Text("AquaHelper-Premium (werbefrei)", style: TextStyle(color: Colors.black)),
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
              shape:
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: _launchFAQ,
            child: const Text("FAQ", style: TextStyle(color: Colors.black)),
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
              shape:
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: _version,
            child: const Text("Software-Version", style: TextStyle(color: Colors.black)),
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
              context, MaterialPageRoute(
              builder: (BuildContext context) => const FeedbackForm())),
              },
            child: const Text("Bugs melden & Feedback geben"),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape:
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () {
              _exportOrImport();
            },
            child: const Text("Export/Import von Daten", style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape:
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: _launchImprint,
            child: const Text("Impressum", style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape:
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () => _launchprivacyPolicy(),
            child: const Text("Datenschutzbestimmungen", style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
