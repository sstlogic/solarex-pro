import 'package:flutter/material.dart';
import 'package:solarex/first_phase/screenUI/profileScreen/component/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profileScreen";

  const ProfileScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }

}
