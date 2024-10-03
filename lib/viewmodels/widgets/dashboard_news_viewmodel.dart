import 'dart:convert';

import 'package:flutter/material.dart';
import '../../model/news.dart';
import 'package:http/http.dart' as http;

class DashboardNewsViewModel extends ChangeNotifier {
  List<News> newsList = [];

  DashboardNewsViewModel() {
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response =
    await http.get(Uri.parse('https://aquaristik-kosmos.de/news.json'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);

      List<News> newsListIntern = [];

      parsed.forEach((key, value) {
        var newsItem = News.fromJson({
          'date': value[0]['date'],
          'text': value[1]['text'],
        });
        newsListIntern.add(newsItem);
      });
      newsList = newsListIntern;
      notifyListeners();
    } else {
      throw Exception('Failed to load news');
    }
  }
}

