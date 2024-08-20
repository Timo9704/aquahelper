import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

import '../model/runin_daytask.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}
LinkedHashMap<DateTime, List<Event>> allRunInEvents(DateTime startDate){
  DateTime kToday = startDate;

  final Map<DateTime, List<Event>> _kEventSource = {
    DateTime.utc(kToday.year, kToday.month, kToday.day): [
      const Event('Aquarium einrichten'),
      const Event('Filter anschließen und einschalten'),
      const Event('Beleuchtung auf 6 Stunden einstellen und einschalten'),
      const Event('ggf. Filter-Bakterien hinzufügen'),
    ],
    DateTime.utc(kToday.year, kToday.month, kToday.day).add(const Duration(days: 7)): [
      const Event('Reinigung von Scheiben'),
      const Event('40 % Wasserwechsel'),
      const Event('ggf. erste Algen in Form von Schwebealgen oder Grünbelag'),
    ],
    DateTime.utc(kToday.year, kToday.month, kToday.day).add(const Duration(days: 14)): [
      const Event('Wasserwerte messen (pH, KH, GH, NO2, NO3)'),
      const Event('40 % Wasserwechsel'),
      const Event('Beleuchtung auf 6,5 Stunden erhöhen'),
      const Event('ggf. Schnecken einsetzbar'),
    ],
    DateTime.utc(kToday.year, kToday.month, kToday.day).add(const Duration(days: 21)): [
      const Event('Nitritwert messen'),
      const Event('Scheiben reinigen'),
      const Event('erste gut wachsende Pflanzen zurückschneiden'),
      const Event('ggf. vorsichtig düngen (Eisenvolldünger/NPK-Dünger)'),
      const Event('Beleuchtung auf 7 Stunden erhöhen'),
    ],
    DateTime.utc(kToday.year, kToday.month, kToday.day).add(const Duration(days: 28)): [
      const Event('Nitritwert messen'),
      const Event('40 % Wasserwechsel'),
      const Event('Beleuchtung auf 7,5 Stunden erhöhen'),
      const Event('ggf. Garnelen einsetzen'),
      const Event('ggf. weitere Algen im Aquarium'),
    ],
  };

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  return LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(_kEventSource);
}


final List<RunInDayTaskModel> dayTasksData = [
  RunInDayTaskModel(
      1,
      "## Herzlich willkommen zum Start deines neuen Aquariums!\n\nHeute ist ein aufregender Tag, denn wir beginnen mit der Einrichtung und dem Start der Einlaufphase. Diese Phase ist entscheidend, um das biologische Gleichgewicht im Aquarium zu etablieren, bevor die ersten Bewohner einziehen können.",
      "### Heute legen wir den Grundstein für dein neues Aquarium. Es ist wichtig, die folgenden Schritte sorgfältig durchzuführen:\n\n"
          "- **Aquarium einrichten:** Sorge dafür, dass der Bodengrund, die Dekorationen und die Pflanzen richtig platziert sind. Dies ist nicht nur optisch wichtig, sondern schafft auch Versteckmöglichkeiten und eine natürliche Umgebung für zukünftige Bewohner.\n"
          "- **Filter anschließen und einschalten:** Der Filter sorgt für sauberes und gesundes Wasser, indem er Schmutzpartikel entfernt und das Wasser in Bewegung hält. Ein gut funktionierender Filter ist essenziell für das Wohlbefinden der Fische.\n"
          "- **Beleuchtung auf 6 Stunden einstellen und einschalten:** Die Beleuchtung spielt eine Schlüsselrolle im Pflanzenwachstum und sollte anfangs auf eine moderate Dauer von 6 Stunden eingestellt werden, um Algenbildung zu vermeiden.\n"
          "- **Ggf. Filter-Bakterien hinzufügen:** Falls du nicht mit eingefahrenem Filtermaterial arbeitest, kannst du Bakterienkulturen hinzufügen, um den Aufbau der biologischen Filterung zu beschleunigen."
  ),
  RunInDayTaskModel(
      7,
      "## Eine Woche ist vergangen!\n\nDein Aquarium beginnt sich zu entwickeln. Heute kümmern wir uns um die erste Reinigung und einen Teilwasserwechsel, um die Wasserqualität stabil zu halten.",
      "### Nach der ersten Woche ist es wichtig, das Aquarium sauber zu halten und die Wasserqualität zu sichern:\n\n"
          "- **Reinigung von Scheiben:** Nutze einen Algenmagneten oder einen speziellen Schwamm, um die Scheiben von eventuellen Algen oder Schmutz zu befreien. Klare Scheiben bieten dir einen ungetrübten Blick auf dein Aquarium.\n"
          "- **40 % Wasserwechsel:** Ein Wasserwechsel hilft, Schadstoffe zu entfernen und die Wasserqualität zu stabilisieren. Achte darauf, das neue Wasser auf die gleiche Temperatur wie das Aquarienwasser zu bringen, um Stress für die Pflanzen und zukünftigen Tiere zu vermeiden.\n"
          "- **Ggf. erste Algen in Form von Schwebealgen oder Grünbelag:** Algen können sich in der Anfangsphase bilden. Diese sind meist harmlos und Teil des natürlichen Einlaufprozesses. Entferne sie manuell oder lasse sie von Algenfressern kontrollieren."
  ),
  RunInDayTaskModel(
      14,
      "## Zwei Wochen sind vergangen!\n\nDein Aquarium nimmt weiter Form an. Heute überprüfen wir die Wasserwerte und passen die Beleuchtung an, um das Wachstum der Pflanzen zu fördern und die Algenbildung zu kontrollieren.",
      "### Es ist Zeit für den nächsten Schritt in der Pflege deines Aquariums:\n\n"
          "- **Wasserwerte messen (pH, KH, GH, NO2, NO3):** Teste das Wasser auf wichtige Parameter, um sicherzustellen, dass das biologische Gleichgewicht sich gut entwickelt. Diese Werte sind entscheidend für das Wohlbefinden der zukünftigen Bewohner.\n"
          "- **40 % Wasserwechsel:** Wiederhole den Wasserwechsel, um Schadstoffe weiter zu reduzieren und frisches Wasser hinzuzufügen. Dies hilft, das biologische Gleichgewicht zu unterstützen.\n"
          "- **Beleuchtung auf 6,5 Stunden erhöhen:** Um das Pflanzenwachstum zu fördern, kannst du die Beleuchtungszeit leicht erhöhen. Achte jedoch darauf, die Beleuchtungsdauer nur schrittweise zu verlängern, um Algenwachstum zu vermeiden.\n"
          "- **Ggf. Schnecken einsetzbar:** Wenn die Wasserwerte stabil sind und keine hohen Nitritwerte vorhanden sind, kannst du erste Schnecken einsetzen. Diese helfen, das Aquarium sauber zu halten, indem sie Algen und organische Reste fressen."
  ),
  RunInDayTaskModel(
      21,
      "## Drei Wochen sind vergangen!\n\nDein Aquarium entwickelt sich weiter, und heute steht die erste Pflege der Pflanzen sowie die Überprüfung des Nitritwertes im Mittelpunkt.",
      "### Jetzt ist es an der Zeit, sich um die Pflanzenpflege zu kümmern und den Nitritwert zu überwachen:\n\n"
          "- **Nitritwert messen:** Der Nitritwert ist ein wichtiger Indikator für den Reifegrad des Aquariums. Ein zu hoher Nitritwert kann für Fische gefährlich sein, daher ist es wichtig, diesen regelmäßig zu überprüfen.\n"
          "- **Scheiben reinigen:** Halte die Scheiben weiterhin sauber, um eine klare Sicht auf dein Aquarium zu gewährleisten und die Bildung von Algenbelag zu verhindern.\n"
          "- **Erste gut wachsende Pflanzen zurückschneiden:** Ein gesunder Pflanzenwuchs ist ein gutes Zeichen. Schneide die Pflanzen vorsichtig zurück, um ihnen einen kompakteren Wuchs zu ermöglichen und Platz für neue Triebe zu schaffen.\n"
          "- **Ggf. vorsichtig düngen (Eisenvolldünger/NPK-Dünger):** Wenn die Pflanzen Anzeichen von Nährstoffmangel zeigen (z. B. gelbe Blätter), kannst du vorsichtig düngen. Achte darauf, nicht zu überdüngen, um Algenwachstum zu vermeiden.\n"
          "- **Beleuchtung auf 7 Stunden erhöhen:** Um das Pflanzenwachstum weiter zu fördern, kannst du die Beleuchtungsdauer erneut leicht erhöhen."
  ),
  RunInDayTaskModel(
      28,
      "## Vier Wochen sind vergangen!\n\nDein Aquarium ist nun stabiler, und vielleicht ist es schon bereit für die ersten Garnelen. Heute steht die Vorbereitung auf den nächsten Schritt im Mittelpunkt.",
      "### Die Einlaufphase nähert sich ihrem Ende, und das Aquarium wird bereit für erste Bewohner:\n\n"
          "- **Nitritwert messen:** Überprüfe nochmals den Nitritwert. Ein niedriges Nitritniveau zeigt an, dass das Aquarium fast bereit ist, besetzt zu werden.\n"
          "- **40 % Wasserwechsel:** Ein letzter großer Wasserwechsel hilft, die Wasserqualität für die neuen Bewohner zu optimieren.\n"
          "- **Beleuchtung auf 7,5 Stunden erhöhen:** Mit einer weiteren Erhöhung der Beleuchtungsdauer förderst du das Pflanzenwachstum und stabilisierst das ökologische Gleichgewicht.\n"
          "- **Ggf. Garnelen einsetzen:** Wenn die Wasserwerte stabil und der Nitritwert niedrig sind, kannst du erste Garnelen einsetzen. Diese tragen zur Sauberkeit des Aquariums bei und sind eine spannende Ergänzung.\n"
          "- **Ggf. weitere Algen im Aquarium:** Achte darauf, ob sich weitere Algen im Aquarium entwickeln. Algen sind normal in einem neuen Aquarium, sollten jedoch kontrolliert werden, um ein Übermaß zu vermeiden."
  ),
];
