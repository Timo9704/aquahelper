import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final Map<DateTime, List<Event>> _kEventSource = {
  DateTime.utc(kToday.year, kToday.month, kToday.day): [
    Event('Aquarium einrichten'),
    Event('Filter anschließen und einschalten'),
    Event('Beleuchtung auf 6 Stunden einstellen und einschalten'),
    Event('ggf. Filter-Bakterien hinzufügen'),
  ],
  DateTime.utc(kToday.year, kToday.month, kToday.day).add(const Duration(days: 7)): [
    Event('Reinigung von Scheiben'),
    Event('40 % Wasserwechsel'),
    Event('ggf. erste Algen in Form von Schwebealgen oder Grünbelag'),
  ],
  DateTime.utc(kToday.year, kToday.month, kToday.day).add(const Duration(days: 14)): [
    Event('Wasserwerte messen (pH, KH, GH, NO2, NO3)'),
    Event('40 % Wasserwechsel'),
    Event('Beleuchtung auf 6,5 Stunden erhöhen'),
    Event('ggf. Schnecken einsetzbar'),
  ],
  DateTime.utc(kToday.year, kToday.month, kToday.day).add(const Duration(days: 21)): [
    Event('Nitritwert messen'),
    Event('Scheiben reinigen'),
    Event('erste gut wachsende Pflanzen zurückschneiden'),
    Event('ggf. vorsichtig düngen (Eisenvolldünger/NPK-Dünger)'),
    Event('Beleuchtung auf 7 Stunden erhöhen'),
  ],
  DateTime.utc(kToday.year, kToday.month, kToday.day).add(const Duration(days: 28)): [
    Event('Nitritwert messen'),
    Event('40 % Wasserwechsel'),
    Event('Beleuchtung auf 7,5 Stunden erhöhen'),
    Event('ggf. Garnelen einsetzen'),
    Event('ggf. weitere Algen im Aquarium'),
  ],
};

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime.now();
final kLastDay = DateTime(kToday.year, kToday.month + 2, kToday.day);