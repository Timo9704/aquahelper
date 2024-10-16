import 'package:aquahelper/model/aquarium.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../util/config.dart';
import '../../util/datastore.dart';
import '../../util/dbhelper.dart';
import '../../views/homepage.dart';
import '../../views/login/login.dart';

class LogInViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isCheckboxChecked = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  LogInViewModel() {
  }

  void signIn(BuildContext context) async {
    try {
      final User? user = (await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text))
          .user;
      if (user != null) {
        signInSuccess(user, context);
        Datastore.db.user = user;
      } else {
        showErrorMessage("Schwerwiegender Fehler beim Anmelden!", context);
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message!, context);
    }
  }

  Future<void> launchprivacyPolicy() async {
    await launchUrl(Uri.parse('https://www.iubenda.com/privacy-policy/11348794'));
  }

  privacyPolicyWithGoogleSignIn(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Datenschutzrichtlinien", style: TextStyle(fontSize: 20)),
              content: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    Checkbox(
                        value: isCheckboxChecked,
                        checkColor: Colors.black,
                        activeColor: Colors.lightGreen,
                        onChanged: (bool? value) {
                            isCheckboxChecked = value!;
                            notifyListeners();
                        }),
                    GestureDetector(
                      onTap: () {
                        launchprivacyPolicy();
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Ich bestätige hiermit die \n',
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.black),
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
                              text: '\ngelesen zu haben und akzeptiere diese.',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                Row(children: [
                  Expanded(child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightGreen)),
                    onPressed: isCheckboxChecked
                        ? () {
                      Navigator.pop(context);
                      signInWithGoogle(context);
                    }
                        : null,
                    child: const Text("Weiter"),
                  ),),

                ],)
              ],
              elevation: 0,
            );
          },
        );
      },
    );
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;
        signInSuccess(user!, context);
        Datastore.db.user = user;
        showMessageSnackbar("Erfolgreich mit Google angemeldet!", context);
        checkForLocalData(context);
      }
    } catch (e) {
      showErrorMessage("Schwerwiegender Fehler beim Anmelden!", context);
    }
    return null;
  }

  void showErrorMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ));
  }

  void showMessageSnackbar(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
              children: <Widget>[
                const Icon(Icons.check, color: Colors.white),
                const SizedBox(width: 16),
                Text(text),
              ]),
          backgroundColor: Colors.green,
        )
    );
  }

  Future<void> signInSuccess(User user, BuildContext context) async {
    setUserId(user.uid);
    Purchases.logIn(user.uid);
    showMessageSnackbar("Erfolgreich angemeldet!", context);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => const Homepage()));
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
                  MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Nicht hochladen"),
              onPressed: () => {
                Navigator.pop(context),
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LogIn()),
                        (Route<dynamic> route) => false),
                showMessageSnackbar("Keine Daten hochgeladen!", context),
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.lightGreen)),
              child: const Text("Hochladen"),
              onPressed: () {
                () async {
                  bool uploadSuccess = await DBHelper.db.uploadDataToFirebase();
                  if (uploadSuccess && context.mounted) {
                    showMessageSnackbar("Daten erfolgreich hochgeladen!", context);
                    DBHelper.db.deleteLocalDbAfterUpload();
                    Navigator.pop(context);
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

  checkForLocalData(BuildContext context) async {
    List<Aquarium> aquariumList = await DBHelper.db.getAquariums();
    if (aquariumList.isNotEmpty) {
      showUploadDialog(context);
    }
  }



}












