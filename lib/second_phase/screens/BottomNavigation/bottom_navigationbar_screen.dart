import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarex/Second_Phase/Screens/DialPad/dialpad_screen.dart';
import 'package:solarex/Second_Phase/Screens/More/more_screen.dart';
import 'package:solarex/Second_Phase/Screens/PhoneNow/phonenow_screen.dart';
import 'package:solarex/Second_Phase/Screens/Prospects/prospects_screen.dart';
import 'package:solarex/Second_Phase/Screens/Schedule/schedule_screen.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/second_phase/models/selectedTeamMemberModel.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/constants.dart';

import '../../../theme/colors.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({final Key? key, required this.menuScreenContext, this.pageIndex}) : super(key: key);
  final BuildContext menuScreenContext;
  final int? pageIndex;

  @override
  _BottomNavigationBarScreenState createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  late PersistentTabController _controller;
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);

    // _controller = PersistentTabController(initialIndex: widget.pageIndex != null ? widget.pageIndex! : 0);
  }

  List<Widget> _buildScreens() =>
      [const ScheduleScreen(), const PhoneNowScreen(), const DialpadScreen(), const ProspectsScreen(), const MoreScreen()];

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
            icon: const Icon(Icons.calendar_today),
            title: "Schedule",
            textStyle: textbottomMenu,
            activeColorPrimary: kPrimaryColor,
            inactiveColorPrimary: Colors.grey,
            inactiveColorSecondary: kPrimaryColor),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.phone),
          title: "Phone Now",
          textStyle: textbottomMenu,
          activeColorPrimary: kPrimaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.dialpad),
          title: "Dialpad",
          textStyle: textbottomMenu,
          activeColorPrimary: kPrimaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: "Prospects",
          textStyle: textbottomMenu,
          activeColorPrimary: kPrimaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.more_horiz),
          title: "More",
          textStyle: textbottomMenu,
          activeColorPrimary: kPrimaryColor,
          inactiveColorPrimary: Colors.grey,
        ),
      ];

  @override
  Widget build(final BuildContext context) => WillPopScope(
        onWillPop: null,
        child: Scaffold(
          // appBar: AppBar(),
          body: Obx(
            () => PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: false,
              confineInSafeArea: true,
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              hideNavigationBar: authController.hideNav.value,
              navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0 ? 0.0 : kBottomNavigationBarHeight,
              bottomScreenMargin: 0,
              onWillPop: null,
              // (final context) async {
              // await showDialog(
              //   context: context!,
              //   useSafeArea: true,
              //   builder: (final context) => Container(
              //     height: 50,
              //     width: 50,
              //     color: Colors.white,
              //     child: ElevatedButton(
              //       child: const Text("Close"),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //   ),
              // );
              // return false;
              // },

              backgroundColor: Colors.white,
              decoration: const NavBarDecoration(colorBehindNavBar: Colors.indigo),
              itemAnimationProperties: const ItemAnimationProperties(
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                animateTabTransition: true,
              ),
              navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property
            ),
          ),
        ),
      );
}
