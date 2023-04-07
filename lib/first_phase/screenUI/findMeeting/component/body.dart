import 'package:flutter/material.dart';
import 'package:solarex/utils/colors_app.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:solarex/first_phase/screenUI/schedule/schedule_screen.dart';

import '../../../../theme/style.dart';
import '../../../../utils/theme.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);
    return SafeArea(
        child: Column(
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: fullWidth * .4, right: fullWidth * .4),
                child: Image.asset(imgDone)),
            SizedBox(
              height: fullWidth * .02,
            ),
            const Text(
              "Found meeting for",
              style: textDescription,
            ),
            SizedBox(
              height: fullWidth * .02,
            ),
            Text(
              "${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}",
              style: textsemiBoldBlue,
            ),
          ],
        )),
        SizedBox(height: fullHeight * .3),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ENTER NEW CODE",
                    style: textBtn,
                  ),
                ),
              ),
            )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {

                    Navigator.pushNamed(context, ScheduleScreen.routeName);
                  },
                  child: const Text(
                    "CONTINUE",
                    style: textBtn,
                  ),
                ),
              ),
            ))
          ],
        )
      ],
    ));
  }

}
