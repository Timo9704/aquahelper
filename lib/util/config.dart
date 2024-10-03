import '../model/user_settings.dart';

const List<String> waterValues = [
  'temperature',
  'ph',
  'totalHardness',
  'carbonateHardness',
  'nitrite',
  'nitrate',
  'phosphate',
  'potassium',
  'iron',
  'magnesium',
  'conductance',
  'silicate',
  'ammonium'
];

const Map<String, String> waterValuesTextMap = {
  'temperature':'Temperatur in °C',
  'ph': 'pH-Wert',
  'totalHardness': 'Gesamthärte - GH',
  'carbonateHardness': 'Karbonathärte - KH',
  'nitrite': 'Nitrit - NO2',
  'nitrate': 'Nitrat - NO3',
  'phosphate': 'Phosphat - PO4',
  'potassium': 'Kalium - K',
  'iron': 'Eisen - FE',
  'magnesium': 'Magnesium - MG',
  'conductance': 'Leitwert',
  'silicate': 'Silikat - SiO2',
  'ammonium': 'Ammonium - NH4'
};

const Map<String, Map<String, double>> waterValuesInterval = {
  'temperature': {'min' : 18, 'max' : 28},
  'ph': {'min' : 6.0, 'max' : 7.5},
  'totalHardness': {'min' : 0, 'max' : 25},
  'carbonateHardness': {'min' : 0, 'max' : 25},
  'nitrite': {'min' : 0.0, 'max' : 0.01},
  'nitrate': {'min' : 10.0, 'max' : 25.0},
  'phosphate': {'min' : 0.1, 'max' : 1},
  'potassium': {'min' : 5.0, 'max' : 15.0},
  'iron': {'min' : 0.05, 'max' : 0.1},
  'magnesium': {'min' : 10, 'max' : 50},
  'conductance': {'min' : 0.0, 'max' : 1000.0},
  'silicate': {'min' : 0.0, 'max' : 0.8},
  'ammonium': {'min' : 0.0, 'max' : 0.1}
};

late UserSettings userSettings;

late String _userId;


getUserId() {
  return _userId;
}

setUserId(String userId) {
  _userId = userId;
}