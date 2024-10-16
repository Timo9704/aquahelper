import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../util/scalesize.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../aquarium/aquarium_overview.dart';

class DashboardReminder extends StatefulWidget {
  const DashboardReminder({super.key});

  @override
  DashboardReminderState createState() => DashboardReminderState();
}

class DashboardReminderState extends State<DashboardReminder> with TickerProviderStateMixin {

  late TickerProvider vsync;

  @override
  void initState() {
    super.initState();
    Provider.of<DashboardViewModel>(context, listen: false).setTickerProvider(this);
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    return Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) => Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: Adaptive.sh(viewModel.getAdaptiveSizePerc(17, context)),
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
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 5),
            if(viewModel.tabController != null && viewModel.aquariums != null)
              Expanded(
                child: TabBarView(
                  controller: viewModel.tabController,
                  children: List<Widget>.generate(viewModel.aquariums!.length+1, (index) {
                    if(index < 1){
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 2, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            viewModel.taskList.isEmpty ?
                            FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Für heute keine\n Erinnerungen!',
                                    textScaler: TextScaler.linear(textScaleFactor),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15, color: Colors.black))):
                            viewModel.taskList.length >= 2 ?
                            FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Noch ${viewModel.taskList.length} Aufgaben\n zu erledigen!',
                                    textScaler: TextScaler.linear(textScaleFactor),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15, color: Colors.black))):
                            FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Noch ${viewModel.taskList.length} Aufgabe\nzu erledigen!',
                                    textScaler: TextScaler.linear(textScaleFactor),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15, color: Colors.black))),
                          ],
                        ),
                      );
                    }else{
                      return Center(
                          child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AquariumOverview(aquarium: viewModel.aquariums!.elementAt(index-1))),
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: <Widget>[
                                      Icon(Icons.notifications,
                                        color: Colors.lightGreen,
                                        size: Adaptive.sh(viewModel.getAdaptiveSizePerc(4, context)),
                                      ),
                                      if(viewModel.tasksPerAquarium.isNotEmpty && viewModel.tasksPerAquarium.elementAt(index-1) > 0)
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
                                              viewModel.tasksPerAquarium.elementAt(index-1).toString(),
                                              textScaler: TextScaler.linear(textScaleFactor),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  Text(viewModel.aquariums!.elementAt(index-1).name)
                                ],
                              )
                          ));}
                  }, growable: true),
                ),
              ),
            if(viewModel.tabController != null && viewModel.aquariums != null)
              TabPageSelector(indicatorSize: 7, controller: viewModel.tabController, color: Colors.grey, selectedColor: Colors.lightGreen),
          ],
        ),
      ),
    ),);
  }
}
