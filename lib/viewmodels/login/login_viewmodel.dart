import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/viewmodels/dashboard_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../util/datastore.dart';
import '../../util/dbhelper.dart';
import '../../views/homepage.dart';
import '../../views/login/login.dart';

class LogInViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isCheckboxChecked = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  setPrivacyPolicyCheckbox(bool value) {
    isCheckboxChecked = value;
    notifyListeners();
  }

  void signIn(BuildContext context, DashboardViewModel dashboardViewModel) async {
    try {
      final User? user = (await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text))
          .user;
      if (user != null) {
        signInSuccess(user, context, dashboardViewModel);
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

  Future<User?> signInWithGoogle(BuildContext context, DashboardViewModel dashboardViewModel) async {
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
        if(user != null) {
          Datastore.db.user = user;
          if(context.mounted) {
            showMessageSnackbar("Erfolgreich mit Google angemeldet!", context);
            signInSuccess(user, context, dashboardViewModel);
            checkForLocalData(context);
          }
        }
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

  Future<void> signInSuccess(User user, BuildContext context, DashboardViewModel dashboardViewModel) async {
    Datastore.db.user = user;
    Purchases.logIn(user.uid);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => const Homepage()));
    showMessageSnackbar("Erfolgreich angemeldet!", context);
    dashboardViewModel.refresh();
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











