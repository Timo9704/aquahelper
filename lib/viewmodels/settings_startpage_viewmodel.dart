import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../util/premium.dart';

class SettingsStartPageViewModel extends ChangeNotifier {
  Premium premium = Premium();
  bool isPremium = false;
  double textScaleFactor = 0;
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  String infoText =
      'AquaHelper ist die ultimative App für alle Aquarianer und Aquascaper. '
      'Der AquaHelper bietet dir eine einfache und effiziente Möglichkeit Wasserwerte zu verfolgen und zu speichern. '
      'Du kannst wichtige Wasserparameter wie pH-Wert, Härte, Nitratgehalt und vieles mehr schnell erfassen.';

  SettingsStartPageViewModel() {
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    isPremium = await premium.isUserPremium();
    final info = await PackageInfo.fromPlatform();
    packageInfo = info;
    notifyListeners();
  }

  Future<void> launchImprint() async {
    await launchUrl(Uri.parse('https://aquaristik-kosmos.de/impressum/'));
  }

  Future<void> launchFAQ() async {
    await launchUrl(Uri.parse('https://aquaristik-kosmos.de/aquahelper-faq/'));
  }

  Future<void> launchprivacyPolicy() async {
    await launchUrl(
        Uri.parse('https://www.iubenda.com/privacy-policy/11348794'));
  }

  void version(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Software-Version"),
          content: SizedBox(
            height: 60,
            child: Column(
              children: [
                Text("App-Name: ${packageInfo.appName}"),
                Text("Versionsnummer: ${packageInfo.version}"),
                Text("Build-Nummer: ${packageInfo.buildNumber}"),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.grey)),
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
