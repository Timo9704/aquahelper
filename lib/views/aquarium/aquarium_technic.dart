import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/aquarium.dart';
import '../../viewmodels/aquarium/aquarium_technik_viewmodel.dart';
import '../../views/components/filter_item.dart';
import '../../views/components/heater_item.dart';
import '../../views/components/lighting_item.dart';
import 'forms/create_or_edit_technic.dart';

class AquariumTechnic extends StatelessWidget {
  final Aquarium aquarium;

  const AquariumTechnic({super.key, required this.aquarium});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AquariumTechnicViewModel(aquarium),
      child: Consumer<AquariumTechnicViewModel>(
          builder: (context, viewModel, child) {
        if (viewModel.filter == null ||
            viewModel.lighting == null ||
            viewModel.heater == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(children: <Widget>[
            FilterItem(filter: viewModel.filter!),
            LightingItem(lighting: viewModel.lighting!),
            HeaterItem(heater: viewModel.heater!),
            const SizedBox(height: 10),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateOrEditComponent(
                          filter: viewModel.filter!,
                          lighting: viewModel.lighting!,
                          heater: viewModel.heater!,
                          aquarium: viewModel.aquarium),
                    ),
                  );
                },
                child: const Text('Komponenten bearbeiten')),
            const SizedBox(height: 10),
          ]);
        }
      }),
    );
  }
}
