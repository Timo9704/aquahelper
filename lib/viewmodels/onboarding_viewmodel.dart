import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OnBoardingViewModel extends ChangeNotifier {
  OnBoardingViewModel(){
    checkIntroShown();
  }

  bool _introShown = false;
  bool get introShown => _introShown;

  Future<void> checkIntroShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _introShown = prefs.getBool("introShown") ?? false;
    notifyListeners();
  }

  Future<void> setIntroShown(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("introShown", value);
    _introShown = value;
    notifyListeners();
  }

  Future<void> checkPrivacyPolicy(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool privacyPolicyAccepted = prefs.getBool("privacyPolicyAccepted") ?? false;
    if (!privacyPolicyAccepted && context.mounted) {
      await showPrivacyPolicyDialog(context);
    }
  }

  Future<void> showPrivacyPolicyDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool privacyPolicyAccepted = prefs.getBool("privacyPolicyAccepted") ?? false;
    if (!privacyPolicyAccepted && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Datenschutzrichtlinien", style: TextStyle(fontSize: 20)),
            content: SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      launchPrivacyPolicy();
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Ich bestätige hiermit die \n',
                        style: TextStyle(fontSize: 12.0, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Datenschutzbestimmungen',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: '\ngelesen zu haben und \n akzeptiere diese.',
                            style: TextStyle(fontSize: 12.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                ),
                onPressed: () async {
                    await prefs.setBool("privacyPolicyAccepted", true);
                    if(context.mounted) {
                      Navigator.of(context).pop();
                  }
                },
                child: const Text("Weiter"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> launchPrivacyPolicy() async {
    await launchUrl(Uri.parse('https://www.iubenda.com/privacy-policy/11348794'));
  }
}