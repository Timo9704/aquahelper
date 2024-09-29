import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../util/scalesize.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import 'homepage.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnBoardingViewModel(),
      child: Consumer<OnBoardingViewModel>(
        builder: (context, viewModel, child) {
          viewModel.checkPrivacyPolicy(context);

          if (viewModel.introShown) {
            return const Homepage();
          }

          return IntroductionScreen(
            key: GlobalKey<IntroductionScreenState>(),
            globalBackgroundColor: Colors.lightGreen,
            allowImplicitScrolling: true,
            autoScrollDuration: 500000,
            infiniteAutoScroll: true,
            showSkipButton: false,
            skipOrBackFlex: 0,
            nextFlex: 1,
            showBackButton: false,
            back: const Icon(Icons.arrow_back),
            skip: const Text('Überspringen', style: TextStyle(fontWeight: FontWeight.w600)),
            next: const Icon(Icons.arrow_forward),
            done: const Text('Fertig', style: TextStyle(fontWeight: FontWeight.w600)),
            pages: getPages(context),
            onDone: () {
              viewModel.setIntroShown(true);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const Homepage()),
              );
            },
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              activeColor: Color(0xFF8BC34A),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            dotsContainerDecorator: const ShapeDecoration(
              color: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            globalFooter: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                child: const Text(
                  'Direkt durchstarten!',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                onPressed: () => viewModel.setIntroShown(true),
              ),
            ),
          );
        },
      ),
    );
  }

  List<PageViewModel> getPages(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return [
      PageViewModel(
        titleWidget: Text('Herzlich Willkommen bei AquaHelper!', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lass uns kurz die wichtigsten Funktionen von AquaHelper kennenlernen.', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
            Text("Dann kann es auch schon losgehen!", textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
          ],
        ),
        image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        titleWidget: Text('Aquarien, Messungen und Erinnerung speichern, verwalten und analysieren', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('AquaHelper hilft dir schnelle und einfach die Wasserwerte deiner Aquarien zu speichern und zu analysieren!', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
          ],
        ),
        image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        titleWidget: Text('Tools und Explorer', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('AquaHelper bietet dir einige Tools, wie z.B. einen Bodengrund- und Düngerrechner. Ebenso findest du einige deutsche Aquaristik-Podcasts im Explorer!', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
          ],
        ),
        image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        titleWidget: Text('Online-Synchronisation oder lokale Speicherung?', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('AquaHelper bietet dir die Möglichkeit deine Daten lokal oder online in der Cloud zu speichern! So hast du die volle Kontrolle und maximalen Komfort!', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
          ],
        ),
        image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        titleWidget: Text('Etwas stimmt nicht?', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sollten Fehler oder Bugs auftreten, dann schaue doch mal ins FAQ oder melde diese gerne über den Bug-Melder in den Einstellungen!', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
          ],
        ),
        image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
        decoration: getPageDecoration(),
      ),
      PageViewModel(
        titleWidget: Text('Bevor es los geht...', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        bodyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Möchtest du dein AquaHelper-Konto sofort anlegen? Du erhälst damit sofort Zugriff auf die Online-Synchronsiation!', textScaler: TextScaler.linear(textScaleFactor), style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
                onPressed: () => {
                  //_onSignUpButtonClick(context)
                },
                child: const Text("Ja, mein Konto jetzt anlegen!")),
          ],
        ),
        image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
        decoration: getPageDecoration(),
      ),
    ];
  }

  PageDecoration getPageDecoration() => const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.only(top: 0),
  );
}
