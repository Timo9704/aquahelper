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
};

late UserSettings userSettings;