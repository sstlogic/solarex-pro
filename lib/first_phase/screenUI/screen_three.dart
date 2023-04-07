import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarex/utils/colors_app.dart';
import 'package:solarex/utils/image_app.dart';

import '../../theme/style.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class ScreenThree extends StatelessWidget {
  const ScreenThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black));
    var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: const Text(
          "Feedback",
          style: TextStyle(color: kPrimaryColor, fontSize: 16),
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
      body: SafeArea(
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
              const Text(
                "Found meeting for",
              ),
              Text(
                "${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}",
              ),
            ],
          )),
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
                      "ENTER NEW CODE", style: textBtn,
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
                    onPressed: () {},
                    child: const Text(
                      "CONTINUE", style: textBtn,
                    ),
                  ),
                ),
              ))
            ],
          )
        ],
      )),
    );
  }
}
