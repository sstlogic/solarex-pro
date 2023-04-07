import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/controllers/profile_controllers.dart';
import 'package:solarex/second_phase/models/teamFriendListModel.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/Intro/teambuilder_intro_first_screen.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/teambuilder_first_screen.dart';
import 'package:solarex/second_phase/screens/More/more_screen.dart';
import 'package:solarex/utils/constants.dart';

import '../../../../first_phase/screenUI/shareScreen/component/body.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/style.dart';

class TeamBuilderFourScreen extends StatefulWidget {
  const TeamBuilderFourScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TeamBuilderFourScreen> createState() => _TeamBuilderFourScreenState();
}

class _TeamBuilderFourScreenState extends State<TeamBuilderFourScreen> {
  List<TeamFriendsItem> duplicateTeamMemberItems = [];
  List<TeamFriendsItem> originalTeamMemberitems = [];
  List<TeamFriendsItem> duplicateTeamMemberItem = [];
  List<TeamFriendsItem> originalTeamMemberitem = <TeamFriendsItem>[];

  List<bool>? isChecked;
  int contactNo = 0;
  final _debouncer = Debouncer();

  final profileController = Get.put(ProfileController());
  var selectedAll = false;
  var notSubmitedCount = 0;
  var onFilterClick = false;
  var onSubmittedClick = false;
  final firstNameController = TextEditingController(text: "");
  final lastNameController = TextEditingController(text: "");
  final refNameController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    profileController.selectedTeamMemberList.clear();
    profileController.selectedTeamFriendList.clear();
    profileController.getSubmittedFriendList();
    refreshList();
  }

  addDataFriendList() async {
    for (int i = 0; i < duplicateTeamMemberItems.length; i++) {
      duplicateTeamMemberItem.add(TeamFriendsItem(
        memberId: duplicateTeamMemberItems[i].memberId,
        firstName: duplicateTeamMemberItems[i].firstName,
        lastName: duplicateTeamMemberItems[i].lastName,
        mobileNumber: duplicateTeamMemberItems[i].mobileNumber,
        referredBy: duplicateTeamMemberItems[i].referredBy,
      ));
    }
    originalTeamMemberitem.addAll(duplicateTeamMemberItem);
  }

  Future<void> refreshList() async {
    profileController.getSubmittedFriendList().then((value) {
      setState(() {
        duplicateTeamMemberItems = profileController.teamFriendListModel.value.teamFriendsList ?? [];
        originalTeamMemberitems.addAll(duplicateTeamMemberItems);
        isChecked = List.generate(duplicateTeamMemberItems.length, (index) => false);
        addDataFriendList();
      });
    });
  }

  void filterSearchResults(String query) {
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
        print("duplicated items length ${duplicateTeamMemberItem.length.toString()}");
        originalTeamMemberitem.clear();
        originalTeamMemberitem.addAll(duplicateTeamMemberItem);
      }
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
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        title: const Text(
          "Fix Names",
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
                            filterSearchResults(string);
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
                        hintText: "All Submitted Friends (${originalTeamMemberitem.length - profileController.selectedTeamMemberList.value.length})",
                        hintStyle: textStrBtn,
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    )),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       // onFilterClick = !onFilterClick;
                    //     });
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(horizontal: 10.w),
                    //     padding: const EdgeInsets.all(4),
                    //     decoration: onFilterClick
                    //         ? BoxDecoration(
                    //             borderRadius: BorderRadius.circular(100),
                    //             border: Border.all(
                    //               width: 1,
                    //               color: Colors.white,
                    //             ))
                    //         : const BoxDecoration(),
                    //     child: const Icon(
                    //       Icons.filter_list,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              !onFilterClick
                  ? !onSubmittedClick
                      ? Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Align(
                                alignment: Alignment.topLeft,
                                // margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "Select a friend to edit their name!",
                                  textAlign: TextAlign.start,
                                  style: text14grey.merge(const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    textStyle: const TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (selectedAll) {
                                      for (var item in originalTeamMemberitem) {
                                        selectedAll = false;
                                        item.isCheck = false;
                                        profileController.selectedTeamFriendList.value.remove(item);
                                      }
                                    } else {
                                      profileController.selectedTeamFriendList.value.clear();
                                      for (var item in originalTeamMemberitem) {
                                        selectedAll = true;
                                        item.isCheck = true;
                                        profileController.selectedTeamFriendList.value.add(item);
                                      }
                                    }
                                    print(profileController.selectedTeamFriendList.value.length);
                                    setState(() {});
                                  },
                                  child: Text(selectedAll ? 'unselect all'.toUpperCase() : 'Select all'.toUpperCase(), style: textStrBtn),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container()
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              onSubmittedClick = false;
                              onFilterClick = false;
                            });
                          },
                          child: Container(
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Row(
                              children: [
                                const Text(
                                  "Not Submitted",
                                  style: textBtnBlue,
                                ),
                                const Spacer(),
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: kPrimaryColor),
                                    ),
                                    child: Text("0", style: textBtnBlue.merge(const TextStyle(color: Colors.white)))),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              onSubmittedClick = true;
                              onFilterClick = false;
                            });
                          },
                          child: Container(
                            height: 30.h,
                            margin: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Row(
                              children: [
                                const Text(
                                  "Submitted",
                                  style: textBtnBlue,
                                ),
                                const Spacer(),
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: kPrimaryColor),
                                    ),
                                    child: Text("0", style: textBtnBlue.merge(const TextStyle(color: Colors.white)))),
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
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "No contacts madeit through this filter.",
                              style: text14BlackBold,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Reset".toUpperCase(),
                              style: textBtnBlue,
                            ),
                          ],
                        ),
                      ),
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
                                          originalTeamMemberitem[index].isCheck = true;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return TeamBuilderIntrofristScreen(
                                                  memberId: originalTeamMemberitem[index].memberId ?? "0",
                                                  isCompleteIntro: false,
                                                );
                                              },
                                            ),
                                          );
                                          // TeamBuilderIntrofristScreen
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
                                                  SizedBox(
                                                    height: 25,
                                                    child: Checkbox(
                                                        value: originalTeamMemberitem[index].isCheck,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            originalTeamMemberitem[index].isCheck = value;
                                                            if (originalTeamMemberitem[index].isCheck == true) {
                                                              contactNo++;
                                                              profileController.selectedTeamFriendList.value.add(originalTeamMemberitem[index]);
                                                            } else {
                                                              contactNo--;
                                                              profileController.selectedTeamFriendList.value.remove(originalTeamMemberitem[index]);
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

                                                  Expanded(
                                                    child: SizedBox(
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
                                                              ? const SizedBox()
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
                                                  ),

                                                  Text(
                                                    originalTeamMemberitem[index].isCheck == true ? "Introduced" : "Introduce",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.chevron_right,
                                                    color: kPrimaryDarkColor,
                                                  ),
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {
                    // profileController.selectedTeamFriendList.value
                    if (profileController.selectedTeamFriendList.isNotEmpty) {
                      profileController
                          .introducedFormAPI(
                        memberData: profileController.selectedTeamFriendList,
                      )
                          .then((value) {
                        // TeamBuilderSecondScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const MoreScreen();
                            },
                          ),
                        );
                      });
                    } else {
                      Fluttertoast.showToast(msg: "Please Select Contact");
                    }

                    // profileController
                    //     .addSubmitedTeamMember(teamMemberList: profileController.selectedTeamMemberList)
                    //     .then((value) => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return const TeamBuilderThreeScreen();
                    //     },
                    //   ),
                    // ).then((value) => null));

                    // Navigator.pop(context);
                  },
                  child: Text(
                    'Submit'.toUpperCase(),
                    style: textDialogbutton.merge(const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
                // padding: const EdgeInsets.all(defaultPadding),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const TeamBuilderfristScreen();
                        },
                      ),
                    );
                    // Navigator.pop(context);
                  },
                  child: Text(
                    'Back'.toUpperCase(),
                    style: textDialogbutton.merge(const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
