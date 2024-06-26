import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../model/aquarium.dart';
import '../model/task.dart';
import '../screens/aquarium/aquarium_overview.dart';
import '../util/datastore.dart';

class AquariumItem extends StatefulWidget {
  const AquariumItem({super.key, required this.aquarium});

  final Aquarium aquarium;

  @override
  State<AquariumItem> createState() => _AquariumItemState();
}

class _AquariumItemState extends State<AquariumItem> {
  late Aquarium aquarium;
  int taskAmount = 0;

  @override
  void initState() {
    super.initState();
    aquarium = widget.aquarium;
    loadTasks();
  }

  void loadTasks() async {
    List<Task> dbTasks =
        await Datastore.db.getTasksForCurrentDayForAquarium(aquarium);
    List<Task> repeatableTasks = await Datastore.db.checkRepeatableTasks(aquarium);
    dbTasks.addAll(repeatableTasks);
    setState(() {
      taskAmount = dbTasks.length;
    });
  }

  Widget localImageCheck(String imagePath) {
    try {
      return Image.file(File(widget.aquarium.imagePath), fit: BoxFit.cover);
    } catch (e) {
      return Image.asset('assets/images/aquarium.jpg', fit: BoxFit.fitWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AquariumOverview(aquarium: aquarium)),
            ),
            child: SizedBox(
              height: 180.0,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: aquarium.imagePath.startsWith('assets/')
                    ? Image.asset(aquarium.imagePath, fit: BoxFit.cover)
                    : aquarium.imagePath.startsWith('https://')
                        ? CachedNetworkImage(imageUrl: aquarium.imagePath, fit: BoxFit.cover)
                    : localImageCheck(widget.aquarium.imagePath),
              ),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(aquarium.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white)),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text("${aquarium.liter}L",
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white)),
                    ),
                    Flexible(
                      flex: 1,
                      child: Stack(
                        children: <Widget>[
                          const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 30,
                          ),
                          if (taskAmount > 0)
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
                                  taskAmount.toString(),
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
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
