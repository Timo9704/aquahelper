import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/aquarium.dart';
import '../model/measurement.dart';
import '../model/news.dart';
import '../model/task.dart';
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

  String measurementsAll = "0";
  String measurements30days = "0";
  List<Aquarium> aquariums = [];
  List<News> newsList = [];

  List<Task> taskList = [];
  List<int> tasksPerAquarium = [];
  int tabLength = 0;
  TabController? tabController;
  late TickerProvider vsync;

  initDashboard(int height){
    heightFactor = height < 720 ? 0.35 : 0.65;
    title = height < 720
        ? "Dashboard"
        : "AquaHelper\nDashboard";
    setUser(Datastore.db.user);
    calculateMeasurementsAmount();
    checkHealthStatus();
    fetchNews();
    loadTabController();
    loadTasks();
  }

  double getAdaptiveSizePerc(int perc, BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    if (deviceHeight < 700) {
      return perc*1;
    } else if (deviceHeight < 900) {
      return perc*0.8;
    } else {
      return perc*0.6;
    }
  }

  setUser(User? user) {
    loggedInOrLocal =
    user != null ? "eingeloggt als: ${user.email!}" : "lokaler Modus";
    this.user = user;
  }

  void refresh() {
    setUser(Datastore.db.user);
    calculateMeasurementsAmount();
    checkHealthStatus();
    loadTabController();
    loadTasks();
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

  //-----------DashboardNews----------------//

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

  //-----------DashboardMeasurement----------------//

  void calculateMeasurementsAmount() async {
    int now = ((DateTime.now().toUtc().millisecondsSinceEpoch));
    int endInterval = now - 2629743000;
    int measurementsAll = await Datastore.db.getMeasurementAmountByAllTime();
    int measurements30days = await Datastore.db
        .getMeasurementAmountByLast30Days(now, endInterval);
    this.measurementsAll = measurementsAll.toString();
    this.measurements30days = measurements30days.toString();
    notifyListeners();
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    aquariums = dbAquariums;
    checkHealthStatus();
    notifyListeners();
  }

  checkHealthStatus() async {
    loadAquariums();

    for (int i = 0; i < aquariums.length; i++) {
      int previousHealthStatus = aquariums[i].healthStatus;
      DateTime now = DateTime.now();
      DateTime interval7 = now.subtract(const Duration(days: 7));
      DateTime interval14 = now.subtract(const Duration(days: 14));
      DateTime interval30 = now.subtract(const Duration(days: 30));
      List<Measurement> list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval7.millisecondsSinceEpoch);
      if(list.isEmpty){
        list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval14.millisecondsSinceEpoch);
        if(list.isEmpty) {
          list = await Datastore.db.getMeasurementsByInterval(aquariums[i].aquariumId, now.millisecondsSinceEpoch, interval30.millisecondsSinceEpoch);
          if(list.isEmpty){
            aquariums[i].healthStatus = 3;
          }else {
            aquariums[i].healthStatus = 2;
          }
        }else{
          aquariums[i].healthStatus = 1;
        }
      }else{
        aquariums[i].healthStatus = 0;
      }
      if(previousHealthStatus != aquariums[i].healthStatus){
        await Datastore.db.updateAquarium(aquariums[i]);
      }
    }
    aquariums = aquariums;
  }

  //-----------DashboardReminder----------------//

  void loadTabController() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    aquariums = dbAquariums;
    tabController = TabController(length: dbAquariums.length+1, vsync: vsync);
    tabLength = dbAquariums.length+1;
    notifyListeners();
  }

  void loadTasksPerAquarium() async {
    List<int> tasksPerAquariumInternal = [];
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();

    for(int i = 0; i < dbAquariums.length; i++){
      List<Task> tasks = await Datastore.db.getTasksForCurrentDayForAquarium(dbAquariums.elementAt(i));
      tasks.addAll(await Datastore.db.checkRepeatableTasks(dbAquariums.elementAt(i)));
      tasksPerAquariumInternal.add(tasks.length);
    }
    tasksPerAquarium = tasksPerAquariumInternal;
    notifyListeners();
  }

  void loadTasks() async {
    List<Task> tasksPerAquariumInternal = [];
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();

    for(int i = 0; i < dbAquariums.length; i++){
      List<Task> tasks = await Datastore.db.getTasksForCurrentDayForAquarium(dbAquariums.elementAt(i));
      tasks.addAll(await Datastore.db.checkRepeatableTasks(dbAquariums.elementAt(i)));
      tasksPerAquariumInternal.addAll(tasks);
    }
    taskList = tasksPerAquariumInternal;
    loadTabController();
    notifyListeners();
  }

  setTickerProvider(TickerProvider vsync) {
    this.vsync = vsync;
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}
