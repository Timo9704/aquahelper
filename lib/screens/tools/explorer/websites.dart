import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Websites extends StatefulWidget {
  const Websites({super.key});

  @override
  WebsitesState createState() => WebsitesState();
}

class WebsitesState extends State<Websites> {
  List<dynamic> websites = [];

  @override
  void initState() {
    super.initState();
    fetchWebsites();
  }

  Future<void> fetchWebsites() async {
    var url = Uri.parse('https://aquaristik-kosmos.de/websites.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        websites = json.decode(response.body).values.toList();
      });
    }
  }

  Future<void> _launchWebsites(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text('Hier findest du interessante Webseiten:',
            style: TextStyle(fontSize: 20)),
        Expanded(
          child: ListView.builder(
            itemCount: websites.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: () {
                                  _launchWebsites(websites[index][0]['url']);
                                },
                                child: Text(websites[index][0]['name'])),
                        ),
                        const SizedBox(height: 10),
                        Text(websites[index][0]['description'],
                            style: const TextStyle(fontSize: 10))
                      ],
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
