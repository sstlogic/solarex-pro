import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarex/first_phase/screenUI/findMeeting/component/body.dart';

import '../../../theme/style.dart';
import '../../../utils/constants.dart';
import '../../../utils/image_app.dart';
import '../../../utils/theme.dart';

class MeetingScreen extends StatelessWidget {
  static String routeName = "/meeting";

  const MeetingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Welcome",
          style:textHeader,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: fullWidth * .04),
            child: const Center(
                child: Text(
              "v1.0.0",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            )),
          )
        ],
      ),
      body: const Body()
    );
  }
}
