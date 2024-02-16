import 'package:aquahelper/config.dart';
import 'package:aquahelper/screens/homepage.dart';
import 'package:aquahelper/screens/signup.dart';
import 'package:aquahelper/util/firebasehelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/aquarium.dart';
import '../util/datastore.dart';
import '../util/dbhelper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  final String title = 'Sign in';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void signIn() async {
    signInWithGoogle();
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user;
      if (user != null) {
        signInSuccess(user);
        Datastore.db.user = user;
      } else {
        showErrorMessage("Schwerwiegender Fehler beim Anmelden!");
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message!);
    }
  }

  Future<User?> signInWithGoogle() async {
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
        signInSuccess(user!);
        Datastore.db.user = user;
        showMessageSnackbar("Erfolgreich mit Google angemeldet!");
        checkForLocalData();
      }
    } catch (e) {
      showErrorMessage("Schwerwiegender Fehler beim Anmelden!");
    }
    return null;
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
        ));
  }

  void showMessageSnackbar(String text) {
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

  void signInSuccess(User user) {
    setUserId(user.uid);
    FirebaseHelper.db.initializeUser(user);
    showMessageSnackbar("Erfolgreich angemeldet!");
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => const Homepage()));
  }

  void showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Es sind lokale Daten vorhanden!"),
          content: const SizedBox(
            height: 60,
            child: Column(
              children: [
                Text("Sollen die Daten hochgeladen?"),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey)),
              child: const Text("Hochladen"),
              onPressed: () => {
                DBHelper.db.uploadDataToFirebase(),
                DBHelper.db.deleteLocalDbAfterUpload(),
                Navigator.pop(context),
                showMessageSnackbar("Daten erfolgreich hochgeladen!"),
              },
            ),
          ],
          elevation: 0,
        );
      },
    );
  }

  checkForLocalData() async {
    List<Aquarium> aquariumList = await DBHelper.db.getAquariums();
    if (aquariumList.isNotEmpty) {
      showUploadDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Online-Synchronisation"),
          backgroundColor: Colors.lightGreen,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 100, 0, 0),
                  child: const Text("AquaHelper Online",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 30),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.asset('assets/images/google.png', scale: 3),
                    ),
                    onTap: () async {
                      signInWithGoogle();
                    },
                    ),
                  const SizedBox(height: 20),
                  const Text('oder',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'EMAIL',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: 'PASSWORT',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () async {
                      signIn();
                    },
                    child: SizedBox(
                      height: 40,
                      child: Material(
                          borderRadius: BorderRadius.circular(20),
                          shadowColor: Colors.black,
                          color: Colors.lightGreen,
                          elevation: 10,
                          child: const Center(
                              child: Text('LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat')))),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Signup()));
                        },
                        child: const Text('Noch kein Konto? Dann registriere dich hier!',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('oder',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      setUserId("");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const Homepage()));
                    },
                    child: const Text(
                        'Ohne Konto fortfahren - nur lokale Datenbank',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
