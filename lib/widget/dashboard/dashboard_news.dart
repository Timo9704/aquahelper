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
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          const Text('Neuigkeiten',
              style: TextStyle(fontSize: 17, color: Colors.black)),
          Expanded(child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
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
    double textSize = MediaQuery.sizeOf(context).width > 400 ? 15 : 13;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date,
                style: TextStyle(fontSize: textSize, color: Colors.black)),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(text,
                  style: TextStyle(fontSize: textSize, color: Colors.black)),
            ),
          ],
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width-20,
          decoration: const BoxDecoration(color: Colors.lightGreen),
        ),
        const SizedBox(height: 5)
      ],
    );
  }
}
