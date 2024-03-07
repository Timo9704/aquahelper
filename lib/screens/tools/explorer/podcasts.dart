import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Podcasts extends StatefulWidget {
  const Podcasts({super.key});

  @override
  PodcastsState createState() => PodcastsState();
}

class PodcastsState extends State<Podcasts> {
  List<dynamic> podcasts = [];
  List<dynamic> filteredPodcasts = [];
  List<String> tags = ['Aquaristik', 'Aquascaping', 'Bildung', 'Englisch', 'Entertainment', 'Meerwasser', 'Suesswasser', 'Technik'];
  Set<String> selectedTags = <String>{};

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
        filteredPodcasts = List.from(podcasts); // Initially, all podcasts are displayed
      });
    }
  }

  void _filterPodcasts() {
    setState(() {
      if (selectedTags.isEmpty) {
        filteredPodcasts = List.from(podcasts);
      } else {
        filteredPodcasts = podcasts.where((podcast) {
          var tagsList = podcast[1]['tags'].split(',');
          return tagsList.any((tag) => selectedTags.contains(tag));
        }).toList();
      }
    });
  }

  Future<void> _launchPodcasts(url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 10),
          const Text('Filtere die Podcasts nach Themen:', style: TextStyle(fontSize: 20)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 5.0,
              children: tags.map((tag) => FilterChip(
                label: Text(tag),
                selected: selectedTags.contains(tag),
                padding: const EdgeInsets.all(10),
                visualDensity: VisualDensity.compact,
                backgroundColor: Colors.grey,
                selectedColor: Colors.lightGreen,
                checkmarkColor: Colors.white,
                showCheckmark: false,
                onSelected: (selected) {
                  setState(() {
                    selected ? selectedTags.add(tag) : selectedTags.remove(tag);
                    _filterPodcasts();
                  });
                },
              )).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPodcasts.length,
              itemBuilder: (context, index) {
                var podcast = filteredPodcasts[index][0]['name'];
                var podcastHost = filteredPodcasts[index][0]['by'];
                var podcastLink = filteredPodcasts[index][1]['spotify'];
                var podcastImage = filteredPodcasts[index][1]['image'];

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
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
                  ),
                );
              },
            ),
          ),
        ],
      );
  }
}