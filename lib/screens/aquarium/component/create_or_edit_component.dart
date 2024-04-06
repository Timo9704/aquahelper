import 'package:aquahelper/model/components/filter.dart';
import 'package:aquahelper/screens/aquarium/component/tab/heater_tab.dart';
import 'package:aquahelper/screens/aquarium/component/tab/lighting_tab.dart';
import 'package:flutter/material.dart';

import '../../../model/aquarium.dart';
import '../../../model/components/heater.dart';
import '../../../model/components/lighting.dart';
import 'tab/filter_tab.dart';

class CreateOrEditComponent extends StatefulWidget {

  final Filter filter;
  final Lighting lighting;
  final Heater heater;
  final Aquarium aquarium;
  const CreateOrEditComponent({super.key, required this.filter, required this.lighting, required this.heater, required this.aquarium});

  @override
  State<CreateOrEditComponent> createState() => _CreateOrEditComponentState();
}

class _CreateOrEditComponentState extends State<CreateOrEditComponent> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Komponenten bearbeiten"),
        backgroundColor: Colors.lightGreen,
        bottom: TabBar(
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.black.withOpacity(0.6),
          controller: _tabController,
          tabs: const [
            Tab(text: "Filter"),
            Tab(text: "Beleuchtung"),
            Tab(text: "Heizer"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FilterTab(filter: widget.filter, aquarium: widget.aquarium),
          LightingTab(lighting: widget.lighting, aquarium: widget.aquarium),
          HeaterTab(heater: widget.heater, aquarium: widget.aquarium),
        ],
      ),
    );
  }
}