import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/controllers/profile_controllers.dart';
import 'package:solarex/second_phase/models/teamFriendListModel.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/teambuilder_four_screen.dart';
import 'package:solarex/utils/constants.dart';

import '../../../../first_phase/screenUI/shareScreen/component/body.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/style.dart';
import '../../../../utils/loading_spinner.dart';

class TeamBuilderThreeScreen extends StatefulWidget {
  const TeamBuilderThreeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TeamBuilderThreeScreen> createState() => _TeamBuilderThreeScreenState();
}

class _TeamBuilderThreeScreenState extends State<TeamBuilderThreeScreen> {
  List<TeamFriendsItem> duplicateTeamMemberItems = [];
  List<TeamFriendsItem> originalTeamMemberitems = [];

  List<TeamFriendsItem> duplicateTeamMemberItem = [];
  List<TeamFriendsItem> originalTeamMemberitem = <TeamFriendsItem>[];

  List<bool>? ismemberChecked;
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
    profileController.selectedTeamMemberList.value.clear();
    profileController.getSubmittedFriendList();
    refreshList();
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
        originalTeamMemberitems=[];
        duplicateTeamMemberItems=[];
        originalTeamMemberitem=[];
        duplicateTeamMemberItem=[];
        duplicateTeamMemberItems = profileController.teamFriendListModel.value.teamFriendsList ?? [];
        originalTeamMemberitems.addAll(duplicateTeamMemberItems);
        ismemberChecked = List.generate(duplicateTeamMemberItems.length, (index) => false);
        addListData();
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
          if (item.firstName!.toLowerCase().contains(query.toLowerCase()) ||
              item.lastName!.toLowerCase().contains(query.toLowerCase())) {
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
                decoration: const BoxDecoration(
                    color: kPrimaryDarkColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                        hintText:
                            "All Submitted Friends (${originalTeamMemberitem.length - profileController.selectedTeamMemberList.value.length})",
                        hintStyle: textStrBtn,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                      ? Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  // margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Select a friend to edit their name!",
                                    textAlign: TextAlign.start,
                                    style: text14grey.merge(const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: kPrimaryColor),
                                    ),
                                    child: Text("0",
                                        style: textBtnBlue.merge(
                                            const TextStyle(
                                                color: Colors.white)))),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: kPrimaryColor),
                                    ),
                                    child: Text("0",
                                        style: textBtnBlue.merge(
                                            const TextStyle(
                                                color: Colors.white)))),
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
                  :
              // loadinggetFriendsList
            Obx(() => profileController.loadinggetFriendsList.isTrue
                ? const Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: LoadingSpinner(),
                  )),
            )
                : Container(
              // profileController.loadinggetFriendsList.isTrue
              child: profileController.loadinggetFriendsList.isTrue
                  ? const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryDarkColor,
                  ))
                  : duplicateTeamMemberItem.isEmpty? const Expanded(
                child: Center(
                    child: Text(
                      'List is Empty',
                      style: text18Black,
                    )),
              ):
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: originalTeamMemberitem.length,
                  itemBuilder: (context, index) {
                    String name =
                    originalTeamMemberitem[index].firstName != null
                        ? (originalTeamMemberitem[index].firstName!)
                        : "Not available";

                    return GestureDetector(
                      onTap: () {
                        showEditNameDialog(
                            originalTeamMemberitem[index].firstName ?? "",
                            originalTeamMemberitem[index].lastName ?? "",
                            originalTeamMemberitem[index].referredBy ?? "",
                            originalTeamMemberitem[index].memberId ?? "0");
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 14, right: 14),
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
                                  width: ConstantClass.fullWidth(
                                      context) *
                                      0.60,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight:
                                          FontWeight.w600,
                                          color: Colors.black,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      (originalTeamMemberitem[index]
                                          .mobileNumber??"").isEmpty?SizedBox():Text(
                                        originalTeamMemberitem[index]
                                            .mobileNumber ??
                                            "",
                                        style: const TextStyle(
                                          fontWeight:
                                          FontWeight.w600,
                                          color: Colors.grey,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),
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
                            margin: const EdgeInsets.only(
                                left: 14, right: 14),
                            width:
                            ConstantClass.fullWidth(context),
                            height: 2,
                            color: const Color(0xFFdedede),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),),

              Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.all(defaultPadding),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {

                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const TeamBuilderFourScreen();
                          },
                        ),
                      );
                    });
                    // profileController.addSubmitedTeamMember(
                    //     teamMemberList:
                    //         profileController.selectedTeamMemberList);
                  },
                  child: Text(
                    'Next'.toUpperCase(),
                    style: textDialogbutton
                        .merge(const TextStyle(color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future showEditNameDialog(
      String firstName, String lastName, String reffereBy, String memberId) {
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    refNameController.text = reffereBy;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      width: ConstantClass.fullWidth(context),
                      child:
                          // prospectiveController.loadingBookAppointment.isTrue
                          //     ? const Align(
                          //     alignment: Alignment.center,
                          //     child: Padding(
                          //       padding: EdgeInsets.all(10.0),
                          //       child: LoadingSpinner(),
                          //     ))
                          //     :
                          Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Update Submission',
                            style: text18Black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => profileController.loadingEditMember.isTrue
                                ? const Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: LoadingSpinner(),
                                    ))
                                : Container(
                                  child: Column(children: [
                                      TextFormField(
                                        controller: firstNameController,
                                        style: kText14SemiBoldBlack,
                                        decoration: const InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            enabled: true,
                                            fillColor: Colors.white,
                                            labelText: "First Name",
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: colorAppMain),
                                            ),
                                            counterText: "",
                                            hintText: "Enter Name",
                                            labelStyle: kText14SemiBoldGrey,
                                            errorStyle: kText12SemiBoldRed,
                                            hintStyle: kText14SemiBoldGrey),
                                      ),
                                      TextFormField(
                                        controller: lastNameController,
                                        style: kText14SemiBoldBlack,
                                        decoration: const InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            enabled: true,
                                            fillColor: Colors.white,
                                            labelText: "Last Name",
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: colorAppMain),
                                            ),
                                            counterText: "",
                                            hintText: "Enter Name",
                                            labelStyle: kText14SemiBoldGrey,
                                            errorStyle: kText12SemiBoldRed,
                                            hintStyle: kText14SemiBoldGrey),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      TextFormField(
                                        controller: refNameController,
                                        style: kText14SemiBoldBlack,
                                        decoration: const InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            enabled: true,
                                            fillColor: Colors.white,
                                            labelText: "Reference Name",
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: colorAppMain),
                                            ),
                                            counterText: "",
                                            hintText: "Enter Name",
                                            labelStyle: kText14SemiBoldGrey,
                                            errorStyle: kText12SemiBoldRed,
                                            hintStyle: kText14SemiBoldGrey),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "Cancel".toUpperCase(),
                                              style: textDialogbutton,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.h,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              textStyle:
                                              const TextStyle(color: Colors.white),
                                            ),
                                            onPressed: () {
                                              profileController
                                                  .editTeamMember(
                                                  memberId: memberId,
                                                  firstName: firstNameController.text,
                                                  lastName: lastNameController.text,
                                                  refName: refNameController.text)
                                                  .then(
                                                      (value){
                                                        refreshList();
                                                        Navigator.pop(context);
                                                    // profileController.getSubmittedFriendList().then((value) =>  Navigator.pop(context));
                                                    // Navigator.pop(context);
                                                  } );
                                              // Navigator.pop(context);
                                            },
                                            child: Text('Save'.toUpperCase(),
                                                style: textStrBtn),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ]),
                                ),
                          ),

                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
