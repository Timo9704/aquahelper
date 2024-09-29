import 'package:flutter/material.dart';

class HomepageViewModel extends ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  void setSelectedPage(int index) {
    _selectedPage = index;
    notifyListeners();
  }
}
