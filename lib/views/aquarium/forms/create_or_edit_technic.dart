import 'package:aquahelper/model/aquarium.dart';
import 'package:aquahelper/model/components/filter.dart';
import 'package:aquahelper/model/components/heater.dart';
import 'package:aquahelper/model/components/lighting.dart';
import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_technic_viewmodel.dart';
import 'package:aquahelper/views/aquarium/tabs/filter_tab.dart';
import 'package:aquahelper/views/aquarium/tabs/heater_tab.dart';
import 'package:aquahelper/views/aquarium/tabs/lighting_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrEditComponent extends StatefulWidget {
  final Filter filter;
  final Lighting lighting;
  final Heater heater;
  final Aquarium aquarium;

  const CreateOrEditComponent(
      {super.key,
      required this.filter,
      required this.lighting,
      required this.heater,
      required this.aquarium});

  @override
  State<CreateOrEditComponent> createState() => _CreateOrEditComponentState();
}

class _CreateOrEditComponentState extends State<CreateOrEditComponent>
    with SingleTickerProviderStateMixin {
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
    return ChangeNotifierProvider(
      create: (context) => CreateOrEditTechnicViewModel(
          widget.filter, widget.lighting, widget.heater, widget.aquarium),
      child: Consumer<CreateOrEditTechnicViewModel>(
        builder: (context, viewModel, child) => Scaffold(
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
            children: const [
              FilterTab(),
              LightingTab(),
              HeaterTab(),
            ],
          ),
        ),
      ),
    );
  }
}
