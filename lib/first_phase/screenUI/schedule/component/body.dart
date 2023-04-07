import 'package:flutter/material.dart';
import 'package:solarex/first_phase/Server/MeetingTimeAPI.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/dialog_widget.dart';
import 'package:solarex/utils/image_app.dart';

import '../../../../theme/style.dart';
import '../../../../utils/colors_app.dart';
import '../../../../utils/theme.dart';
import '../../secondSchedule/second_schedule_screen.dart';

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
            child: Container(
          margin: EdgeInsets.only(top: fullHeight * .05),
          child: Column(
            children: [
              Center(
                child: Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.only(top: fullWidth * .10),
                    child: (ConstantClass.repNumResponse!.repNumUserData!.userPic != null &&
                            ConstantClass.repNumResponse!.repNumUserData!.userPic.toString().startsWith('http'))
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(300)),
                            child: CircleAvatar(
                              radius: 40,
                              child: Image.network(
                                ConstantClass.repNumResponse!.repNumUserData!.userPic!,
                                height: 135,
                                width: 135,
                              ),
                            ))
                        : ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(300)),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(imguser),
                            ))),
                // SizedBox(
                //   width: 70,
                //   height: 70,
                //   child: CircleAvatar(
                //     backgroundColor: Colors.black54,
                //     radius: 80,
                //     child: ClipRRect(
                //         borderRadius: BorderRadius.all(Radius.circular(300)),
                //         child: CircleAvatar(
                //           backgroundColor: Color(0xff6E83B7),
                //           radius: 40,
                //           backgroundImage: AssetImage(iconUser),
                //         )),
                //   ),
                // ),
              ),
              SizedBox(
                height: fullWidth * .03,
              ),
              Text(
                "${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}",
                style: textProfileName,
              ),
            ],
          ),
        )),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(top: fullHeight * .05, left: 10, right: 10),
          child: Column(
            children: [
              Text(
                "Was ${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()} on time?",
                style: textOnTime,
              ),
            ],
          ),
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size.fromHeight(40), // NEW
              ),
              onPressed: () {
                callAPI("ON TIME");
              },
              child: Text(
                "ON TIME".toUpperCase(),
                style: textBtn,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size.fromHeight(40), // NEW
              ),
              onPressed: () {
                callAPI("LATE");
              },
              child: Text(
                "LATE".toUpperCase(),
                style: textBtn,
              ),
            ),
          ),
        ),
        // Row(
        //   children: [
        //     Expanded(
        //         child: Padding(
        //       padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
        //       child: Align(
        //         alignment: FractionalOffset.bottomCenter,
        //         child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             primary: Colors.black,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(6),
        //             ),
        //             minimumSize: const Size.fromHeight(50), // NEW
        //           ),
        //           onPressed: () {},
        //           child: const Text(
        //             "ENTER NEW CODE",
        //           ),
        //         ),
        //       ),
        //     )),
        //     Expanded(
        //         child: Padding(
        //       padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
        //       child: Align(
        //         alignment: FractionalOffset.bottomCenter,
        //         child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //             primary: kPrimaryColor,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(6),
        //             ),
        //             minimumSize: const Size.fromHeight(50), // NEW
        //           ),
        //           onPressed: () {},
        //           child: const Text(
        //             "CONTINUE",
        //           ),
        //         ),
        //       ),
        //     ))
        //   ],
        // )
      ],
    ));
  }

  callAPI(String status) {
    print("::::HARDIK:::");
    print("MEETTING NUMBER===${ConstantClass.meetingNumber}");
    _waits(true);
    meetingTimeAPI(ConstantClass.meetingNumber, status, _sucessAPI, _error);
  }

  _waits(bool value) {
    if (value) {
      showLoaderDialog(context);
    } else {
      Navigator.pop(context);
    }
  }

  _sucessAPI(String? message, String? status) {
    _waits(false);
    setState(() {
      Navigator.pushNamed(context, SecondScheduleScreen.routeName);
    });
  }

  _error(String error) {
    _waits(false);
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (_) => DialogWidget(
              title: "" + error,
              button1: 'Ok',
              onButton1Clicked: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              height: 150,
            ));
  }
}
