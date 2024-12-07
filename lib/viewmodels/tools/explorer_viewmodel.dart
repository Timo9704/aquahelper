import 'dart:convert';

import 'package:aquahelper/views/tools/explorer/podcast.dart';
import 'package:aquahelper/views/tools/explorer/website.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


class ExplorerViewModel extends ChangeNotifier {
  int selectedPage = 0;
  final pageOptions = [
    const Podcasts(),
    const Websites(),
  ];

  List<dynamic> podcasts = [];
  List<dynamic> filteredPodcasts = [];
  List<String> tags = ['Aquaristik', 'Aquascaping', 'Bildung', 'Englisch', 'Entertainment', 'Meerwasser', 'Suesswasser', 'Technik'];
  Set<String> selectedTags = <String>{};

  List<dynamic> websites = [];

  ExplorerViewModel() {
    fetchPodcasts();
    fetchWebsites();
  }

  setSelectedPage(int index) {
    selectedPage = index;
    notifyListeners();
  }

  Future<void> fetchPodcasts() async {
    var url = Uri.parse('https://aquaristik-kosmos.de/podcasts.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
        podcasts = json.decode(response.body).values.toList();
        filteredPodcasts = List.from(podcasts); // Initially, all podcasts are displayed
    }
    notifyListeners();
  }

  void filterPodcasts() {
      if (selectedTags.isEmpty) {
        filteredPodcasts = List.from(podcasts);
      } else {
        filteredPodcasts = podcasts.where((podcast) {
          var tagsList = podcast[1]['tags'].split(',');
          return tagsList.any((tag) => selectedTags.contains(tag));
        }).toList();
      }
      notifyListeners();
  }

  Future<void> launchPodcasts(url) async {
    await launchUrl(Uri.parse(url));
  }

  Future<void> fetchWebsites() async {
    var url = Uri.parse('https://aquaristik-kosmos.de/websites.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
        websites = json.decode(response.body).values.toList();
    }
    notifyListeners();
  }

  Future<void> launchWebsites(String url) async {
    await launchUrl(Uri.parse(url));
  }


}
