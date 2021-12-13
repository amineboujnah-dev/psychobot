import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/animated_drawer_controller.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:psychobot/core/providers/menu_provider.dart';
import 'package:psychobot/ui/ui_utils/config_setup/size_config.dart';
import 'package:provider/provider.dart';

class MenuIconWidget extends StatelessWidget {
  const MenuIconWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final sizeConfig = SizeConfig();
    sizeConfig.init(context);
    sizeConfig.menuController = SimpleHiddenDrawerController.of(context);
    return GestureDetector(
      onTap: () {
        sizeConfig.menuController.toggle();
      },
      child: menuProvider.menuState == MenuState.closed
          ? Padding(
              padding: EdgeInsets.only(top: sizeConfig.screenHeight * 0.01),
              child: Icon(
                Icons.menu,
                color: Colors.black,
                size: sizeConfig.getProportionateScreenWidth(30),
              ))
          : Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: sizeConfig.getProportionateScreenWidth(35),
            ),
    );
  }
}
