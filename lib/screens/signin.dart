import 'package:aquahelper/config.dart';
import 'package:aquahelper/screens/homepage.dart';
import 'package:aquahelper/screens/signup.dart';
import 'package:aquahelper/util/firebasehelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    try{
      final User? user = (await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;
      if(user != null) {
        signInSuccess(user);
      }else{
        showErrorMessage("Schwerwiegender Fehler beim Anmelden!");
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message!);
    }

  }

  void showErrorMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fehler beim Anmelden")));
  }

  void signInSuccess(User user) {
    setUserId(user.uid);
    FirebaseHelper.db.initializeUser(user);
    Navigator.push(context, MaterialPageRoute(
       builder: (BuildContext context) => const Homepage()));
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
                  padding: const EdgeInsets.fromLTRB(15, 110, 0, 0),
                  child: const Text("AquaHelper Online",
                      style: TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold
                      )
                  ),
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
                            color: Colors.grey
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: 'PASSWORT',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      shadowColor: Colors.black,
                      color: Colors.lightGreen,
                      elevation: 10,
                      child: GestureDetector(
                          onTap: () async{
                            signIn();
                          },
                          child: const Center(
                              child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'
                                  )
                              )
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder:
                                      (BuildContext context) =>
                                  const Signup()));
                        },
                        child: const Text(
                            'Registrierung',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                            )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15,),
                  const Text(
                      'oder',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline
                      )
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      setUserId("");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder:
                                  (BuildContext context) =>
                                  const Homepage()));
                    },
                    child: const Text(
                        'Ohne Konto fortfahren - nur lokale Datenbank',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline
                        )
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }

}