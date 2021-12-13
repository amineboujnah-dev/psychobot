import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:psychobot/core/providers/menu_provider.dart';
import 'package:psychobot/ui/screens/menu/data/menu_item_model.dart';
import 'package:psychobot/ui/ui_utils/config_setup/size_config.dart';
import 'package:provider/provider.dart';

class MenuListItem extends StatelessWidget {
  const MenuListItem({Key? key, this.menuItemModel}) : super(key: key);

  final MenuItemModel? menuItemModel;

  @override
  Widget build(BuildContext context) {
    final sizeConfig = SizeConfig();
    sizeConfig.init(context);
    final menuProvider = Provider.of<MenuProvider>(context);
    sizeConfig.menuController = SimpleHiddenDrawerController.of(context);
    sizeConfig.menuController.addListener(() {
      menuProvider.setMenuState((sizeConfig.menuController.state));
    });
    return GestureDetector(
      onTap: () {
        if (menuItemModel?.menuItemIndex != null) {
          menuProvider.setMenuIndex(menuItemModel!.menuItemIndex);
          sizeConfig.menuController
              .setSelectedMenuPosition(menuItemModel!.menuItemIndex!);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: sizeConfig.getProportionateScreenWidth(24),
            horizontal: sizeConfig.getProportionateScreenWidth(20)),
        child: Row(
          children: <Widget>[
            if (menuItemModel?.menuItemIcon != null)
              Icon(
                menuItemModel!.menuItemIcon!,
                color: Colors.white,
              ),
            SizedBox(
              width: sizeConfig.getProportionateScreenWidth(16),
            ),
            Text(
              menuItemModel?.menuItemTitle ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: sizeConfig.getProportionateScreenWidth(20),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
