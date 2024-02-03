import 'package:flutter/material.dart';
import '../../model/aquarium.dart';
import '../../model/task.dart';
import '../../util/dbhelper.dart';

class DashboardReminder extends StatefulWidget {
  const DashboardReminder({super.key});

  @override
  _DashboardReminderState createState() => _DashboardReminderState();
}

class _DashboardReminderState extends State<DashboardReminder> with SingleTickerProviderStateMixin {
  List<Task> taskList = [];
  List<int> tasksPerAquarium = [];
  List<Aquarium>? aquariums = [];
  TabController? _tabController;

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
    List<Aquarium> dbAquariums = await DBHelper.db.getAquariums();

    for(int i = 0; i < dbAquariums.length; i++){
      List<Task> tasks = await DBHelper.db.getTasksForCurrentDayForAquarium(dbAquariums.elementAt(i).aquariumId.toString());
      tasksPerAquariumInternal.add(tasks.length);
    }
    setState(() {
      tasksPerAquarium = tasksPerAquariumInternal;
    });
  }

  void loadAquariums() async {
    List<Aquarium> dbAquariums = await DBHelper.db.getAquariums();
    setState(() {
      aquariums = dbAquariums;
      _tabController = TabController(length: dbAquariums.length+1, vsync: this);
    });
  }

  void loadTasks() async {
    List<Task> dbTasks = await DBHelper.db.getTasksForCurrentDay();
    setState(() {
      taskList = dbTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Erinnerungen',
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            const SizedBox(height: 5),
            if(_tabController != null && aquariums != null)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List<Widget>.generate(aquariums!.length+1, (index) {
                  if(index < 1){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 10, 2, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          taskList.isEmpty ?
                          const Text('Für heute keine Erinnerungen!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.black)):
                          taskList.length >= 2 ?
                          Text('Noch ${taskList.length} Aufgaben zu erledigen!',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, color: Colors.black)):
                          Text('Noch ${taskList.length} Aufgabe zu erledigen!',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, color: Colors.black))
                        ],
                      ),
                    );
                  }else{
                  return Center(
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
                  );}
                }, growable: true),
              ),
            ),
            if(_tabController != null && aquariums != null)
            TabPageSelector(controller: _tabController),
          ],
        ),
      ),
    );
  }
}
