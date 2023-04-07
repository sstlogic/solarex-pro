import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarex/first_phase/screenUI/confirmation/component/body.dart';

import '../../../theme/style.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';

class ConfirmMeetingScreen extends StatelessWidget {
  static String routeName = "/confirm";
  const ConfirmMeetingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: const Text(
          "Welcome",
          style: textHeader,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: fullWidth * .02),
            child: const Center(
                child: Text(
                  "v1.0.0",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                )),
          )
        ],
      ),
      body: const Body(),
    );
  }

}
