import 'package:aquahelper/model/activity.dart';

class Event {
  final String title;
  final Activity activity;

  const Event(this.title, this.activity);

  @override
  String toString() => title;
}