import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/util/scalesize.dart';
import 'package:aquahelper/viewmodels/aquarium/aquarium_measurements_reminder_viewmodel.dart';
import 'package:aquahelper/views/aquarium/forms/create_or_edit_aquarium.dart';
import 'package:aquahelper/views/aquarium/forms/create_or_edit_measurement.dart';
import 'package:aquahelper/views/aquarium/forms/create_or_edit_reminder.dart';
import 'package:aquahelper/views/items/measurement_item.dart';
import 'package:aquahelper/views/items/reminder_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AquariumMeasurementReminder extends StatelessWidget {
  final Aquarium aquarium;

  const AquariumMeasurementReminder({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    double textScaleFactor = ScaleSize.textScaleFactor(context);
    var viewModel = Provider.of<AquariumMeasurementReminderViewModel>(context,
        listen: false);
    if (viewModel.aquarium != aquarium) {
      viewModel.initAquarium(aquarium);
    }
    return Consumer<AquariumMeasurementReminderViewModel>(
            builder: (context, viewModel, child) => Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child:
                            viewModel.aquarium!.imagePath.startsWith('assets/')
                                ? Image.asset(viewModel.aquarium!.imagePath,
                                    fit: BoxFit.fitWidth)
                                : viewModel.aquarium!.imagePath
                                        .startsWith('https://')
                                    ? CachedNetworkImage(
                                        imageUrl: viewModel.aquarium!.imagePath,
                                        fit: BoxFit.cover)
                                    : viewModel.localImageCheck(
                                        viewModel.aquarium!.imagePath),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.black54,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${viewModel.aquarium!.liter}L",
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                          Text(
                              "${viewModel.aquarium!.width.toString()}x${viewModel.aquarium!.height.toString()}x${viewModel.aquarium!.depth.toString()}",
                              textScaler: TextScaler.linear(textScaleFactor),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                          IconButton(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateOrEditAquarium(
                                    aquarium: viewModel.aquarium!),
                              ),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Alle Erinnerungen:',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      IconButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CreateOrEditReminder(
                                      task: null,
                                      aquarium: viewModel.aquarium!),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notification_add,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width,
                  child: viewModel.taskList.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.taskAmount,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          itemBuilder: (context, index) {
                            return ReminderItem(
                              task: viewModel.taskList.elementAt(index),
                              aquarium: viewModel.aquarium!,
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'Aktuell keine Aufgaben vorhanden!',
                            textScaler: TextScaler.linear(textScaleFactor),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Alle Messungen:',
                          textScaler: TextScaler.linear(textScaleFactor),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateOrEditMeasurement(
                                  measurementId: '',
                                  aquarium: viewModel.aquarium!),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: viewModel.measurementList.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: viewModel.measurementList.length,
                            itemBuilder: (context, index) {
                              return MeasurementItem(
                                  measurement: viewModel.measurementList
                                      .elementAt(index),
                                  aquarium: viewModel.aquarium!);
                            },
                          )
                        : Center(
                            heightFactor: 0,
                            child: Text(
                              'Aktuell keine Messungen vorhanden!',
                              textScaler: TextScaler.linear(textScaleFactor),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
  }
}
