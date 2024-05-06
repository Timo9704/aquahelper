import 'package:aquahelper/screens/signin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/datastore.dart';
import 'homepage.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  initState(){
    super.initState();
    Datastore.db.updateLastLogin();
    checkIntroShown();
  }

  Future<void> checkIntroShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? introShown = prefs.getBool("introShown");
    if (introShown!) {
      if(mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Homepage()),
        );
      }
    }
  }

  Future<void> _onSignUpButtonClick(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("introShown", true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const  SignIn()),
    );
  }


  Future<void> _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("introShown", true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const  Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
      pageColor: Colors.white,
      //titlePadding: EdgeInsets.only(top: 100),
      imagePadding: EdgeInsets.only(top: 150),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.lightGreen,
      allowImplicitScrolling: true,
      autoScrollDuration: 500000,
      infiniteAutoScroll: true,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Direkt durchstarten!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Herzlich Willkommen bei AquaHelper!",
          bodyWidget: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lass uns kurz die wichtigsten Funktionen von AquaHelper kennenlernen.',style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              SizedBox(height: 20),
              Text("Dann kann es auch schon losgehen!", textAlign: TextAlign.center),
            ],
          ),
          image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Aquarien, Messungen und Erinnerung speichern, verwalten und analysieren",
          bodyWidget: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('AquaHelper hilft dir schnelle und einfach die Wasserwerte deiner Aquarien zu speichern und zu analysieren!',style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            ],
          ),
          image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Tools und Explorer",
          bodyWidget: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('AquaHelper bietet dir einige Tools, wie z.B. einen Bodengrund- und Düngerrechner. Ebenso findest du einige deutsche Aquaristik-Podcasts im Explorer!',style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            ],
          ),
          image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Online-Synchronisation oder lokale Speicherung?",
          bodyWidget: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('AquaHelper bietet dir die Möglichkeit deine Daten lokal oder online in der Cloud zu speichern! So hast du die volle Kontrolle und maximalen Komfort!',style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            ],
          ),
          image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Etwas stimmt nicht?",
          bodyWidget: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sollten Fehler oder Bugs auftreten, dann schaue doch mal ins FAQ oder melde diese gerne über den Bug-Melder in den Einstellungen!',style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            ],
          ),
          image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Bevor es los geht...",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Möchtest du dein AquaHelper-Konto sofort anlegen? Du erhälst damit sofort Zugriff auf die Online-Synchronsiation!',style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
              onPressed: () => {
                _onSignUpButtonClick(context)
              },
              child: const Text("Ja, mein Konto jetzt anlegen!")),
            ],
          ),
          image: Center(child: Image.asset('assets/images/aquahelper_icon.png', height: 200)),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 1,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Überspringen', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Fertig', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
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
    );
  }
}
