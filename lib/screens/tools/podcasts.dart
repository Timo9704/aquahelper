import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PodcastListScreen extends StatefulWidget {
  const PodcastListScreen({super.key});

  @override
  PodcastListScreenState createState() => PodcastListScreenState();
}

class PodcastListScreenState extends State<PodcastListScreen> {
  List<dynamic> podcasts = [];

  @override
  void initState() {
    super.initState();
    fetchPodcasts();
  }

  Future<void> fetchPodcasts() async {
    var url = Uri.parse('https://aquaristik-kosmos.de/podcasts.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        podcasts = json.decode(response.body).values.toList();
      });
    }
  }

  Future<void> _launchPodcasts(url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Aquaristik-Podcasts"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          var podcast = podcasts[index][0]['name'];
          var podcastHost = podcasts[index][0]['by'];
          var podcastLink = podcasts[index][1]['spotify'];
          var podcastImage = podcasts[index][1]['image'];

          return Padding(
              padding: const EdgeInsets.all(10),
              child:
                Column(
                  children: [
                    IconButton(
                      icon: Image.network(podcastImage, width: 300),
                      onPressed: () {
                        _launchPodcasts(podcastLink);
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      podcast,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      "by: $podcastHost",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                  ],
                )
              );
        },
      ),
    );
  }
}
