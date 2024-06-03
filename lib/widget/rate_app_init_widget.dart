import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;

  const RateAppInitWidget({super.key, required this.builder});

  @override
  State<RateAppInitWidget> createState() => _RateWidgetState();
}

class _RateWidgetState extends State<RateAppInitWidget> {
  RateMyApp? rateMyApp;

  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
        rateMyApp: RateMyApp(
          preferencesPrefix: 'rateMyApp_',
          minDays: 0,
          minLaunches: 0,
          remindDays: 7,
          remindLaunches: 10,
          googlePlayIdentifier: 'com.aquarium.aquahelper',
        ),
        onInitialized: (BuildContext context, RateMyApp rateMyApp) {
          setState(() {
            this.rateMyApp = rateMyApp;
          });
        },
        builder: (context) {
          if (rateMyApp == null) {
            return const CircularProgressIndicator();
          }
          return widget.builder(rateMyApp!);
        });
  }
}
