import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PodcastListScreen extends StatefulWidget {
  @override
  _PodcastListScreenState createState() => _PodcastListScreenState();
}

class _PodcastListScreenState extends State<PodcastListScreen> {
  List<dynamic> podcasts = [];

  List<WebViewController> webViewList = [];

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
    for (int i = 0; i < podcasts.length; i++) {
      print(podcasts[i][1]['spotify']);
      WebViewController controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse(podcasts[i][1]['spotify']));
      webViewList.add(controller);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Aquaristik-Podcasts"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
        itemCount: webViewList.length,
        itemBuilder: (context, index) {
          var podcast = podcasts[index][0]['name'];
          var podcastHost = podcasts[index][0]['by'];

          return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    podcast,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "by: " + podcastHost,
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                      height: 150,
                      child: WebViewWidget(
                          controller: webViewList.elementAt(index))),
                  SizedBox(height: 10)
                ],
                //WebViewWidget(controller: controller)
              ));
        },
      ),
    );
  }
}
