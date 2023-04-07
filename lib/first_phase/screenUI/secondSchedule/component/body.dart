import 'package:flutter/material.dart';
import 'package:solarex/first_phase/Server/SchedulingAppointmentAPI.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/dialog_widget.dart';
import 'package:solarex/utils/image_app.dart';
import '../../../../theme/style.dart';
import 'package:solarex/first_phase/screenUI/thirdSchedule/third_schedule_screen.dart';

import '../../../../utils/colors_app.dart';
import '../second_schedule_screen.dart';

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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
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
                SizedBox(
                  height: fullWidth * .03,
                ),
                Text(
                  "${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}",
                  style: textProfileName,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Was ${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()} professional and courteous while scheduling this appointment?',
                textAlign: TextAlign.center,
                style: textOnTime,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // InkWell(
              //   onTap: () => Navigator.pushNamed(
              //       context, SecondScheduleScreen.routeName),
              //   child: Container(
              //       width: fullWidth,
              //       height: 40,
              //       margin: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
              //       padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: kPrimaryColor,
              //         boxShadow: const [
              //           BoxShadow(
              //               color: kPrimaryColor,
              //               spreadRadius: 3
              //           ),
              //         ],
              //       ),
              //       child: Center(
              //         child: Text('yes'.toUpperCase(),
              //           textAlign: TextAlign.center,
              //           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
              //       )
              //   ),
              // ),
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
                      callAPI("yes".toUpperCase());
                    },
                    child: Text(
                      "yes".toUpperCase(),
                      style: textBtn,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
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
                      callAPI("needs improvement".toUpperCase());
                    },
                    child: Text(
                      "needs improvement".toUpperCase(),
                      style: textBtn,
                    ),
                  ),
                ),
              ),

              // InkWell(
              //   // onTap: () => Navigator.pushNamed(
              //   //     context, ThirdScheduleScreen.routeName),
              //   child: Container(
              //       width: fullWidth,
              //       height: 40,
              //       margin: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
              //       padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: Colors.black,
              //         boxShadow: const [
              //           BoxShadow(
              //               color: kPrimaryColor,
              //               spreadRadius: 3
              //           ),
              //         ],
              //       ),
              //       child: Center(
              //         child: Text('needs improvement'.toUpperCase(),
              //           textAlign: TextAlign.center,
              //           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
              //       )
              //   ),
              // ),

              const SizedBox(
                height: defaultPadding,
              ),
            ],
          ),
        ],
      ),
    );
  }

  callAPI(String status) {
    _waits(true);
    schedulingAppointmentAPI(ConstantClass.meetingNumber, status, _sucessAPI, _error);
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
      Navigator.pushNamed(context, ThirdScheduleScreen.routeName);
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
