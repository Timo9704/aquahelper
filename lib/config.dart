import 'model/user_settings.dart';

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
};

late UserSettings userSettings;

late String _userId;


getUserId() {
  return _userId;
}

setUserId(String userId) {
  _userId = userId;
}