import 'package:aquahelper/viewmodels/login/login_viewmodel.dart';
import 'package:aquahelper/views/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/dashboard_viewmodel.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  privacyPolicyWithGoogleSignIn(BuildContext context, LogInViewModel viewModel, DashboardViewModel dashboardViewModel) {
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
                    GestureDetector(
                      onTap: () {
                        viewModel.launchprivacyPolicy();
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
                        WidgetStateProperty.all<Color>(Colors.lightGreen)),
                    onPressed: () {
                      viewModel.signInWithGoogle(context, dashboardViewModel);
                    },
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

  @override
  Widget build(BuildContext context) {
    DashboardViewModel dashboardViewModel =
    Provider.of<DashboardViewModel>(context, listen: true);
    return ChangeNotifierProvider(
      create: (context) => LogInViewModel(),
      child: Consumer<LogInViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Online-Synchronisation"),
            backgroundColor: Colors.lightGreen,
          ),
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 50),
                  const Center(
                    child: Text("AquaHelper Online",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 30),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Image.asset('assets/images/google.png',
                                scale: 3),
                          ),
                          onTap: () async {
                            privacyPolicyWithGoogleSignIn(context, viewModel, dashboardViewModel);
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'oder',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: viewModel.emailController,
                          decoration: const InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: viewModel.passwordController,
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
                            viewModel.signIn(context, dashboardViewModel);
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
                                        fontFamily: 'Montserrat')),
                              ),
                            ),
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
                                          const SignUp()),
                                );
                              },
                              child: const Text(
                                'Noch kein Konto? Dann registriere dich hier!',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
