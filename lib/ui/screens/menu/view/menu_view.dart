import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/animated_drawer_content.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';
import 'package:psychobot/core/models/user_model.dart';
import 'package:psychobot/core/providers/menu_provider.dart';
import 'package:psychobot/core/services/user_service.dart';
import 'package:psychobot/ui/screens/Home/widgets/stream_provider.dart';
import 'package:psychobot/ui/screens/Profile/Profile%20Details/view/profile_details_view.dart';
import 'package:psychobot/ui/screens/menu/widgets/menu_list_widget.dart';
import 'package:psychobot/ui/ui_utils/config_setup/size_config.dart';
import 'package:provider/provider.dart';

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizedConfig = SizeConfig();
    final menuProvider = Provider.of<MenuProvider>(context);
    final userProvider = Provider.of<UserModel?>(context);
    sizedConfig.init(context);
    return SimpleHiddenDrawer(
      verticalScalePercent: sizedConfig.getProportionateScreenWidth(60),
      slidePercent: sizedConfig.getProportionateScreenWidth(60),
      menu: StreamProvider<UserData>.value(
        value: UserService(uid: userProvider!.id).userData,
        initialData: UserData("", "", "", "", "", ""),
        child: MenuListWidget(),
      ),
      screenSelectedBuilder:
          (position, SimpleHiddenDrawerController controller) {
        final int viewPosition = menuProvider.menuIndex ?? position;
        Widget? screenCurrent = HomeScreen();
        switch (viewPosition) {
          case 0:
            {
              screenCurrent = HomeScreen();
            }
            break;
          case 1:
            {
              screenCurrent = ProfileView();
            }
            break;
        }
        return screenCurrent;
      },
      withShadow: true,
      contentCornerRadius: 25,
      enableCornerAnimation: true,
      enableScaleAnimation: true,
      curveAnimation: Curves.easeInBack,
      isDraggable: true,
      initPositionSelected: 0,
      typeOpen: TypeOpen.FROM_LEFT,
    );
  }
}
