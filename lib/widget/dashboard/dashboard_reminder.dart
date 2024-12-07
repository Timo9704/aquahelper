import 'package:flutter/material.dart';
import '../../model/aquarium.dart';
import '../../model/task.dart';
import '../../screens/aquarium/aquarium_overview.dart';
import '../../util/datastore.dart';
import '../../util/scalesize.dart';

class DashboardReminder extends StatefulWidget {
  const DashboardReminder({super.key});

  @override
  DashboardReminderState createState() => DashboardReminderState();
}

class DashboardReminderState extends State<DashboardReminder> with SingleTickerProviderStateMixin {
  List<Task> taskList = [];
  List<int> tasksPerAquarium = [];
  List<Aquarium>? aquariums = [];
  TabController? _tabController;
  double textScaleFactor = 0;

  @override
  void initState() {
    loadAquariums();
    loadTasks();
    loadTasksPerAquarium();
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void loadTasksPerAquarium() async {
    List<int> tasksPerAquariumInternal = [];
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();

    for(int i = 0; i < dbAquariums.length; i++){
      List<Task> tasks = await Datastore.db.getTasksForCurrentDayForAquarium(dbAquariums.elementAt(i));
      tasks.addAll(await Datastore.db.checkRepeatableTasks(dbAquariums.elementAt(i)));
      tasksPerAquariumInternal.add(tasks.length);
    }
    setState(() {
      tasksPerAquarium = tasksPerAquariumInternal;
    });
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();
    setState(() {
      aquariums = dbAquariums;
      _tabController = TabController(length: dbAquariums.length+1, vsync: this);
    });
  }

  void loadTasks() async {
    List<Task> tasksPerAquariumInternal = [];
    List<Aquarium> dbAquariums = await Datastore.db.getAquariums();

    for(int i = 0; i < dbAquariums.length; i++){
      List<Task> tasks = await Datastore.db.getTasksForCurrentDayForAquarium(dbAquariums.elementAt(i));
      tasks.addAll(await Datastore.db.checkRepeatableTasks(dbAquariums.elementAt(i)));
      tasksPerAquariumInternal.addAll(tasks);
    }

    setState(() {
      taskList = tasksPerAquariumInternal;
    });
  }

  @override
  Widget build(BuildContext context) {
    textScaleFactor = ScaleSize.textScaleFactor(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
              'Erinnerungen',
              textScaler: TextScaler.linear(textScaleFactor),
              style: const TextStyle(fontSize: 21, color: Colors.black),
            )),
            const SizedBox(height: 5),
            if(_tabController != null && aquariums != null)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List<Widget>.generate(aquariums!.length+1, (index) {
                  if(index < 1){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          taskList.isEmpty ?
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Für heute keine Erinnerungen!',
                              textScaler: TextScaler.linear(textScaleFactor),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, color: Colors.black))):
                          taskList.length >= 2 ?
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Noch ${taskList.length} Aufgaben zu erledigen!',
                              textScaler: TextScaler.linear(textScaleFactor),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, color: Colors.black))):
                          FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('Noch ${taskList.length} Aufgabe zu erledigen!',
                              textScaler: TextScaler.linear(textScaleFactor),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14, color: Colors.black))),
                        ],
                      ),
                    );
                  }else{
                  return Center(
                  child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AquariumOverview(aquarium: aquariums!.elementAt(index-1))),
                      ),
                        child: Column(
                          children: [
                            Stack(
                              children: <Widget>[
                                const Icon(Icons.notifications,
                                  color: Colors.lightGreen,
                                  size: 30,
                                ),
                                if(tasksPerAquarium.isNotEmpty && tasksPerAquarium.elementAt(index-1) > 0)
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 12,
                                        minHeight: 12,
                                      ),
                                      child: Text(
                                        tasksPerAquarium.elementAt(index-1).toString(),
                                        textScaler: TextScaler.linear(textScaleFactor),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            Text(aquariums!.elementAt(index-1).name)
                          ],
                        )
                  ));}
                }, growable: true),
              ),
            ),
            if(_tabController != null && aquariums != null)
            TabPageSelector(controller: _tabController, color: Colors.grey, selectedColor: Colors.lightGreen),
          ],
        ),
      ),
    );
  }
}
