import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../util/scalesize.dart';
import '../../viewmodels/settings/feedback_form_viewmodel.dart';

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({super.key});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return ChangeNotifierProvider(
      create: (context) => FeedbackFormViewModel(),
      child: Consumer<FeedbackFormViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Bugs und Feedback melden"),
            backgroundColor: Colors.lightGreen,
          ),
          body: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(viewModel.infoText,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Was möchtest du melden?",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<int>(
                                value: 0,
                                activeColor: Colors.lightGreen,
                                groupValue: viewModel.ticketType,
                                onChanged: (int? value) {
                                  viewModel.setTicketType(value!);
                                  if (viewModel.ticketType == 0) {
                                    viewModel.title =
                                        "Was funktioniert nicht? (Kurz-Titel)";
                                    viewModel.description =
                                        "Beschreibung & Schritte zur Nachstellung";
                                  }
                                },
                              ),
                              Text(
                                'Bug/Fehler',
                                textScaler: TextScaler.linear(textScaleFactor),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<int>(
                                value: 1,
                                activeColor: Colors.lightGreen,
                                groupValue: viewModel.ticketType,
                                onChanged: (int? value) {
                                  viewModel.setTicketType(value!);
                                  if (viewModel.ticketType == 1) {
                                    viewModel.title =
                                        "Welches Feature wünschst du dir? (Kurz-Titel)";
                                    viewModel.description =
                                        "Beschreibung des neuen Features";
                                  }
                                },
                              ),
                              Text(
                                'Feature-Wunsch',
                                textScaler: TextScaler.linear(textScaleFactor),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("E-Mail (optional)",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          controller: viewModel.mailController,
                          cursorColor: Colors.black,
                          maxLengthEnforcement: MaxLengthEnforcement.none,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewModel.title,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          controller: viewModel.titleController,
                          cursorColor: Colors.black,
                          maxLength: 50,
                          maxLengthEnforcement: MaxLengthEnforcement.none,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewModel.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.center,
                          controller: viewModel.descriptionController,
                          cursorColor: Colors.black,
                          maxLines: 4,
                          maxLength: 500,
                          maxLengthEnforcement: MaxLengthEnforcement.none,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        elevation: 0,
                      ),
                      onPressed: () {
                        viewModel.sendRequest(
                            viewModel.mailController.text,
                            viewModel.titleController.text,
                            viewModel.descriptionController.text,
                            context);
                      },
                      child: const Text("Bug/Feedback absenden"),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
