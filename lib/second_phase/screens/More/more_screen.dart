import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarex/first_phase/FirstHomeScreen/firstHomeScreen.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/teambuilder_first_screen.dart';
import 'package:solarex/second_phase/screens/More/device_contact_screen.dart';
import 'package:solarex/second_phase/screens/More/support_screen.dart';
import 'package:solarex/second_phase/screens/More/task_screen.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/constants.dart';

import '../../models/selectedTeamMemberModel.dart';
import 'profile_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    // _checkPermission().then((value) {
    //   if (value.isGranted) {
    //     checkContacts();
    //   } else if (value.isPermanentlyDenied) {
    //     showDialog(
    //         context: context,
    //         builder: (BuildContext context) => CupertinoAlertDialog(
    //               title: const Text("Contact Permission"),
    //               content: const Text("This app requires Contacts access to send message directly and Add to Team Member"),
    //               actions: <Widget>[
    //                 CupertinoDialogAction(
    //                   child: const Text("Deny"),
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                 ),
    //                 CupertinoDialogAction(
    //                   child: const Text("Open Settings"),
    //                   onPressed: () => openAppSettings(),
    //                 ),
    //               ],
    //             ));
    //   }
    // });
  }

  Future<void> checkContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(conTectUploadKey) ?? true == true) {
      getAllContects(userId).then((value) {
        if (value.isNotEmpty) {
          authController.sendContectToServer(userId: userId, contectData: jsonEncode(value)).then((value) {
            prefs.setBool(conTectUploadKey, false);
          });
        } else {
          prefs.setBool(conTectUploadKey, true);
        }
      });
    }
  }

  Future<List<SelectedContactMember>> getAllContects(String userId) async {
    List<SelectedContactMember> dummySearchList = <SelectedContactMember>[];
    var contacts = (await ContactsService.getContacts(withThumbnails: false));
    // setState(() {
    for (var item in contacts) {
      var mobilenum = (item.phones ?? []).toList();
      dummySearchList.add(SelectedContactMember(firstName: item.displayName, lastName: item.familyName, mobile: mobilenum[0].value.toString()));
    }
    return dummySearchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          // margin: EdgeInsets.all(14),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "More",
                      style: textHeading,
                    ),
                  )),
              _createListitem(
                  text: 'Profiles',
                  isAssetsIcon: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProfileScreen();
                        },
                      ),
                    );
                    // setState(() {
                    //   pushNewScreen(
                    //     context,
                    //     withNavBar: false,
                    //     screen: MainHomeScreen(
                    //       menuScreenContext: context,
                    //       pageIndex: 2,
                    //     ),
                    //   );
                    // });
                  },
                  iconName: "ic_home.png"),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              _createListitem(
                  isAssetsIcon: false,
                  text: 'Device Contacts',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const DeviceContactScreen();
                        },
                      ),
                    );
                  },
                  icondata: Icons.import_contacts),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              _createListitem(
                  isAssetsIcon: false,
                  icondata: Icons.group,
                  text: 'Team Builder',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const TeamBuilderfristScreen();
                        },
                      ),
                    );
                  },
                  iconName: "ic_home.png"),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              _createListitem(
                  isAssetsIcon: false,
                  icondata: Icons.work_outline,
                  text: 'Tasks',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AllTaskScreen();
                        },
                      ),
                    );
                  },
                  iconName: "ic_home.png"),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              _createListitem(isAssetsIcon: false, icondata: Icons.settings, text: 'Settings', onTap: () {}, iconName: "ic_home.png"),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              _createListitem(
                  isAssetsIcon: false, icondata: Icons.video_collection_rounded, text: 'Tutorials', onTap: () {}, iconName: "ic_home.png"),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              _createListitem(
                  isAssetsIcon: false, icondata: Icons.report_gmailerrorred_rounded, text: 'Version', onTap: () {}, iconName: "ic_home.png"),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              _createListitem(
                  isAssetsIcon: false,
                  icondata: Icons.contact_support,
                  text: 'Support',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return const SupportScreen();
                    //     },
                    //   ),
                    // );
                  },
                  iconName: "ic_home.png"),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              _createListitem(
                  isAssetsIcon: false,
                  icondata: Icons.logout,
                  text: 'Log Out',
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool(logInKey, true);
                    prefs.setString(userIdKey, '');
                    authController.hideNav.value = true;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstHomeScreen()));
                  },
                  iconName: "ic_home.png"),
            ],
          ),
        ),
      ),
    );
  }

  Future<PermissionStatus> _checkPermission() async {
    const Permission permission = Permission.contacts;
    final status = await permission.request();
    return status;
  }

  Widget _createListitem({required String text, GestureTapCallback? onTap, String? iconName, var isAssetsIcon = false, IconData? icondata}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          SizedBox(
            height: 50,
            // width: Constants.fullWidth(context) * 0.100,
            child: ClipRRect(
                // borderRadius: BorderRadius.all(Radius.circular(200)),
                borderRadius: BorderRadius.circular(8.0),
                child: CircleAvatar(
                  // radius: Constants.fullWidth(context) * 0.12,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: isAssetsIcon
                        ? Image.asset(
                            'assets/icons/${iconName!}',
                            color: Colors.black,
                            height: 18,
                            width: 18,
                          )
                        : Icon(icondata, color: Colors.black),
                  ),
                )),
          ),

          // Image.asset(
          //   getAssetsImage(iconName!),color: colorAppMain,
          //   height: 18,
          //   width: 18,
          // ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                text,
                // style: kText18SemiBoldDrawerText,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right, color: Colors.black),
        ],
      ),
      onTap: onTap,
    );
  }

//   Future<void> checkStatus() async {
//     var status = await Permission.contacts.request();
//     Fluttertoast.showToast(msg: "PERMISSION=== $status");
//     if (status.isPermanentlyDenied) {
//       // We didn't ask for permission yet.
//       // showDialog(
//       //     context: context,
//       //     builder: (BuildContext context) => CupertinoAlertDialog(
//       //           title: Text("PERMIGSS"),
//       //           content: Text("Dd"),
//       //           actions: <Widget>[
//       //             CupertinoDialogAction(
//       //               child: Text("Deny"),
//       //               onPressed: () => Navigator.of(context).pop(),
//       //             ),
//       //             CupertinoDialogAction(
//       //               child: Text("AppLocalizations.of(context).common_settings"),
//       //               onPressed: () => openAppSettings(),
//       //             ),
//       //           ],
//       //         ));
//     } else if (status.isRestricted) {
//       Fluttertoast.showToast(msg: "PERMISSION isRestricted");
//       // ToastComponent.showDialog(
//       //     AppLocalizations.of(context).common_give_photo_permission,
//       //     gravity: Toast.center,
//       //     duration: Toast.lengthLong);
//     }
// // You can can also directly ask the permission about its status.
// //     if (await Permission.contacts.isRestricted) {
// //       // The OS restricts access, for example because of parental controls.
// //     }
// //     if (await Permission.contacts.isPermanentlyDenied) {
// //       Fluttertoast.showToast(msg: "PERMISSION DENIED");
// //       // The user opted to never again see the permission request dialog for this
// //       // app. The only way to change the permission's status now is to let the
// //       // user manually enable it in the system settings.
// //       openAppSettings();
// //     }
// //     if (await Permission.contacts.request().isGranted) {
// //       Fluttertoast.showToast(msg: "PERMISSION isGranted");
// //       // Either the permission was already granted before or the user just granted it.
// //     }
// //     if (await Permission.contacts.request().isRestricted) {
// //       Fluttertoast.showToast(msg: "PERMISSION isRestricted");
// //       // Either the permission was already granted before or the user just granted it.
// //     }
// //     if (await Permission.contacts.request().isDenied) {
// //       Fluttertoast.showToast(msg: "PERMISSION isDenied");
// //       // Either the permission was already granted before or the user just granted it.
// //     }
//   }
}
