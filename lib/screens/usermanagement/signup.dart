import 'package:aquahelper/screens/usermanagement/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/aquarium.dart';
import '../../util/dbhelper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordSecondController =
      TextEditingController();
  late String _userEmail;
  late User user;
  bool _isCheckboxChecked = false;

  @override
  void initState() {
    super.initState();
  }

  checkForLocalData() async {
    List<Aquarium> aquariumList = await DBHelper.db.getAquariums();
    if (aquariumList.isNotEmpty) {
      showUploadDialog();
    } else {
      returnUsertoSignIn();
    }
  }

  void returnUsertoSignIn() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignIn()),
        (Route<dynamic> route) => false);
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
                    MaterialPageRoute(builder: (context) => const SignIn()),
                    (Route<dynamic> route) => false),
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightGreen)),
              child: const Text("Hochladen"),
              onPressed: () {
                final BuildContext currentContext = context;
                () async {
                  bool uploadSuccess = await DBHelper.db.uploadDataToFirebase();
                  if (uploadSuccess && context.mounted) {
                    DBHelper.db.deleteLocalDbAfterUpload();
                    Navigator.pop(currentContext);
                    Navigator.of(currentContext).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SignIn()),
                            (Route<dynamic> route) => false);
                    showUploadSuccessMessage();
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

  void _register() async {
    User? userInternal;

    if(_isCheckboxChecked == false){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bitte akzeptiere die Datenschutzbestimmungen!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text != _passwordSecondController.text) {
      failurePasswordCheck();
      return;
    }

    try {
      userInternal = (await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text))
          .user;
    } on FirebaseAuthException catch (e) {
      failureUserCreation(e.message!);
    }

    if (userInternal != null) {
      setState(() {
        _userEmail = userInternal!.email!;
        user = FirebaseAuth.instance.currentUser!;
      });
      successUserCreation(_userEmail);
    }
  }

  failureUserCreation(String message) {
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

  successUserCreation(String mail) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Herzlichen Glückwunsch!'),
            content: Text(
                'Dein Account mit der Email-Adresse $mail wurde erfolgreich erstellt.'),
            actions: <Widget>[
              TextButton(
                onPressed: checkForLocalData,
                child: const Text('Weiter zum Login'),
              )
            ],
          );
        });
  }

  failurePasswordCheck() {
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

  void showUploadSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Row(children: <Widget>[
        Icon(Icons.check, color: Colors.white),
        SizedBox(width: 16),
        Text('Daten erfolgreich hochgeladen!'),
      ]),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _launchprivacyPolicy() async {
    await launchUrl(Uri.parse('https://www.iubenda.com/privacy-policy/11348794'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Registrierung"),
          backgroundColor: Colors.lightGreen,
        ),
        body: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 110, 0, 0),
                    child: const Text("Erstelle dein Konto",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 35, left: 20, right: 30),
                child: Column(
                  children: <Widget>[
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _passwordSecondController,
                      decoration: const InputDecoration(
                          labelText: 'PASSWORT WIEDERHOLEN',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          )),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: _isCheckboxChecked,
                            checkColor: Colors.black,
                            activeColor: Colors.lightGreen,
                            onChanged: (bool? value) {
                          setState(() {
                            _isCheckboxChecked = value!;
                          });
                        }),
                        GestureDetector(
                          onTap: () {
                            _launchprivacyPolicy();
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: 'Ich bestätige hiermit die ',
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
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        shadowColor: Colors.black,
                        color: Colors.lightGreen,
                        elevation: 10,
                        child: GestureDetector(
                            onTap: () async {
                              _register();
                            },
                            child: const Center(
                                child: Text('Konto anlegen',
                                    style: TextStyle(
                                        color: Colors.black,
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
                            Navigator.of(context).pop();
                          },
                          child: const Text('Zurück zum Login?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ]));
  }
}
