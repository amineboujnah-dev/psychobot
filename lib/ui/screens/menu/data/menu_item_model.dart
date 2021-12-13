import 'package:flutter/cupertino.dart';

class MenuItemModel {
  const MenuItemModel(
      {this.menuItemIndex, this.menuItemTitle, this.menuItemIcon});

  final int? menuItemIndex;
  final String? menuItemTitle;
  final IconData? menuItemIcon;
}
