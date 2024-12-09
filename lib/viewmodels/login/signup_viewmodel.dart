import 'package:aquahelper/views/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/aquarium.dart';
import '../../util/dbhelper.dart';

class SignUpViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordSecondController =
      TextEditingController();
  late String userEmail;
  late User user;
  bool isCheckboxChecked = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  setPrivacyPolicyCheckbox(bool value) {
    isCheckboxChecked = value;
    notifyListeners();
  }

  checkForLocalData(BuildContext context) async {
    List<Aquarium> aquariumList = await DBHelper.db.getAquariums();
    if (aquariumList.isNotEmpty) {
      if (context.mounted) {
        showUploadDialog(context);
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LogIn()),
                (Route<dynamic> route) => false);
        showInitialLoginMessage(context);
      }
    }
  }

  void showInitialLoginMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Row(children: <Widget>[
        Icon(Icons.check, color: Colors.white),
        SizedBox(width: 16),
        Text('Bitte melde dich nun mit deinem Account an!'),
      ]),
      backgroundColor: Colors.green,
    ));
  }

  void showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Es sind lokale Daten vorhanden!"),
          content: const SizedBox(
            height: 60,
            child: Column(
              children: [
                Text("Sollen die Daten hochgeladen werden? (Empfohlen)"),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.grey)),
              child: const Text("Nicht hochladen"),
              onPressed: () => {
                Navigator.pop(context),
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LogIn()),
                    (Route<dynamic> route) => false),
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.lightGreen)),
              child: const Text("Hochladen"),
              onPressed: () {
                final BuildContext currentContext = context;
                () async {
                  bool uploadSuccess = await DBHelper.db.uploadDataToFirebase(true);
                  if (uploadSuccess && context.mounted) {
                    DBHelper.db.deleteLocalDbAfterUpload();
                    Navigator.pop(currentContext);
                    Navigator.of(currentContext).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LogIn()),
                        (Route<dynamic> route) => false);
                    showUploadSuccessMessage(context);
                  }
                }();
              },
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  void register(BuildContext context) async {
    User? userInternal;

    if (isCheckboxChecked == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bitte akzeptiere die Datenschutzbestimmungen!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text != passwordSecondController.text) {
      failurePasswordCheck(context);
      return;
    }

    try {
      userInternal = (await auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text))
          .user;
    } on FirebaseAuthException catch (e) {
      if(context.mounted) {
        failureUserCreation(e.message!, context);
      }
    }

    if (userInternal != null) {
      userEmail = userInternal.email!;
      user = FirebaseAuth.instance.currentUser!;
      if(context.mounted) {
        successUserCreation(userEmail, context);
      }
    }
  }

  failureUserCreation(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fehler beim Anlegen des Accounts'),
            content: Text(
                'Es ist ein Fehler beim Anlegen des Accounts aufgetreten. Bitte versuche es erneut oder kontaktieren sie den Administrator!\n\nGrund: $message'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        });
  }

  successUserCreation(String mail, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Herzlichen Glückwunsch!'),
            content: Text(
                'Dein Account mit der Email-Adresse $mail wurde erfolgreich erstellt.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => checkForLocalData(context),
                child: const Text('Weiter zum Login'),
              )
            ],
          );
        });
  }

  failurePasswordCheck(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fehler beim Anlegen des Accounts'),
            content: const Text('Die Passwörter stimmen nicht überein!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        });
  }

  void showUploadSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Row(children: <Widget>[
        Icon(Icons.check, color: Colors.white),
        SizedBox(width: 16),
        Text('Daten erfolgreich hochgeladen!'),
      ]),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> launchprivacyPolicy() async {
    await launchUrl(
        Uri.parse('https://www.iubenda.com/privacy-policy/11348794'));
  }
}
