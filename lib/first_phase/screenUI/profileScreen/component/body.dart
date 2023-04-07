import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../theme/style.dart';
import '../../../../utils/colors_app.dart';
import '../../shareScreen/share_screen.dart';

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
          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.only(top: fullWidth * .10),
                    child: (ConstantClass.repNumResponse!.repNumUserData!.userPic != null &&
                            ConstantClass.repNumResponse!.repNumUserData!.userPic.toString().startsWith('http'))
                        ? ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(300)),
                            child: CircleAvatar(
                              radius: 40,
                              child: Image.network(
                                ConstantClass.repNumResponse!.repNumUserData!.userPic!,
                                height: 135,
                                width: 135,
                                // fit: BoxFit.contain,
                              ),
                            ))
                        : const ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(300)),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(imguser),
                            ))),
              ),
              const SizedBox(
                height: defaultPadding * 2,
              ),

              Expanded(
                  child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}",
                        style: textsemiBoldBlue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        // ConstantClass.repNumResponse!.repNumUserData!.mobile!,
                        ConstantClass.repNumResponse?.repNumUserData?.mobile ?? "",
                        style: textsemiBold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        ConstantClass.repNumResponse?.repNumUserData?.bio ?? "",
                        style: textDesc,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(defaultPadding, 4, 6, 0),
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: kPrimaryColor,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                minimumSize: const Size.fromHeight(50), // NEW
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => PopUp(),
                                );
                              },
                              child: const Text(
                                "Call",
                                style: textBtn,
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 4, defaultPadding, 0),
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: kPrimaryColor,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                minimumSize: const Size.fromHeight(50), // NEW
                              ),
                              onPressed: () {
                                _textMe();
                              },
                              child: const Text(
                                "Text",
                                style: textBtn,
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(defaultPadding, 4, defaultPadding, 10),
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,

                              shadowColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              minimumSize: const Size.fromHeight(40), // NEW
                            ),
                            onPressed: () {
                              _getContactPermission();
                            },
                            child: Text(
                              "Share".toUpperCase(),
                              style: textBtn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
              // SizedBox(height: fullWidth * .03,),
              // const Text("John Brown",style: textProfileName,
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      ConstantClass.selectedContactList.clear();
      Navigator.pushNamed(context, ShareScreen.routeName);
      return permissionStatus;
    } else {
      ConstantClass.selectedContactList.clear();
      Navigator.pushNamed(context, ShareScreen.routeName);
      return permission;
    }
  }

  _textMe() async {
    if (Platform.isAndroid) {
      // String uri = 'sms:${ConstantClass.repNumResponse!.repNumUserData!.mobile!.toString()}?body=Rep: ${ConstantClass.repNumResponse!.repNumUserData!.repNumber!.toString()} \nMeeting: ${ConstantClass.meetingNumber}';
      String uri = 'sms:${ConstantClass.repNumResponse!.repNumUserData!.mobile!.toString()}';
      if (await launchUrl(Uri.parse(uri))) {
        await launchUrl(Uri.parse(uri));
      }
    } else {
      // String uri = 'sms:${ConstantClass.repNumResponse!.repNumUserData!.mobile!.toString()}&body=Rep: ${ConstantClass.repNumResponse!.repNumUserData!.repNumber!.toString()} \nMeeting: ${ConstantClass.meetingNumber}';
      String uri = 'sms:${ConstantClass.repNumResponse!.repNumUserData!.mobile!.toString()}';
      if (await launchUrl(Uri.parse(uri))) {
        await launchUrl(Uri.parse(uri));
      }
    }
  }

// Dialog leadDialog = Dialog(
//   child: Align(
//     alignment: Alignment.bottomCenter,
//     child: Container(
//       height: 300.0,
//       width: 360.0,
//       color: Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(15.0),
//             child: Text(
//               'Choose from Library',
//               style:
//               TextStyle(color: Colors.black, fontSize: 22.0),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// );
}

class PopUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PopUpState();
}

class PopUpState extends State<PopUp> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  Tween<double> opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  Tween<double> marginTopTween = Tween<double>(begin: 300, end: 280);
  late Animation<double> marginTopAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    marginTopAnimation = marginTopTween.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityTween.animate(controller),
      child: Material(
        color: Colors.transparent,
        child: Column(
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
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: () async {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: ConstantClass.repNumResponse!.repNumUserData!.mobile!.toString(),
                      );
                      if (await launchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      } else {
                        throw 'Could not launch ${Uri.parse("tel://987-987-4562")}';
                      }
                    },
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(height: 24, width: 24, child: Image.asset(iconphone)),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          ConstantClass.repNumResponse!.repNumUserData!.mobile!,
                          style: textBtnBlue,
                        ),
                      ],
                    )),
              ),
            ),
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
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pushNamed(
                    //     context, ThirdScheduleScreen.routeName);
                  },
                  child: Text(
                    "Cancel".toUpperCase(),
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
        // Container(
        //   margin: EdgeInsets.only(
        //     top: marginTopAnimation.value,
        //     left:20.0,
        //     right:20.0,
        //   ),
        //   color: Colors.red,
        //   child: Text("Container"),
        // ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
