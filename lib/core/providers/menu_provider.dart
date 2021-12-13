import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/animated_drawer_controller.dart';

class MenuProvider extends ChangeNotifier {
  MenuState _menuState = MenuState.closed;

  MenuState get menuState => _menuState;
  int? _menuIndex;

  int? get menuIndex => _menuIndex;

  void setMenuState(MenuState value) {
    _menuState = value;
    notifyListeners();
  }

  void setMenuIndex(int? index) {
    _menuIndex = index;
  }
}
