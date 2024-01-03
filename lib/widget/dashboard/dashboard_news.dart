import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aquahelper/model/news.dart';

class DashboardNews extends StatefulWidget {
  const DashboardNews({super.key});

  @override
  State<DashboardNews> createState() => _DashboardNewsState();
}

class _DashboardNewsState extends State<DashboardNews> {
  List<News> newsList = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://aquaristik-kosmos.de/news.json'));

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

      setState(() {
        newsList = newsListIntern;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          const Text('Neuigkeiten',
              style: TextStyle(fontSize: 15, color: Colors.black)),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Column(
              children: [
                SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return NewsItem(
                            date: newsList[index].date,
                            text: newsList[index].text);
                      },
                    )),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final String date;
  final String text;

  const NewsItem({super.key, required this.date, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(date, style: const TextStyle(fontSize: 15, color: Colors.black)),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(text,
              style: const TextStyle(fontSize: 15, color: Colors.black)),
        )
      ],
    );
  }
}
