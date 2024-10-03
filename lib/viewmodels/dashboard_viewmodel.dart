import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../util/datastore.dart';
import 'package:http/http.dart' as http;

class DashboardViewModel extends ChangeNotifier {
  double textScaleFactor = 0;
  double heightFactor = 0;
  String title = '';
  String loggedInOrLocal = '';
  User? user = Datastore.db.user;

  bool announcementVisible = false;
  String announcement = '';
  String announcementUrl = '';

  DashboardViewModel(int height) {
    loggedInOrLocal =
        user != null ? "eingeloggt als: ${user!.email!}" : "lokaler Modus";
    heightFactor = height < 700 ? 0.35 : 0.65;
    title = height < 700
        ? "Dashboard"
        : "AquaHelper\nDashboard";
  }

  Future<void> fetchAnnouncement() async {
    final response = await http
        .get(Uri.parse('https://aquaristik-kosmos.de/announcement.json'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      parsed.forEach((key, value) {
        announcement = value[0]['text'];
        announcementUrl = value[1]['url'];
        announcementVisible = true;
      });
    }
  }

  Future<void> _launchRedirect() async {
    await launchUrl(Uri.parse(announcementUrl));
  }

  void showMaterialBanner(BuildContext context, String announcement) {
    final materialBanner = MaterialBanner(
      padding: const EdgeInsets.all(20),
      content: Text(announcement),
      leading: const Icon(Icons.notification_important),
      backgroundColor: Colors.white,
      actions: <Widget>[
        TextButton(
          onPressed: () =>
              {ScaffoldMessenger.of(context).hideCurrentMaterialBanner()},
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 10),
            backgroundColor: Colors.grey,
          ),
          child: const Text('Schließen'),
        ),
        TextButton(
          onPressed: _launchRedirect,
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 10),
            backgroundColor: Colors.lightGreen,
          ),
          child: const Text('Weiterlesen'),
        ),
      ],
    );
    ScaffoldMessenger.of(context).showMaterialBanner(materialBanner);
  }
}
