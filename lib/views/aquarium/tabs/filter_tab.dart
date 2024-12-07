import 'package:aquahelper/viewmodels/aquarium/forms/create_or_edit_technic_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterTab extends StatelessWidget {
  const FilterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrEditTechnicViewModel>(
        builder: (context, viewModel, child) => SingleChildScrollView(
          child: Form(
            key: viewModel.filterFormKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: viewModel.manufacturerModelNameController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Hersteller & Modell',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte geben Sie Hersteller & Modell an';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("Filtertyp",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.start),
                      const SizedBox(width: 50),
                      // space between the text and the dropdown (20px
                      DropdownButton<String>(
                        value: viewModel.selectedFilterType,
                        hint: const Text('Wähle dein Aquarium',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.normal)),
                        onChanged: (newValue) {
                          viewModel.setFilterType(newValue!);
                        },
                        items: viewModel.filterTypes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: viewModel.flowRateController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Fördermenge (in L/h)',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: viewModel.powerController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Leistung (in Watt)',
                    ),
                  ),
                  TextFormField(
                    controller: viewModel.lastMaintenanceController,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: 'Letzte Reinigung',
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd.MM.yyyy').format(pickedDate);
                        viewModel.lastMaintenanceController.text =
                            formattedDate;
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                    ),
                    onPressed: () => viewModel.saveFilter(context),
                    child: const Text('Speichern'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
