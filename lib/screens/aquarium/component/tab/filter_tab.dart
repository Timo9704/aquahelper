import 'package:aquahelper/model/aquarium.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../model/components/filter.dart';
import '../../../../util/datastore.dart';
import '../../../aquarium_overview.dart';

class FilterTab extends StatefulWidget {
  final Filter filter;
  final Aquarium aquarium;
  const FilterTab({super.key, required this.filter, required this.aquarium});

  @override
  State<FilterTab> createState() => _FilterTabState();
}

class _FilterTabState extends State<FilterTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _manufacturerModelNameController;
  late TextEditingController _filtertypeController;
  late TextEditingController _flowRateController;
  late TextEditingController _powerController;
  late TextEditingController _lastMaintenanceController;

  late String _selectedFilterType = "Innenfilter";
  final List<String> _filterTypes = ["Innenfilter", "Außenfilter", "Hang-On-Filter", "Bodenfilter", "Lufthebe-Filter", "HMF"];

  @override
  void initState() {
    super.initState();
    _manufacturerModelNameController = TextEditingController(text: widget.filter.manufacturerModelName);
    _filtertypeController = TextEditingController(text: widget.filter.filterType.toString());
    _flowRateController = TextEditingController(text: widget.filter.flowRate.toString());
    _powerController = TextEditingController(text: widget.filter.power.toString());
    _lastMaintenanceController = TextEditingController(text: DateFormat('dd.MM.yyyy').format(DateTime.fromMillisecondsSinceEpoch(widget.filter.lastMaintenance)));
    _selectedFilterType = _filterTypes[widget.filter.filterType];
  }

  @override
  void dispose() {
    _manufacturerModelNameController.dispose();
    _filtertypeController.dispose();
    _flowRateController.dispose();
    _powerController.dispose();
    _lastMaintenanceController.dispose();
    super.dispose();
  }

  getEditedFilter() {
    DateFormat format = DateFormat("dd.MM.yyyy");
    DateTime date = format.parse(_lastMaintenanceController.text);
    int lastMaintaincaneEpoch = date.millisecondsSinceEpoch;


    if(widget.filter.filterId == "") {
      return Filter(
        const Uuid().v4().toString(),
        widget.aquarium.aquariumId,
        _manufacturerModelNameController.text,
        int.parse(_filtertypeController.text),
        parseTextFieldValue(_powerController),
        parseTextFieldValue(_flowRateController),
        lastMaintaincaneEpoch,
      );
    }else{
      return Filter(
        widget.filter.filterId,
        widget.aquarium.aquariumId,
        _manufacturerModelNameController.text,
        _filterTypes.indexOf(_selectedFilterType),
        parseTextFieldValue(_powerController),
        parseTextFieldValue(_flowRateController),
        lastMaintaincaneEpoch,
      );
    }
  }

  double parseTextFieldValue(TextEditingController controller){
    if(controller.text.isEmpty){
      controller.text = "0.0";
      return 0.0;
    }
    controller.text = controller.text.replaceAll(RegExp(r','), '.');
    return double.parse(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _manufacturerModelNameController,
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
                  const SizedBox(width: 50), // space between the text and the dropdown (20px
                  DropdownButton<String>(
                      value: _selectedFilterType,
                      hint: const Text('Wähle dein Aquarium',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFilterType = newValue!;
                        });
                      },
                      items: _filterTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                              value,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black)),
                        );
                      }).toList(),
                    ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _flowRateController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Fördermenge',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _powerController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightGreen),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Leistung',
                ),
              ),
              TextFormField(
                controller: _lastMaintenanceController,
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
                    String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
                    setState(() {
                      _lastMaintenanceController.text = formattedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Datastore.db.updateFilter(getEditedFilter());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AquariumOverview(aquarium: widget.aquarium),
                      ),
                    );
                  }
                },
                child: const Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
