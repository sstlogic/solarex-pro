import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solarex/first_phase/screenUI/shareScreen/component/body_old.dart';
import 'package:solarex/second_phase/controllers/prospective_controllers.dart';
import 'package:solarex/second_phase/models/contectSelectModel.dart';
import 'package:solarex/second_phase/models/selectedTeamMemberModel.dart';
import 'package:solarex/utils/loading_spinner.dart';

import '../../../theme/style.dart';
import '../../../utils/colors_app.dart';
import '../../../utils/constants.dart';

class DeviceContactScreen extends StatefulWidget {
  const DeviceContactScreen({Key? key}) : super(key: key);

  @override
  State<DeviceContactScreen> createState() => _DeviceContactScreenState();
}

class _DeviceContactScreenState extends State<DeviceContactScreen> {
  final _debouncer = Debouncer();
  List<Contact> duplicateItems = [];
  List<Contact> originalitems = [];

  List<contectSelectModel> duplicateItem = [];
  List<contectSelectModel> originalitem = <contectSelectModel>[];
  List<bool>? isChecked;
  int contactNo = 0;
  var isAddtoPerspect = false;

  var clickCounter = 0;
  var ageNotSelected = true;
  final prospectiveController = Get.put(ProspectiveController());

  @override
  void initState() {
    super.initState();
    // refreshContacts();
    // _checkPermission().then(
    //   (hasGranted) {
    //     print("object STATUS===$hasGranted");
    //     if (hasGranted == PermissionStatus.granted) {
    //       refreshContacts();
    //     } else if (hasGranted == PermissionStatus.permanentlyDenied) {
    //       // openAppSettings();
    //       // Fluttertoast.showToast(msg: "Contact Permission is Denied");
    //     }
    //   },
    // );
    _checkPermission().then((value) {
      if (value.isGranted) {
        refreshContacts();
      } else if (value.isPermanentlyDenied) {
        showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text("Contact Permission"),
                  content: const Text("This app requires Contacts access to send message directly and Add to Team Member"),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: const Text("Deny"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoDialogAction(
                      child: const Text("Open Settings"),
                      onPressed: () => openAppSettings(),
                    ),
                  ],
                ));
      }
    });
  }

  Future<PermissionStatus> _checkPermission() async {
    const Permission permission = Permission.contacts;
    final status = await permission.request();
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: false,
          title: const Text(
            "Device Contacts",
            style: textHeading,
          ),
        ),
        body: SafeArea(
          child: Container(
            width: ConstantClass.fullWidth(context),
            height: ConstantClass.fullHeight(context),
            margin: EdgeInsets.only(bottom: 50.h),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    onChanged: (string) {
                      _debouncer.run(
                        () {
                          filterSearchResults(string);
                        },
                      );
                      // _waits(true);
                      // filterSearchResults(value);
                    },
                    style: textStrBtn,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryDarkColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryDarkColor),
                      ),
                      fillColor: kPrimaryDarkColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryDarkColor),
                      ),
                      hintText: "Search",
                      hintStyle: textStrBtn,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SizedBox(
                    child: duplicateItem.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: LoadingSpinner(),
                            ))
                        : Obx(
                            () => prospectiveController.loading.isTrue
                                ? const Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: LoadingSpinner(),
                                    ))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: originalitem.length,
                                    itemBuilder: (context, index) {
                                      String name = originalitem[index].name != null ? (originalitem[index].name!) : "Not available";

                                      return Column(
                                        children: [
                                          Container(
                                            width: ConstantClass.fullWidth(context),
                                            // height: ConstantClass.fullHeight(context),
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            padding: const EdgeInsets.all(10),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFeeeeee),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.person,
                                                  color: kPrimaryDarkColor,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    width: ConstantClass.fullWidth(context) * 0.80,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          name,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          originalitem[index].numbar,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.grey,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                !originalitem[index].isCheck == true
                                                    ? Align(
                                                        alignment: Alignment.centerRight,
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 25,
                                                          child: MaterialButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                prospectiveController.addProspective(
                                                                    id: userId, mobile: originalitem[index].numbar, name: originalitem[index].name);
                                                                originalitem[index].isCheck = true;
                                                              });
                                                            },
                                                            color: kPrimaryColor,
                                                            textColor: Colors.white,
                                                            child: const Icon(
                                                              Icons.add,
                                                              size: 14,
                                                            ),
                                                            // padding: EdgeInsets.all(6),
                                                            shape: const CircleBorder(),
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                                // SizedBox(
                                                //         height: 25,
                                                //         child: Row(
                                                //           // crossAxisAlignment:
                                                //           //     CrossAxisAlignment.center,
                                                //           // mainAxisAlignment:
                                                //           //     MainAxisAlignment.spaceAround,
                                                //           children: [
                                                //             Row(children: [
                                                //               Image.asset(
                                                //                 'assets/icons/ic_ring.png',
                                                //                 // color: Colors.black,
                                                //                 height: 20,
                                                //                 width: 20,
                                                //               ),
                                                //               SizedBox(
                                                //                 height: 20,
                                                //                 width: 20,
                                                //                 child: Checkbox(
                                                //                     value:
                                                //                         originalitem[index]
                                                //                             .isMarried,
                                                //                     onChanged: (value) {
                                                //                       setState(() {
                                                //                         originalitem[index]
                                                //                                 .isMarried =
                                                //                             value!;
                                                //                         if (originalitem[
                                                //                                     index]
                                                //                                 .isMarried ==
                                                //                             true) {
                                                //                         } else {}
                                                //                       });
                                                //                     }),
                                                //               )
                                                //             ]),
                                                //             const SizedBox(
                                                //               width: 10,
                                                //             ),
                                                //             Row(children: [
                                                //               // ic_ring
                                                //               Image.asset(
                                                //                 'assets/icons/ic_house.png',
                                                //                 // color: Colors.black,
                                                //                 height: 20,
                                                //                 width: 20,
                                                //               ),
                                                //               SizedBox(
                                                //                 height: 20,
                                                //                 width: 20,
                                                //                 child: Checkbox(
                                                //                     value:
                                                //                         originalitem[index]
                                                //                             .isHomeOwner,
                                                //                     onChanged: (value) {
                                                //                       setState(() {
                                                //                         originalitem[index]
                                                //                                 .isHomeOwner =
                                                //                             value!;
                                                //                         if (originalitem[
                                                //                                     index]
                                                //                                 .isHomeOwner ==
                                                //                             true) {
                                                //                         } else {}
                                                //                       });
                                                //                     }),
                                                //               )
                                                //             ]),
                                                //             const SizedBox(
                                                //               width: 10,
                                                //             ),
                                                //             SizedBox(
                                                //               // width: 80,
                                                //               // height: 25,
                                                //               child: Row(children: [
                                                //                 // ic_ring
                                                //                 ElevatedButton(
                                                //                     style: ElevatedButton
                                                //                         .styleFrom(
                                                //                       backgroundColor:
                                                //                           kPrimaryColor,
                                                //                       shape:
                                                //                           RoundedRectangleBorder(
                                                //                         borderRadius:
                                                //                             BorderRadius
                                                //                                 .circular(
                                                //                                     20),
                                                //                       ),
                                                //                     ),
                                                //                     onPressed: () async {
                                                //                       setState(() {
                                                //                         if (clickCounter ==
                                                //                             0) {
                                                //                           originalitem[
                                                //                                       index]
                                                //                                   .age =
                                                //                               "30-64";
                                                //                           clickCounter++;
                                                //                         } else if (clickCounter ==
                                                //                             1) {
                                                //                           originalitem[
                                                //                                   index]
                                                //                               .age = "65+";
                                                //                           clickCounter++;
                                                //                         } else if (clickCounter ==
                                                //                             2) {
                                                //                           clickCounter++;
                                                //                           originalitem[
                                                //                                   index]
                                                //                               .age = "29-";
                                                //                         } else if (clickCounter ==
                                                //                             3) {
                                                //                           originalitem[
                                                //                                   index]
                                                //                               .age = '';
                                                //                           clickCounter = 0;
                                                //                         }
                                                //                       });
                                                //                     },
                                                //                     child: Row(
                                                //                       children: [
                                                //                         originalitem[index]
                                                //                                     .age ==
                                                //                                 ''
                                                //                             ? Image.asset(
                                                //                                 'assets/icons/ic_hourglass.png',
                                                //                                 // color: Colors.black,
                                                //                                 height: 18,
                                                //                                 width: 18,
                                                //                               )
                                                //                             : const SizedBox(),
                                                //                         Text(
                                                //                           originalitem[index]
                                                //                                       .age ==
                                                //                                   ''
                                                //                               ? "?"
                                                //                               : originalitem[
                                                //                                       index]
                                                //                                   .age
                                                //                                   .toUpperCase(),
                                                //                           style:
                                                //                               text14White,
                                                //                         ),
                                                //                       ],
                                                //                     )),
                                                //                 // Image.asset(
                                                //                 //   'assets/icons/ic_house.png',
                                                //                 //   // color: Colors.black,
                                                //                 //   height: 20,
                                                //                 //   width: 20,
                                                //                 // ),
                                                //                 // SizedBox(
                                                //                 //   height: 20,
                                                //                 //   width: 20,
                                                //                 //   child: Checkbox(
                                                //                 //       value:
                                                //                 //           originalitem[index]
                                                //                 //               .isCheck,
                                                //                 //       onChanged: (value) {
                                                //                 //         setState(() {
                                                //                 //           originalitem[index]
                                                //                 //                   .isCheck =
                                                //                 //               value!;
                                                //                 //           if (originalitem[
                                                //                 //                       index]
                                                //                 //                   .isCheck ==
                                                //                 //               true) {
                                                //                 //           } else {}
                                                //                 //         });
                                                //                 //       }),
                                                //                 // )
                                                //               ]),
                                                //             ),
                                                //           ],
                                                //         ),
                                                //       ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            width: ConstantClass.fullWidth(context),
                                            height: 2,
                                            color: const Color(0xFFdedede),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget customLightText(var text) {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget customDarkText(var text) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget itemList(Contact contact, index) {
    // String num = contact.phones != null ? (contact.phones!.first.value!) : "contact not available";
    String name = contact.displayName != null ? (contact.displayName!) : "Not available";
    var mobilenum = contact.phones!.toList();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFeeeeee),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.person,
                color: kPrimaryDarkColor,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    mobilenum.isNotEmpty ? mobilenum[0].value.toString() : "Not available",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: ConstantClass.fullWidth(context),
          height: 2,
          color: const Color(0xFFdedede),
        )
      ],
    );
  }

  Future<void> refreshContacts() async {
    duplicateItems = [];
    originalitems = [];
    List<SelectedContactMember> dummySearchList = <SelectedContactMember>[];

    var contacts = (await ContactsService.getContacts(withThumbnails: false));
    setState(() {
      duplicateItems = contacts;
      originalitems.addAll(duplicateItems);
      isChecked = List.generate(duplicateItems.length, (index) => false);
      addData();

      for (var item in originalitems) {
        var mobilenum = (item.phones ?? []).toList();
        dummySearchList.add(SelectedContactMember(
            firstName: item.displayName, lastName: item.familyName, mobile: mobilenum.isNotEmpty ? mobilenum[0].value.toString() : "Not Available"));
      }
    });
  }

  // Future<String?> _getId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //   } else if (Platform.isAndroid) {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.id; // unique ID on Android
  //   }
  // }

  addData() async {
    for (int i = 0; i < duplicateItems.length; i++) {
      var mobilenum = duplicateItems[i].phones!.toList();
      duplicateItem.add(contectSelectModel(duplicateItems[i].displayName != null ? (duplicateItems[i].displayName!) : "Not available",
          mobilenum.isNotEmpty ? mobilenum[0].value.toString() : "Not available", false, false, false, false, false, ''));
    }
    originalitem.addAll(duplicateItem);
    prospectiveController.getProspectiveList(userId: userId).then((value) {
      for (var item in (prospectiveController.prospectiveListModel.value.prospectiveContectList ?? [])) {
        var alreadyAddContectsId = originalitem.indexWhere((prod) => prod.name == item.name);
        if (alreadyAddContectsId != -1) {
          originalitem[alreadyAddContectsId].isCheck = true;
        }
      }
      setState(() {});
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      List<contectSelectModel> dummySearchList = <contectSelectModel>[];
      dummySearchList.addAll(duplicateItem);
      print("duplicated items length ${duplicateItem.length.toString()}");
      if (query.isNotEmpty) {
        List<contectSelectModel> dummyListData = <contectSelectModel>[];
        dummySearchList.forEach((item) {
          if (item.name!.toLowerCase().contains(query.toLowerCase())) {
            dummyListData.add(item);
          }
        });

        originalitem.clear();
        originalitem.addAll(dummyListData);

        return;
      } else {
        print("duplicated items length ${duplicateItem.length.toString()}");
        originalitem.clear();
        originalitem.addAll(duplicateItem);
      }
    });
  }
}
