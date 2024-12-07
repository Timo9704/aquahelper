import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/login/signup_viewmodel.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, viewModel, child) => Scaffold(
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: viewModel.passwordSecondController,
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
                              value: viewModel.isCheckboxChecked,
                              checkColor: Colors.black,
                              activeColor: Colors.lightGreen,
                              onChanged: (bool? value) {
                                viewModel.setPrivacyPolicyCheckbox(value!);
                              }),
                          GestureDetector(
                            onTap: () {
                              viewModel.launchprivacyPolicy();
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
                                    text:
                                        '\ngelesen zu haben und akzeptiere diese.',
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
                              viewModel.register(context);
                            },
                            child: const Center(
                              child: Text(
                                'Konto anlegen',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
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
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Zurück zum Login?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
