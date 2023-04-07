import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solarex/second_phase/controllers/profile_controllers.dart';
import 'package:solarex/second_phase/models/selectedTeamMemberModel.dart';
import 'package:solarex/second_phase/models/teamFriendListModel.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/teambuilder_three_screen.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/loading_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Second_Phase/Screens/More/more_screen.dart';
import '../../../../first_phase/screenUI/shareScreen/component/body.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/style.dart';
import '../../../controllers/auth_controllers.dart';

class TeamBuilderSecondScreen extends StatefulWidget {
  const TeamBuilderSecondScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TeamBuilderSecondScreen> createState() => _TeamBuilderSecondScreenState();
}

class _TeamBuilderSecondScreenState extends State<TeamBuilderSecondScreen> {
  List<Contact> duplicateItems = [];
  List<Contact> originalitems = [];

  List<SelectedContactMember> duplicateItem = [];
  List<SelectedContactMember> originalitem = <SelectedContactMember>[];

  //----SUbmitted----
  List<TeamFriendsItem> duplicateTeamMemberItems = [];
  List<TeamFriendsItem> originalTeamMemberitems = [];
  List<TeamFriendsItem> duplicateTeamMemberItem = [];
  List<TeamFriendsItem> originalTeamMemberitem = <TeamFriendsItem>[];

  List<bool>? ismemberChecked;
  List<bool>? isChecked;
  int contactNo = 0;
  final _debouncer = Debouncer();
  final authController = Get.put(AuthController());
  final profileController = Get.put(ProfileController());
  var selectedAll = false;
  var notSubmitedCount = 0;
  var onFilterClick = false;
  var onSubmittedClick = false;

  Future<PermissionStatus> _checkPermission() async {
    const Permission permission = Permission.contacts;
    final status = await permission.request();
    return status;
  }

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
    //                   onPressed: () => Navigator.of(context).pop(),
    //                 ),
    //                 CupertinoDialogAction(
    //                   child: const Text("Open Settings"),
    //                   onPressed: () => openAppSettings(),
    //                 ),
    //               ],
    //             ));
    //   }
    // });
    profileController.selectedTeamMemberList.value.clear();
    getNotSubmitedList();
  }

  // Future<void> checkContacts() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool(conTectUploadKey) ?? true == true) {
  //     getAllContects(userId).then((value) {
  //       if (value.isNotEmpty) {
  //         authController.sendContectToServer(userId: userId, contectData: jsonEncode(value)).then((value) {
  //           prefs.setBool(conTectUploadKey, false);
  //         });
  //       } else {
  //         prefs.setBool(conTectUploadKey, true);
  //       }
  //     });
  //   }
  // }

  // Future<List<SelectedContactMember>> getAllContects(String userId) async {
  //   List<SelectedContactMember> dummySearchList = <SelectedContactMember>[];
  //   var contacts = (await ContactsService.getContacts(withThumbnails: false));
  //   // setState(() {
  //   for (var item in contacts) {
  //     var mobilenum = (item.phones ?? []).toList();
  //     dummySearchList.add(SelectedContactMember(firstName: item.displayName, lastName: item.familyName, mobile: mobilenum[0].value.toString()));
  //   }
  //   return dummySearchList;
  // }

  addData() async {
    for (int i = 0; i < duplicateItems.length; i++) {
      var mobilenum = (duplicateItems[i].phones ?? []).toList();
      duplicateItem.add(SelectedContactMember(
          firstName: duplicateItems[i].displayName != null ? (duplicateItems[i].displayName!) : "Not available",
          lastName: duplicateItems[i].givenName != null ? (duplicateItems[i].givenName!) : "Not available",
          mobile: mobilenum.isNotEmpty ? mobilenum[0].value : "Not available",
          email: "",
          referredBy: "",
          isCheck: true));
    }
    originalitem.addAll(duplicateItem);
    profileController.selectedTeamMemberList.value.clear();
    for (var item in originalitem) {
      selectedAll = true;
      item.isCheck = true;
      profileController.selectedTeamMemberList.value.add(item);
    }
  }

  // Future<void> getNotSubmitedList() async {
  //   var contacts = (await ContactsService.getContacts(withThumbnails: false));
  //   // profileController.getNotSubmitedTeamMemberList().then((value) {
  //   //   setState(() {
  //   duplicateItems = [];
  //   originalitems = [];
  //   duplicateItem = [];
  //   originalitem = [];
  //
  //   duplicateItems = contacts;
  //   originalitems.addAll(duplicateItems);
  //   isChecked = List.generate(duplicateItems.length, (index) => false);
  //   addData();
  //   // });
  //   // });
  // }
  Future<void> getNotSubmitedList() async {
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

  void filterSearchResults1(String query) {
    setState(() {
      List<TeamFriendsItem> dummySearchList = <TeamFriendsItem>[];
      dummySearchList.addAll(duplicateTeamMemberItem);

      if (query.isNotEmpty) {
        List<TeamFriendsItem> dummyListData = <TeamFriendsItem>[];
        dummySearchList.forEach((item) {
          if (item.firstName!.toLowerCase().contains(query.toLowerCase()) || item.lastName!.toLowerCase().contains(query.toLowerCase())) {
            dummyListData.add(item);
          }
        });

        originalTeamMemberitem.clear();
        originalTeamMemberitem.addAll(dummyListData);

        return;
      } else {
        originalTeamMemberitem.clear();
        originalTeamMemberitem.addAll(duplicateTeamMemberItem);
      }
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      List<SelectedContactMember> dummySearchList = <SelectedContactMember>[];
      dummySearchList.addAll(duplicateItem);
      if (query.isNotEmpty) {
        List<SelectedContactMember> dummyListData = <SelectedContactMember>[];
        dummySearchList.forEach((item) {
          if (item.firstName!.toLowerCase().contains(query.toLowerCase()) || item.lastName!.toLowerCase().contains(query.toLowerCase())) {
            dummyListData.add(item);
          }
        });

        originalitem.clear();
        originalitem.addAll(dummyListData);

        return;
      } else {
        originalitem.clear();
        originalitem.addAll(duplicateItem);
      }
    });
  }

  addListData() async {
    for (int i = 0; i < duplicateTeamMemberItems.length; i++) {
      duplicateTeamMemberItem.add(TeamFriendsItem(
          memberId: duplicateTeamMemberItems[i].memberId,
          firstName: duplicateTeamMemberItems[i].firstName,
          lastName: duplicateTeamMemberItems[i].lastName,
          mobileNumber: duplicateTeamMemberItems[i].mobileNumber,
          referredBy: duplicateTeamMemberItems[i].referredBy));
    }
    originalTeamMemberitem.addAll(duplicateTeamMemberItem);
  }

  Future<void> refreshList() async {
    profileController.getSubmittedFriendList().then((value) {
      setState(() {
        originalTeamMemberitems = [];
        duplicateTeamMemberItems = [];
        originalTeamMemberitem = [];
        duplicateTeamMemberItem = [];
        duplicateTeamMemberItems = profileController.teamFriendListModel.value.teamFriendsList ?? [];
        originalTeamMemberitems.addAll(duplicateTeamMemberItems);
        ismemberChecked = List.generate(duplicateTeamMemberItems.length, (index) => false);
        addListData();
      });
    });
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
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return const MoreScreen();
              },
            ), (route) => false);
          },
        ),
        centerTitle: false,
        title: const Text(
          "Friends",
          style: textHeading,
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 40.h),
          height: ConstantClass.fullHeight(context),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(left: 14, right: 14),
                decoration: const BoxDecoration(color: kPrimaryDarkColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  children: [
                    Expanded(
                        // width: 300,
                        // margin: const EdgeInsets.only(left: 14, right: 14),
                        child: TextField(
                      onChanged: (string) {
                        _debouncer.run(
                          () {
                            // onSubmittedClick
                            if (onSubmittedClick) {
                              filterSearchResults1(string);
                            } else {
                              filterSearchResults(string);
                            }
                          },
                        );
                        // _waits(true);
                        // filterSearchResults(value);
                      },
                      style: textStrBtn,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryDarkColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryDarkColor),
                        ),
                        fillColor: kPrimaryDarkColor,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryDarkColor),
                        ),
                        hintText: onSubmittedClick
                            ? "Submitted (${(profileController.teamFriendListModel.value.teamFriendsList ?? []).length})"
                            : "Not Submitted (${originalitem.length - profileController.selectedTeamMemberList.value.length})",
                        hintStyle: textStrBtn,
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          onFilterClick = !onFilterClick;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        padding: const EdgeInsets.all(4),
                        decoration: onFilterClick
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ))
                            : const BoxDecoration(),
                        child: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              !onFilterClick
                  ? !onSubmittedClick
                      ? Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  // margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Uncheck any remaining prospects/businesses!",
                                    textAlign: TextAlign.start,
                                    style: text14grey.merge(const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              duplicateItem.isEmpty
                                  ? Container()
                                  : Container(
                                      margin: EdgeInsets.symmetric(horizontal: 12.w),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                textStyle: const TextStyle(color: Colors.white),
                                              ),
                                              onPressed: () {
                                                if (selectedAll) {
                                                  for (var item in originalitem) {
                                                    selectedAll = false;
                                                    item.isCheck = false;
                                                    profileController.selectedTeamMemberList.value.remove(item);
                                                  }
                                                } else {
                                                  profileController.selectedTeamMemberList.value.clear();
                                                  for (var item in originalitem) {
                                                    selectedAll = true;
                                                    item.isCheck = true;
                                                    profileController.selectedTeamMemberList.value.add(item);
                                                  }
                                                }
                                                print(profileController.selectedTeamMemberList.value.length);
                                                setState(() {});
                                              },
                                              child: Text(selectedAll ? 'unselect all'.toUpperCase() : 'Select all'.toUpperCase(), style: textStrBtn),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text('${profileController.selectedTeamMemberList.value.length} Friends Selected'.toUpperCase(),
                                              style: textBtnBlue.merge(const TextStyle(fontSize: 13)))
                                        ],
                                      )),
                            ],
                          ),
                        )
                      : Container()
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              onSubmittedClick = false;
                              onFilterClick = false;
                              // getNotSubmitedList();
                            });
                          },
                          child: Container(
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Row(
                              children: const [
                                Text(
                                  "Not Submitted",
                                  style: textBtnBlue,
                                ),
                                // const Spacer(),
                                // Container(
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 10, vertical: 2),
                                //     decoration: BoxDecoration(
                                //       color: kPrimaryColor,
                                //       borderRadius: BorderRadius.circular(100),
                                //       border: Border.all(color: kPrimaryColor),
                                //     ),
                                //     child: Text("0",
                                //         style: textBtnBlue.merge(
                                //             const TextStyle(
                                //                 color: Colors.white)))),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              onSubmittedClick = true;
                              onFilterClick = false;
                              refreshList();
                            });
                          },
                          child: Container(
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Row(
                              children: const [
                                Text(
                                  "Submitted",
                                  style: textBtnBlue,
                                ),
                                // const Spacer(),
                                // Container(
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 10, vertical: 2),
                                //     decoration: BoxDecoration(
                                //       color: kPrimaryColor,
                                //       borderRadius: BorderRadius.circular(100),
                                //       border: Border.all(color: kPrimaryColor),
                                //     ),
                                //     child: Text("0",
                                //         style: textBtnBlue.merge(
                                //             const TextStyle(
                                //                 color: Colors.white)))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              // onSubmittedClick

              onSubmittedClick
                  ? Obx(
                      () => profileController.loadinggetFriendsList.isTrue
                          ? const Expanded(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: LoadingSpinner(),
                                  )),
                            )
                          : Container(
                              child: profileController.loadinggetFriendsList.isTrue
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                      color: kPrimaryDarkColor,
                                    ))
                                  : duplicateTeamMemberItem.isEmpty
                                      ? const Expanded(
                                          child: Center(
                                              child: Text(
                                            'List is Empty',
                                            style: text18Black,
                                          )),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: originalTeamMemberitem.length,
                                            itemBuilder: (context, index) {
                                              String name = originalTeamMemberitem[index].firstName != null
                                                  ? (originalTeamMemberitem[index].firstName!)
                                                  : "Not available";

                                              return GestureDetector(
                                                onTap: () {
                                                  // showEditNameDialog(
                                                  //     originalTeamMemberitem[index].firstName ?? "",
                                                  //     originalTeamMemberitem[index].lastName ?? "",
                                                  //     originalTeamMemberitem[index].referredBy ?? "",
                                                  //     originalTeamMemberitem[index].memberId ?? "0");
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 14, right: 14),
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xFFeeeeee),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          // SizedBox(
                                                          //   height: 25,
                                                          //   child: Checkbox(
                                                          //       value: originalitem[index].isCheck,
                                                          //       onChanged: (value) {
                                                          //         setState(() {
                                                          //           originalitem[index].isCheck =
                                                          //           value!;
                                                          //           if (originalitem[index].isCheck ==
                                                          //               true) {
                                                          //             contactNo++;
                                                          //             profileController
                                                          //                 .selectedTeamMemberList
                                                          //                 .value
                                                          //                 .add(originalitem[index]);
                                                          //           } else {
                                                          //             contactNo--;
                                                          //             profileController
                                                          //                 .selectedTeamMemberList
                                                          //                 .value
                                                          //                 .remove(
                                                          //                 originalitem[index]);
                                                          //           }
                                                          //         });
                                                          //       }),
                                                          // ),

                                                          const Icon(
                                                            Icons.person,
                                                            color: kPrimaryDarkColor,
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),

                                                          SizedBox(
                                                            width: ConstantClass.fullWidth(context) * 0.60,
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
                                                                (originalTeamMemberitem[index].mobileNumber ?? "").isEmpty
                                                                    ? SizedBox()
                                                                    : Text(
                                                                        originalTeamMemberitem[index].mobileNumber ?? "",
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

                                                          // const Spacer(),
                                                          // const Icon(
                                                          //   Icons.chevron_right,
                                                          //   color: kPrimaryDarkColor,
                                                          // ),
                                                          // contacts.isCheck
                                                          //     ?

                                                          //     :
                                                          // Container(
                                                          //   margin: EdgeInsets.only(right: 10),
                                                          //   child: Text(
                                                          //     "introduce".toUpperCase(),
                                                          //     style:textBtnLiteBlue,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 14, right: 14),
                                                      width: ConstantClass.fullWidth(context),
                                                      height: 2,
                                                      color: const Color(0xFFdedede),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                            ),
                    )
                  :
                  //    loadingSubmitMemberList
                  Obx(
                      () => profileController.loadingSubmitMemberList.isTrue
                          ? const Expanded(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: LoadingSpinner(),
                                  )),
                            )
                          : Container(
                              child: duplicateItem.isEmpty
                                  ? const Expanded(
                                      child: Center(
                                          child: Text(
                                        'List is Empty',
                                        style: text18Black,
                                      )),
                                    )
                                  :
                                  // duplicateItem.isEmpty
                                  //     ? const Center(
                                  //         child: CircularProgressIndicator(
                                  //         color: kPrimaryDarkColor,
                                  //       ))
                                  //     :
                                  Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: originalitem.length,
                                        itemBuilder: (context, index) {
                                          String name = originalitem[index].firstName != null ? (originalitem[index].firstName!) : "Not available";

                                          return Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFeeeeee),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 25,
                                                      child: Checkbox(
                                                          value: originalitem[index].isCheck,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              originalitem[index].isCheck = value!;
                                                              if (originalitem[index].isCheck == true) {
                                                                contactNo++;
                                                                profileController.selectedTeamMemberList.value.add(originalitem[index]);
                                                              } else {
                                                                contactNo--;
                                                                profileController.selectedTeamMemberList.value.remove(originalitem[index]);
                                                              }
                                                            });
                                                          }),
                                                    ),
                                                    // const Icon(
                                                    //   Icons.person,
                                                    //   color: kPrimaryDarkColor,
                                                    // ),

                                                    SizedBox(
                                                      width: 6.w,
                                                    ),

                                                    SizedBox(
                                                      width: ConstantClass.fullWidth(context) * 0.60,
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
                                                            originalitem[index].mobile ?? "",
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

                                                    const Spacer(),

                                                    // contacts.isCheck
                                                    //     ?

                                                    //     :
                                                    // Container(
                                                    //   margin: EdgeInsets.only(right: 10),
                                                    //   child: Text(
                                                    //     "introduce".toUpperCase(),
                                                    //     style:textBtnLiteBlue,
                                                    //   ),
                                                    // ),
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
                    ),
              // Container(
              //     child: duplicateItem.isEmpty
              //         ? const Expanded(
              //             child: Center(
              //                 child: Text(
              //               'List is Empty',
              //               style: text18Black,
              //             )),
              //           )
              //         :
              //         // duplicateItem.isEmpty
              //         //     ? const Center(
              //         //         child: CircularProgressIndicator(
              //         //         color: kPrimaryDarkColor,
              //         //       ))
              //         //     :
              //         Expanded(
              //             child: ListView.builder(
              //               shrinkWrap: true,
              //               itemCount: originalitem.length,
              //               itemBuilder: (context, index) {
              //                 String name = originalitem[index].firstName != null ? (originalitem[index].firstName!) : "Not available";
              //
              //                 return Column(
              //                   children: [
              //                     Container(
              //                       padding: const EdgeInsets.all(10),
              //                       decoration: const BoxDecoration(
              //                         color: Color(0xFFeeeeee),
              //                       ),
              //                       child: Row(
              //                         children: [
              //                           SizedBox(
              //                             height: 25,
              //                             child: Checkbox(
              //                                 value: originalitem[index].isCheck,
              //                                 onChanged: (value) {
              //                                   setState(() {
              //                                     originalitem[index].isCheck = value!;
              //                                     if (originalitem[index].isCheck == true) {
              //                                       contactNo++;
              //                                       profileController.selectedTeamMemberList.value.add(originalitem[index]);
              //                                     } else {
              //                                       contactNo--;
              //                                       profileController.selectedTeamMemberList.value.remove(originalitem[index]);
              //                                     }
              //                                   });
              //                                 }),
              //                           ),
              //                           // const Icon(
              //                           //   Icons.person,
              //                           //   color: kPrimaryDarkColor,
              //                           // ),
              //
              //                           SizedBox(
              //                             width: 6.w,
              //                           ),
              //
              //                           SizedBox(
              //                             width: ConstantClass.fullWidth(context) * 0.60,
              //                             child: Column(
              //                               mainAxisAlignment: MainAxisAlignment.start,
              //                               crossAxisAlignment: CrossAxisAlignment.start,
              //                               children: [
              //                                 Text(
              //                                   name,
              //                                   style: const TextStyle(
              //                                     fontWeight: FontWeight.w600,
              //                                     color: Colors.black,
              //                                     overflow: TextOverflow.ellipsis,
              //                                     fontSize: 14.0,
              //                                   ),
              //                                 ),
              //                                 Text(
              //                                   originalitem[index].mobile ?? "",
              //                                   style: const TextStyle(
              //                                     fontWeight: FontWeight.w600,
              //                                     color: Colors.grey,
              //                                     overflow: TextOverflow.ellipsis,
              //                                     fontSize: 12.0,
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //
              //                           const Spacer(),
              //
              //                           // contacts.isCheck
              //                           //     ?
              //
              //                           //     :
              //                           // Container(
              //                           //   margin: EdgeInsets.only(right: 10),
              //                           //   child: Text(
              //                           //     "introduce".toUpperCase(),
              //                           //     style:textBtnLiteBlue,
              //                           //   ),
              //                           // ),
              //                         ],
              //                       ),
              //                     ),
              //                     Container(
              //                       margin: const EdgeInsets.symmetric(horizontal: 10),
              //                       width: ConstantClass.fullWidth(context),
              //                       height: 2,
              //                       color: const Color(0xFFdedede),
              //                     )
              //                   ],
              //                 );
              //               },
              //             ),
              //           ),
              //   ),
              onSubmittedClick
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.all(defaultPadding),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          minimumSize: const Size.fromHeight(40), // NEW
                        ),
                        onPressed: () {
                          print("LIST====${profileController.selectedTeamMemberList}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const TeamBuilderThreeScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'NEXT'.toUpperCase(),
                          style: textDialogbutton.merge(const TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  : duplicateItem.isEmpty
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.all(defaultPadding),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              minimumSize: const Size.fromHeight(40), // NEW
                            ),
                            onPressed: () {
                              profileController
                                  .addSubmitedTeamMember(teamMemberList: profileController.selectedTeamMemberList)
                                  .then((value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const TeamBuilderThreeScreen();
                                          },
                                        ),
                                      ).then((value) => null));
                            },
                            child: Text(
                              'Submit'.toUpperCase(),
                              style: textDialogbutton.merge(const TextStyle(color: Colors.white)),
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
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
}
