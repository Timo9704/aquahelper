import 'package:flutter/material.dart';

import '../../model/aquarium.dart';
import '../../model/task.dart';
import '../../util/datastore.dart';


class DashboardReminderViewModel extends ChangeNotifier {
  List<Task> taskList = [];
  List<int> tasksPerAquarium = [];
  List<Aquarium>? aquariums = [];
  int tabLength = 0;
  TabController? tabController;
  TickerProvider vsync;


  DashboardReminderViewModel(this.vsync) {
    loadTasks();
    loadTasksPerAquarium();
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

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
      aquariums = dbAquariums;
      tabController = TabController(length: dbAquariums.length+1, vsync: vsync);
      tabLength = dbAquariums.length+1;
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
    loadAquariums();
    notifyListeners();
  }
}
