import 'package:flutter/material.dart';
import 'package:solarex/first_phase/Server/RatingAPI.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:solarex/utils/constants.dart';
import '../../../../theme/style.dart';
import 'package:solarex/first_phase/screenUI/feedback/feedback_screen.dart';

import '../../../../utils/colors_app.dart';
import '../../../../utils/dialog_widget.dart';
import '../third_schedule_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> listRating = <String>[];
  int selected = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listRating.add("1");
    listRating.add("2");
    listRating.add("3");
    listRating.add("4");
    listRating.add("5");
    listRating.add("6");
    listRating.add("7");
    listRating.add("8");
    listRating.add("9");
    listRating.add("10");
  }

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
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  "Please rate ${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}'s solar\nknowledge.",
                  textAlign: TextAlign.center,
                  style: textOnTime),
            ),
          ),
          // Container(
          //   color: Colors.white,
          //   padding: const EdgeInsets.all(10.0),
          //   child:  RatingBarIndicator(
          //     rating: _userRating,
          //     itemBuilder: (context, index) => Icon(
          //       _selectedIcon ?? Icons.star,
          //       color: Colors.amber,
          //     ),
          //     itemCount: 5,
          //     itemSize: 50.0,
          //     unratedColor: Colors.amber.withAlpha(50),
          //     direction: _isVertical ? Axis.vertical : Axis.horizontal,
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    for (int i = 0; i < listRating.length; i++)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selected = i;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFc2c0c1)), color: selected == i ? kPrimaryColor : const Color(0xFFefebea)),
                            child: Center(
                                child: Text(
                              listRating[i],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: selected == i ? Colors.white : Colors.black,
                                fontSize: 16.0,
                              ),
                            )),
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {
                    _waits(true);
                    ratingAPI(ConstantClass.meetingNumber, int.parse(listRating[selected]), _sucessAPI, _error);
                  },
                  child: Text(
                    "continue".toUpperCase(),
                    style: textBtn,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: defaultPadding,
          ),

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     InkWell(
          //       // onTap: () => Navigator.pushNamed(
          //       //     context, FeedbackScreen.routeName),
          //       child: Container(
          //           width: fullWidth,
          //           height: 40,
          //           margin: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
          //           padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             color: kPrimaryColor,
          //             boxShadow: const [
          //               BoxShadow(
          //                   color: kPrimaryColor,
          //                   spreadRadius: 3
          //               ),
          //             ],
          //           ),
          //           child: Center(
          //             child: Text('continue'.toUpperCase(),
          //               textAlign: TextAlign.center,
          //               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
          //           )
          //       ),
          //     ),
          //
          //     SizedBox(height: defaultPadding,),
          //
          //
          //
          //   ],
          // ),
        ],
      ),
    );
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
      // Navigator.pop(context);
      Navigator.pushNamed(context, FeedbackScreen.routeName);
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
