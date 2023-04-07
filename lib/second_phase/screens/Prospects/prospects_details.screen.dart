// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarex/first_phase/FirstHomeScreen/firstHomeScreen.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/second_phase/controllers/prospective_controllers.dart';
import 'package:solarex/second_phase/models/milestoneKey.dart';
import 'package:solarex/second_phase/models/statusListModel.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/colors.dart';
import '../../../utils/loading_spinner.dart';

class ProspectsDetailsScreen extends StatefulWidget {
  const ProspectsDetailsScreen({Key? key, required this.contectId})
      : super(
          key: key,
        );
  final contectId;

  @override
  State<ProspectsDetailsScreen> createState() => _ProspectsDetailsScreenState();
}

class _ProspectsDetailsScreenState extends State<ProspectsDetailsScreen> {
  final List<String> marrieditems = [
    'Yes',
    'No',
    '?',
  ];
  final List<String> homeOwneritems = [
    'Yes',
    'No',
    '?',
  ];
  final List<String> hasSolarExitems = [
    'Yes',
    'No',
    '?',
  ];
  final List<String> boughtFromMeitems = ['Powur', 'SunRun', 'Freedom Forever', 'Other', 'N/A'];
  final List<String> ages = [
    '29-64',
    '65+',
  ];
  String? selectedValueMarried;
  String? selectedHomeownerValue;
  String? selectedHasSolarExValue;
  String? selectedboughtValue;
  String? selectedAgeValue;
  final prospectiveController = Get.put(ProspectiveController());
  final startDateController = TextEditingController(text: "Select Date");
  final endDateController = TextEditingController(text: "Select Date");
  final dateAndTimeController = TextEditingController(text: "Select Date");
  final prospectEmailController = TextEditingController(text: "");
  final notesController = TextEditingController(text: "");
  int? _selectedMediumValueIndex = 0;
  int? _selectedLanguageValueIndex = 0;
  List<String> buttonTextMedium = ["VIRTUAL", "IN-PERSON"];
  List<String> buttonTextLanguage = ["ENGLISH", "ESPANOL", "FRANCAIS"];
  final containerKey = GlobalKey();
  String appointmentStatus = "Added";
  List<MilestoneKey> milestoneKeys = [];
  final authController = Get.put(AuthController());
  final ImagePicker imagePicker = ImagePicker();
  XFile pickedImageFile = XFile("");

  @override
  void initState() {
    super.initState();

    callDetailsAPIS();

    // prospectiveController.getMessageList().then((value) => print(
    //     "MSG====${prospectiveController.messageListModel.value.messageList?.first.mesg}"));
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
        title: Text(
          prospectiveController.prospectiveDetails.value.data?.name ?? '',
          style: textHeading,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: ConstantClass.fullWidth(context),
          // height: ConstantClass.fullHeight(context),
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 70),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              decoration: BoxDecoration(
                color: colorBoxDarkBackground1,
                border: Border.all(
                    color: colorBoxDarkBackground1, // Set border color
                    width: 3.0), // Set border width
                borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 10),
                const Text('Phone Number', style: text16Black),
                const SizedBox(height: 10),
                Text(
                  prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? "",
                  style: text30Black,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            prospectiveController.addCallCount(contectId: widget.contectId).then((value) {
                              if (value) {
                                prospectiveController.prospectiveDetails.value.data?.call_count =
                                    (int.parse(prospectiveController.prospectiveDetails.value.data?.call_count ?? "0") + 1).toString();
                              }
                            });
                            showDialog(
                              context: context,
                              builder: (_) => PopUp(
                                  mobileNumber: prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? "",
                                  onTapCall: () {
                                    showCallDialog();
                                    print("Call RRRR 22");
                                    _makePhoneCall(prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? "0");
                                  }),
                            );
                          });
                        },
                        child: const Text('CALL', style: textStrBtn),
                      ),
                    ),
                    // Spacer(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            prospectiveController.addTextCount(contectId: widget.contectId).then((value) {
                              if (value) {
                                prospectiveController.prospectiveDetails.value.data?.text_count =
                                    (int.parse(prospectiveController.prospectiveDetails.value.data?.text_count ?? "0") + 1).toString();
                              }
                            });
                            textMessageDialog();
                          });
                        },
                        child: const Text('TEXT', style: textStrBtn),
                      ),
                    ),
                    // Spacer(),
                    const SizedBox(width: 10),
                    // Expanded(
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //       backgroundColor: Colors.blue,
                    //       textStyle: const TextStyle(color: Colors.white),
                    //     ),
                    //     onPressed: () {},
                    //     child: const Text('RECEIVE', style: textStrBtn),
                    //   ),
                    // )
                  ],
                ),
                const SizedBox(height: 10),
              ]),
            ),
            const SizedBox(height: 10),
            Container(
                decoration: BoxDecoration(
                  color: colorBoxDarkBackground1,
                  border: Border.all(
                      color: colorBoxDarkBackground1, // Set border color
                      width: 3.0), // Set border width
                  borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                  // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                ),
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 10),
                  const Text('Prospect Stats', style: text16Black),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          // margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFeeeeee),
                          ),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Married?',
                                  style: textBtnLiteBlue,
                                ),
                              ),
                              Row(
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: Expanded(
                                      flex: 1,
                                      child: DropdownButton2(
                                        hint: const Text(
                                          'No',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        items: marrieditems
                                            .map((item) => DropdownMenuItem<String>(
                                                  value: item!.isNotEmpty ? item : "No",
                                                  child: Text(
                                                    item!.isNotEmpty ? item.toString() : "",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: selectedValueMarried,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValueMarried = value.toString();
                                            print("selected Value===$selectedValueMarried");
                                          });
                                        },
                                        // buttonHeight: 40,
                                        // buttonWidth: 300,
                                        itemHeight: 40,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Container(
                          // margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFeeeeee),
                          ),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Homeowner?',
                                  style: textBtnLiteBlue,
                                ),
                              ),
                              Row(
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: Expanded(
                                      flex: 1,
                                      child: DropdownButton2(
                                        hint: const Text(
                                          'No',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        items: homeOwneritems
                                            .map((item) => DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: selectedHomeownerValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedHomeownerValue = value as String;
                                            print("selected Value===$selectedHomeownerValue");
                                          });
                                        },
                                        // buttonHeight: 40,
                                        // buttonWidth: 300,
                                        itemHeight: 40,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Container(
                          // margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFeeeeee),
                          ),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Age?',
                                  style: textBtnLiteBlue,
                                ),
                              ),
                              Row(
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: Expanded(
                                      flex: 1,
                                      child: DropdownButton2(
                                        hint: const Text(
                                          '29-64',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        items: ages
                                            .map((item) => DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: selectedAgeValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedAgeValue = value as String;
                                            print("selected Value===$selectedAgeValue");
                                          });
                                        },
                                        // buttonHeight: 40,
                                        // buttonWidth: 300,
                                        itemHeight: 40,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Color(0xFF000000),
                    height: 14,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          // margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(4.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFeeeeee),
                          ),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Seen proposal before?',
                                  style: textBtnLiteBlue,
                                ),
                              ),
                              Row(
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: Expanded(
                                      flex: 1,
                                      child: DropdownButton2(
                                        hint: const Text(
                                          'No',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        items: hasSolarExitems
                                            .map((item) => DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: selectedHasSolarExValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedHasSolarExValue = value as String;
                                          });
                                        },
                                        // buttonHeight: 40,
                                        // buttonWidth: 300,
                                        itemHeight: 40,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFeeeeee),
                          ),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'What company?',
                                  style: textBtnLiteBlue,
                                ),
                              ),
                              Row(
                                children: [
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      hint: const Text(
                                        'Powur',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      items: boughtFromMeitems
                                          .map((item) => DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedboughtValue,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedboughtValue = value as String;
                                        });
                                      },
                                      // buttonHeight: 40,
                                      // buttonWidth: 300,
                                      itemHeight: 40,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Obx(
                    () => prospectiveController.loadingstatsData.isTrue
                        ? const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: LoadingSpinner(),
                            ))
                        : Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  prospectiveController.setStatsData(
                                      contectId: widget.contectId,
                                      married: selectedValueMarried,
                                      has_cutco: selectedHasSolarExValue,
                                      bought_from_me: selectedboughtValue,
                                      age: selectedAgeValue,
                                      homeowner: selectedHomeownerValue);
                                });
                              },
                              child: Text('Save'.toUpperCase(), style: textStrBtn),
                            ),
                          ),
                  )
                ])),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: colorBoxDarkBackground1,
                border: Border.all(
                    color: colorBoxDarkBackground1, // Set border color
                    width: 3.0), // Set border width
                borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Obx(
                () => prospectiveController.loadingAppointmentList.isTrue
                    ? const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: LoadingSpinner(),
                        ))
                    : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // const SizedBox(height: 10),
                        Row(
                          children: [
                            const Expanded(child: Text('Appointment', style: text16Black)),
                            (prospectiveController.allAppointmentListModel.value.allAppointmentList ?? []).isNotEmpty && milestoneKeys.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      resetBookApponintmentData();
                                      showBookAppointmentDialog(false, "");
                                      // });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: kPrimaryDarkColor,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(children: [
                          const Text('Booking Attempts:', style: text16BlackN),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Calls:${prospectiveController.prospectiveDetails.value.data?.call_count ?? "0"}', style: text16BlackN),
                              Text('Text:${prospectiveController.prospectiveDetails.value.data?.text_count ?? "0"}', style: text16BlackN),
                            ],
                          ))
                        ]),
                        const SizedBox(height: 10),
                        (prospectiveController.allAppointmentListModel.value.allAppointmentList ?? []).isEmpty || milestoneKeys.isEmpty
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        textStyle: const TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          resetBookApponintmentData();
                                          showBookAppointmentDialog(false, "");
                                        });
                                      },
                                      child: Text('BOOK Appointment'.toUpperCase(), style: textStrBtn),
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  // alignment: WrapAlignment.center,
                                  runSpacing: 5,
                                  children: (prospectiveController.allAppointmentListModel.value.allAppointmentList ?? [])
                                      .asMap()
                                      .map((i, appointmentItem) => MapEntry(
                                          i,
                                          Container(
                                            key: milestoneKeys[i].containerKey,
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: colorBoxDarkBackground1,
                                                  // Set border color
                                                  width: 3.0), // Set border width
                                              borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                                              // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                                            ),
                                            child: Row(children: [
                                              const Icon(
                                                Icons.calendar_month_sharp,
                                                color: kPrimaryDarkColor,
                                              ),
                                              const SizedBox(width: 14.0),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${DateFormat('EEE, MMM dd').format(DateTime.parse(appointmentItem.startDate ?? ''))} @ ${appointmentItem.startTime}",
                                                      // 'Tue, Sep 6th @ 8:15 PM',
                                                      style: text14BlackBold),
                                                  ((appointmentItem.mark) ?? []).toString().toLowerCase() == "complete"
                                                      ? Container(
                                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                                          padding: const EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                            color: colorAppMain,
                                                            border: Border.all(
                                                              color: colorAppMain,
                                                            ),
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Text(
                                                            "Completed",
                                                            textAlign: TextAlign.start,
                                                            style: text14White.merge(const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                            )),
                                                          ))
                                                      : const SizedBox()
                                                ],
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  _showPopupMenu(appointmentItem.appointmentId ?? "", milestoneKeys[i].containerKey,
                                                      ((appointmentItem.mark) ?? []).toString());
                                                },
                                                child: const Icon(
                                                  Icons.more_horiz,
                                                  color: kPrimaryDarkColor,
                                                ),
                                              ),
                                            ]),
                                            // Column(
                                            //   children: [
                                            //
                                            //     Text("Text")
                                            //   ],
                                            // ),
                                          )))
                                      .values
                                      .toList(),

                                  // prospectiveController
                                  //     .allAppointmentListModel
                                  //     .value
                                  //     .allAppointmentList!
                                  //     .map(
                                  //       (appointmentItem) => Container(
                                  //         // key: milestoneKeys[],
                                  //         // key: Key(appointmentItem.meetingId.toString()),
                                  //         padding:
                                  //             const EdgeInsets.all(10.0),
                                  //         decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //               color:
                                  //                   colorBoxDarkBackground1,
                                  //               // Set border color
                                  //               width:
                                  //                   3.0), // Set border width
                                  //           borderRadius: const BorderRadius
                                  //                   .all(
                                  //               Radius.circular(
                                  //                   2.0)), // Set rounded corner radius
                                  //           // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                                  //         ),
                                  //         child: Row(children: [
                                  //           const Icon(
                                  //             Icons.calendar_month_sharp,
                                  //             color: kPrimaryDarkColor,
                                  //           ),
                                  //           const SizedBox(width: 14.0),
                                  //           const Text(
                                  //               // DateFormat('EEE, MMM, dd').format(DateTime.parse(appointmentItem.startDate??'')),
                                  //               'Tue, Sep 6th @ 8:15 PM',
                                  //               style: text14BlackBold),
                                  //           const Spacer(),
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               _showPopupMenu(0);
                                  //             },
                                  //             child: const Icon(
                                  //               Icons.more_horiz,
                                  //               color: kPrimaryDarkColor,
                                  //             ),
                                  //           ),
                                  //         ]),
                                  //       ),
                                  //     )
                                  //     .toList(),
                                ),
                              ),

                        const SizedBox(height: 6),
                      ]),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  showSetStatusDialog();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorBoxDarkBackground1,
                  border: Border.all(
                      color: colorBoxDarkBackground1, // Set border color
                      width: 3.0), // Set border width
                  borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                  // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Status", style: text16Black),
                  const SizedBox(height: 10),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorBoxDarkBackground1,
                      border: Border.all(
                          color: colorBoxDarkBackground1,
                          // Set border color
                          width: 3.0), // Set border width
                      borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                      // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                    ),
                    child: Row(children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(appointmentStatus, style: text16BlackN),
                      )),
                      const Icon(
                        Icons.chevron_right,
                        color: kPrimaryDarkColor,
                      ),
                      const SizedBox(width: 10),
                    ]),
                  ),
                  // const SizedBox(height: 6),
                ]),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: colorBoxDarkBackground1,
                border: Border.all(
                    color: colorBoxDarkBackground1, // Set border color
                    width: 3.0), // Set border width
                borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Meeting Code', style: text16Black),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorBoxDarkBackground1,
                    border: Border.all(
                        color: colorBoxDarkBackground1,
                        // Set border color
                        width: 3.0), // Set border width
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                    // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                  ),
                  child: Row(children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(prospectiveController.prospectiveDetails.value.data?.meetingCode ?? "0", style: text16BlackN),
                    )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Clipboard.setData(ClipboardData(text: prospectiveController.prospectiveDetails.value.data?.meetingCode ?? "0"))
                              .then((value) => Fluttertoast.showToast(msg: 'Copied'));
                        });
                      },
                      child: const Icon(
                        Icons.copy,
                        color: kPrimaryDarkColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Share.share(prospectiveController.prospectiveDetails.value.data?.meetingCode ?? "0", subject: 'Meeting Code');
                        });
                      },
                      child: const Icon(
                        Icons.ios_share,
                        size: 22,
                        color: kPrimaryDarkColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ]),
                ),
                // const SizedBox(height: 6),
              ]),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: colorBoxDarkBackground1,
                border: Border.all(
                    color: colorBoxDarkBackground1, // Set border color
                    width: 3.0), // Set border width
                borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Task', style: text16Black),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorBoxDarkBackground1,
                    border: Border.all(
                        color: colorBoxDarkBackground1,
                        // Set border color
                        width: 3.0), // Set border width
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                    // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                  ),
                  child: Row(children: const [
                    Icon(
                      Icons.calendar_month_sharp,
                      color: kPrimaryDarkColor,
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Book Appoinment', style: text16BlackN),
                    )),
                  ]),
                ),

                // const SizedBox(height: 6),
              ]),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: colorBoxDarkBackground1,
                border: Border.all(
                    color: colorBoxDarkBackground1, // Set border color
                    width: 3.0), // Set border width
                borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Utility Bill', style: text16Black),
                const SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    // height: 40,
                    decoration: BoxDecoration(
                      color: colorBoxDarkBackground1,
                      border: Border.all(
                          color: colorBoxDarkBackground1,
                          // Set border color
                          width: 3.0), // Set border width
                      borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                      // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Container(
                            child: pickedImageFile.path.isEmpty
                                ? prospectiveController.prospectiveDetails.value.data?.file != null &&
                                        prospectiveController.prospectiveDetails.value.data?.file != ''
                                    ? Image.network(prospectiveController.prospectiveDetails.value.data?.file ?? '')
                                    : pickedImageFile.path.isNotEmpty
                                        ? Image.file(
                                            File(pickedImageFile?.path ?? ""),
                                            // height: 200,
                                            // width: 100,
                                          )
                                        : Image.asset(
                                            'assets/images/placeholder.png',
                                            color: Colors.white,
                                            height: 200,
                                          )
                                : Image.file(
                                    File(pickedImageFile?.path ?? ""),
                                    // height: 200,
                                    // width: 100,
                                  )),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    textStyle: const TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    initImagePickUp(ImageSource.gallery);
                                    // setState(() {
                                    //
                                    // });
                                  },
                                  child: Text('Select Photo'.toUpperCase(), style: textStrBtn),
                                )),
                            SizedBox(width: 10.w),
                            Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    textStyle: const TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (pickedImageFile.path.isNotEmpty) {
                                        var bytes = File(pickedImageFile.path).readAsBytesSync();
                                        prospectiveController.uploadImage(contactId: widget.contectId, imageFile: base64Encode(bytes));
                                      } else {
                                        if ((prospectiveController.prospectiveDetails.value.data?.file ?? '').isEmpty) {
                                          Fluttertoast.showToast(msg: "Please Select Image");
                                        } else {
                                          Fluttertoast.showToast(msg: "Image is already uploaded");
                                        }
                                      }
                                    });
                                  },
                                  child: Text('Upload'.toUpperCase(), style: textStrBtn),
                                )),
                          ],
                        ),
                      ],
                    )
                    // Column(children: [
                    //   Expanded(
                    //       child: Padding(
                    //     padding: EdgeInsets.only(left: 10),
                    //     child: Text('Book Appoinment', style: text16BlackN),
                    //   )),
                    //   SizedBox(
                    //     width: 10.h,
                    //   ),
                    //   Align(
                    //     alignment: Alignment.centerRight,
                    //     child: TextButton(
                    //       style: TextButton.styleFrom(
                    //         backgroundColor: Colors.blue,
                    //         textStyle: const TextStyle(color: Colors.white),
                    //       ),
                    //       onPressed: () {
                    //         setState(() {});
                    //       },
                    //       child: Text('Save'.toUpperCase(), style: textStrBtn),
                    //     ),
                    //   ),
                    // ]),
                    ),

                // const SizedBox(height: 6),
              ]),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: colorBoxDarkBackground1,
                border: Border.all(
                    color: colorBoxDarkBackground1, // Set border color
                    width: 3.0), // Set border width
                borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Notes', style: text16Black),
                const SizedBox(height: 10),
                Obx(
                  () => prospectiveController.loadingAddedNotes.isTrue
                      ? const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: LoadingSpinner(),
                          ))
                      : Column(children: [
                          SizedBox(
                            height: 100,
                            child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    // child: Text('Book Appoinment', style: text16BlackN),
                                    child: TextFormField(
                                      controller: notesController,
                                      maxLines: 5,
                                      textAlign: TextAlign.start,
                                      decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffd0d0d2)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffd0d0d2)),
                                        ),
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        // hintText: "Enter REPt Number",

                                        // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                      ),
                                    ),
                                  )),
                                ]),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  final checkString = notesController.text.isEmpty == null || notesController.text.trim() == '';
                                  if (!checkString) {
                                    prospectiveController.addNotesAPI(contectId: widget.contectId, note: notesController.text).then((value) {
                                      if (value) {
                                        notesController.text = "";
                                        prospectiveController.getAllNotes(contectId: widget.contectId);
                                      }
                                    });
                                  } else {
                                    Fluttertoast.showToast(msg: 'Note is Empty');
                                  }

                                  // prospectiveController.addNotesAPI(contectId: widget.contectId, note: notesController.text).then((value) {
                                  //   if (value) {
                                  //     notesController.text = "";
                                  //     prospectiveController.getAllNotes(contectId: widget.contectId);
                                  //   }
                                  // });
                                });
                              },
                              child: Text('Add Notes'.toUpperCase(), style: textStrBtn),
                            ),
                          ),
                        ]),
                ),
                const SizedBox(height: 6),
                Obx(
                  () => prospectiveController.loadingNoteList.isTrue
                      ? const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: LoadingSpinner(),
                          ))
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Wrap(
                            direction: Axis.horizontal,
                            // alignment: WrapAlignment.center,
                            runSpacing: 5,
                            children: (prospectiveController.allNotesModel.value.allNotesList ?? [])
                                .asMap()
                                .map((i, notesItem) => MapEntry(
                                    i,
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: colorBoxDarkBackground1,
                                            // Set border color
                                            width: 3.0), // Set border width
                                        borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                                        // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                                      ),
                                      child: Row(children: [
                                        const SizedBox(width: 14.0),
                                        Text(notesItem.note ?? "",
                                            style: text14BlackBold.merge(const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                            ))),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            prospectiveController.deleteNotes(noteId: notesItem.noteId).then((value) {
                                              prospectiveController.getAllNotes(contectId: widget.contectId);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: kPrimaryDarkColor,
                                          ),
                                        ),
                                      ]),
                                    )))
                                .values
                                .toList(),

                            // prospectiveController
                            //     .allAppointmentListModel
                            //     .value
                            //     .allAppointmentList!
                            //     .map(
                            //       (appointmentItem) => Container(
                            //         // key: milestoneKeys[],
                            //         // key: Key(appointmentItem.meetingId.toString()),
                            //         padding:
                            //             const EdgeInsets.all(10.0),
                            //         decoration: BoxDecoration(
                            //           border: Border.all(
                            //               color:
                            //                   colorBoxDarkBackground1,
                            //               // Set border color
                            //               width:
                            //                   3.0), // Set border width
                            //           borderRadius: const BorderRadius
                            //                   .all(
                            //               Radius.circular(
                            //                   2.0)), // Set rounded corner radius
                            //           // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                            //         ),
                            //         child: Row(children: [
                            //           const Icon(
                            //             Icons.calendar_month_sharp,
                            //             color: kPrimaryDarkColor,
                            //           ),
                            //           const SizedBox(width: 14.0),
                            //           const Text(
                            //               // DateFormat('EEE, MMM, dd').format(DateTime.parse(appointmentItem.startDate??'')),
                            //               'Tue, Sep 6th @ 8:15 PM',
                            //               style: text14BlackBold),
                            //           const Spacer(),
                            //           GestureDetector(
                            //             onTap: () {
                            //               _showPopupMenu(0);
                            //             },
                            //             child: const Icon(
                            //               Icons.more_horiz,
                            //               color: kPrimaryDarkColor,
                            //             ),
                            //           ),
                            //         ]),
                            //       ),
                            //     )
                            //     .toList(),
                          ),
                        ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            Obx(
              () => prospectiveController.loadingRefferalList.isTrue
                  ? const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: LoadingSpinner(),
                      ))
                  : (prospectiveController.referralUserListModel.value.referralUserList ?? []).isEmpty
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            color: colorBoxDarkBackground1,
                            border: Border.all(
                                color: colorBoxDarkBackground1, // Set border color
                                width: 3.0), // Set border width
                            borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                            // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            Text('Referrals (${prospectiveController.referralUserListModel.value.referralUserList?.length})', style: text16Black),
                            SizedBox(height: 10.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Wrap(
                                direction: Axis.horizontal,
                                // alignment: WrapAlignment.center,
                                runSpacing: 5,
                                children: (prospectiveController.referralUserListModel.value.referralUserList ?? [])
                                    .asMap()
                                    .map((i, refferalUserItem) => MapEntry(
                                        i,
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: colorBoxDarkBackground1,
                                                // Set border color
                                                width: 3.0), // Set border width
                                            borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                                            // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              prospectiveController
                                                  .addProspective(id: userId, mobile: refferalUserItem.mobile, name: refferalUserItem.name)
                                                  .then((value) {
                                                // print('cccc=====${prospectiveController.commonModel.value.contactId}');
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return ProspectsDetailsScreen(
                                                        contectId: prospectiveController.commonModel.value.contactId.toString(),
                                                      );
                                                    },
                                                  ),
                                                ).then((value) => callDetailsAPIS());
                                              });

                                              // setState(() {
                                              // Navigator.pushReplacement(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return ProspectsDetailsScreen(
                                              //         contectId: refferalUserItem.contactId,
                                              //       );
                                              //     },
                                              //   ),
                                              // );
                                              // });
                                            },
                                            child: Row(children: [
                                              const Icon(
                                                Icons.person,
                                                color: kPrimaryDarkColor,
                                              ),
                                              const SizedBox(width: 14.0),
                                              Text(refferalUserItem.name ?? "",
                                                  style: text14BlackBold.merge(const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                  ))),
                                            ]),
                                          ),
                                        )))
                                    .values
                                    .toList(),
                              ),
                            ),
                          ])),
            )
          ]),
        ),
      )),
    );
  }

  initImagePickUp(ImageSource source) async {
    final XFile? pickedFile = await imagePicker.pickImage(
      source: source,
      // maxWidth: 400.0,
      // maxHeight: 400.0,
      imageQuality: 100,
    );
    setState(() {
      print('Call Image===${pickedFile?.path}');
      if (pickedFile != null) {
        pickedImageFile = pickedFile;
      }

      // if (pickedImageFile.path.isNotEmpty) {
      //   var bytes = File(pickedImageFile.path).readAsBytesSync();
      // }
    });
  }

  _showPopupMenu(String id, GlobalKey<State<StatefulWidget>> containerKey, String markAppointment) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(containerKey.globalPaintBounds!.right, containerKey.globalPaintBounds!.top + 40,
          containerKey.globalPaintBounds!.left + 30, containerKey.globalPaintBounds!.bottom),
      items: [
        PopupMenuItem<String>(
          child: const Text("Edit"),
          value: '1',
          onTap: () {
            // prospectiveController
            //     .allAppointmentListModel
            //     .value
            //     .allAppointmentList!

            setState(() {
              if (prospectiveController.allAppointmentListModel.value.allAppointmentList != null) {
                var findIndexofStatus =
                    prospectiveController.allAppointmentListModel.value.allAppointmentList!.indexWhere((prod) => prod.appointmentId!.contains(id));

                if (findIndexofStatus != -1) {
                  // startDateController.text = DateFormat('MMM d yyyy').format(DateTime.parse((
                  //     prospectiveController
                  //     .allAppointmentListModel
                  //     .value
                  //     .allAppointmentList?[findIndexofStatus]
                  //     .startDate ??
                  //     ""))) +
                  //     " " +
                  //     (prospectiveController.allAppointmentListModel.value
                  //             .allAppointmentList?[findIndexofStatus].startTime ??
                  //         "");

                  startDateController.text =
                      "${DateFormat('MMM d yyyy').format(DateTime.parse(((prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].startDate ?? ""))))} ${(prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].startTime ?? "")}";

                  endDateController.text = DateFormat('MMM d yyyy').format(DateTime.parse(
                          (prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].endDate ?? ""))) +
                      " " +
                      (prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].endTime ?? "");

                  // endDateController.text = "${ DateFormat('MMM d yyyy').format(DateTime.parse(((prospectiveController
                  //     .allAppointmentListModel
                  //     .value
                  //     .allAppointmentList?[findIndexofStatus]
                  //     .endDate ??
                  //     ""))))
                  // } ${(prospectiveController
                  //     .allAppointmentListModel
                  //     .value
                  //     .allAppointmentList?[findIndexofStatus]
                  //     .endTime ??
                  //     "")}";
                  prospectEmailController.text =
                      prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].prospectEmail ?? "";
                  startDateSelect = prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].startDate ?? "";
                  startTimeSelect = prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].startTime ?? "";
                  endTimeSelect = prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].endTime ?? "";
                  endDateSelect = prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].endDate ?? "";
                  print("LANGUAGE===${prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].language}");
                  // ["ENGLISH", "ESPANOL", "FRANCAIS"];
                  if (prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].language == "ENGLISH") {
                    _selectedLanguageValueIndex = 0;
                  } else if (prospectiveController.allAppointmentListModel.value.allAppointmentList?[findIndexofStatus].language == "ESPANOL") {
                    _selectedLanguageValueIndex = 1;
                  } else {
                    _selectedLanguageValueIndex = 2;
                  }

                  showBookAppointmentDialog(true, id);
                }
              }
            });
          },
        ),
        PopupMenuItem<String>(
            child: Text(markAppointment.toLowerCase() == "complete" ? "Mark Uncompleted" : "Mark Completed"),
            value: '2',
            onTap: () {
              setState(() {
                prospectiveController
                    .markCompleteAPI(appointMentId: id, markMessage: markAppointment.toLowerCase() == "complete" ? "uncompleted" : "complete")
                    .then((value) {
                  prospectiveController.getAppointmentList(contactId: widget.contectId).then((value) {
                    milestoneKeys.clear();
                    milestoneKeys = (prospectiveController.allAppointmentListModel.value.allAppointmentList ?? [])
                        .map(
                          (m) => MilestoneKey(
                            key: GlobalKey(),
                            containerKey: GlobalKey(),
                          ),
                        )
                        .toList();
                  });
                });
              });
            }),
        PopupMenuItem<String>(
            child: const Text("Remove"),
            value: '2',
            onTap: () {
              setState(() {
                prospectiveController.deleteAppointment(appointmentId: id).then((value) {
                  prospectiveController.getAppointmentList(contactId: widget.contectId).then((value) {
                    milestoneKeys.clear();
                    milestoneKeys = (prospectiveController.allAppointmentListModel.value.allAppointmentList ?? [])
                        .map(
                          (m) => MilestoneKey(
                            key: GlobalKey(),
                            containerKey: GlobalKey(),
                          ),
                        )
                        .toList();
                  });
                });
              });
            }),
      ],
      elevation: 8.0,
    );
  }

  //  Widget button({required String text, required int index,required VoidCallback ontap}) {
  //   return InkWell(
  //     splashColor: Colors.cyanAccent,
  //     onTap:ontap,
  //     //     () {
  //     //   setState(() {
  //     //     _selectedValueIndex = index;
  //     //   });
  //     // },
  //     child: Container(
  //       padding: const EdgeInsets.all(12),
  //       color: index == _selectedValueIndex ? Colors.blue : Colors.white,
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           color: index == _selectedValueIndex ? Colors.white : Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Future showBookAppointmentDialog(var isEditAppointment, String appointmentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        width: ConstantClass.fullWidth(context),
                        child: prospectiveController.loadingBookAppointment.isTrue
                            ? const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: LoadingSpinner(),
                                ))
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Book an Appointment',
                                    style: text18Black,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(children: [
                                    GestureDetector(
                                      onTap: () {
                                        _selectDate1(startDateController, true);
                                      },
                                      child: TextFormField(
                                        controller: startDateController,
                                        style: kText14SemiBoldBlack,
                                        decoration: const InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red),
                                            ),
                                            enabled: false,
                                            fillColor: Colors.white,
                                            labelText: "Start",
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: colorAppMain),
                                            ),
                                            counterText: "",
                                            hintText: "Select Date",
                                            labelStyle: kText14SemiBoldGrey,
                                            errorStyle: kText12SemiBoldRed,
                                            hintStyle: kText14SemiBoldGrey),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectDate1(endDateController, false);
                                      },
                                      child: TextFormField(
                                        controller: endDateController,
                                        style: kText14SemiBoldBlack,
                                        decoration: const InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.red),
                                            ),
                                            enabled: false,
                                            fillColor: Colors.white,
                                            labelText: "End",
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: colorAppMain),
                                            ),
                                            counterText: "",
                                            hintText: "Select Date",
                                            labelStyle: kText14SemiBoldGrey,
                                            errorStyle: kText12SemiBoldRed,
                                            hintStyle: kText14SemiBoldGrey),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                  ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Medium',
                                    style: textDialogbutton.merge(const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w200, fontSize: 14)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      ...List.generate(
                                          buttonTextMedium.length,
                                          (index) => Expanded(
                                                child: InkWell(
                                                  splashColor: Colors.cyanAccent,
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedMediumValueIndex = index;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 8.h),
                                                    color: index == _selectedMediumValueIndex ? Colors.blue : Colors.white,
                                                    child: Center(
                                                      child: Text(buttonTextMedium[index],
                                                          style: textDialogbutton.merge(
                                                            TextStyle(
                                                                color: index == _selectedMediumValueIndex ? Colors.white : Colors.black,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 14),
                                                          )
                                                          // style: TextStyle(
                                                          //   color: index == _selectedMediumValueIndex ? Colors.white : Colors.black,
                                                          // ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Language',
                                    style: textDialogbutton.merge(const TextStyle(color: colorGreyDark, fontWeight: FontWeight.w200, fontSize: 14)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      ...List.generate(
                                          buttonTextLanguage.length,
                                          (index) => Expanded(
                                                child: InkWell(
                                                  splashColor: Colors.cyanAccent,
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedLanguageValueIndex = index;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 8.h),
                                                    color: index == _selectedLanguageValueIndex ? Colors.blue : Colors.white,
                                                    child: Center(
                                                      child: Text(buttonTextLanguage[index],
                                                          style: textDialogbutton.merge(
                                                            TextStyle(
                                                                color: index == _selectedLanguageValueIndex ? Colors.white : Colors.black,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 14),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              )
                                          //         button(
                                          //   index: index,
                                          //   text: buttonText[index],ontap: (){
                                          //         setState(() {
                                          //           print('call OnTap');
                                          //           _selectedValueIndex = index;
                                          //         });
                                          //     }
                                          // ),
                                          )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  isEditAppointment
                                      ? const SizedBox()
                                      : TextFormField(
                                          controller: prospectEmailController,
                                          style: kText14SemiBoldBlack,
                                          decoration: const InputDecoration(
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.red),
                                              ),
                                              fillColor: Colors.white,
                                              labelText: "Prospect Email",
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: colorAppMain),
                                              ),
                                              counterText: "",
                                              hintText: "Prospect Email",
                                              labelStyle: kText14SemiBoldGrey,
                                              errorStyle: kText12SemiBoldRed,
                                              hintStyle: kText14SemiBoldGrey),
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
                                            textStyle: const TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (startDateSelect == "" || startTimeSelect == "") {
                                                Fluttertoast.showToast(msg: "Please Select Start Date");
                                              } else if (endDateSelect == "" || endTimeSelect == "") {
                                                Fluttertoast.showToast(msg: "Please Select End Date");
                                              } else if (prospectEmailController.text == "") {
                                                Fluttertoast.showToast(msg: "Please Enter Email");
                                              } else {
                                                print(startDateSelect);
                                                print(startTimeSelect);
                                                if (isEditAppointment) {
                                                  if (appointmentId != "") {
                                                    prospectiveController
                                                        .editAppointment(
                                                      appointMentId: appointmentId,
                                                      startDate: startDateSelect,
                                                      startTime: startTimeSelect,
                                                      endDate: endDateSelect,
                                                      endTime: endTimeSelect,
                                                      language: buttonTextLanguage[_selectedLanguageValueIndex ?? 0],
                                                      medium: buttonTextMedium[_selectedMediumValueIndex ?? 0],
                                                    )
                                                        .then((value) {
                                                      if (value) {
                                                        Fluttertoast.showToast(msg: 'Edit Appointment Successfully');
                                                        Navigator.pop(context);
                                                        prospectiveController.getAppointmentList(contactId: widget.contectId).then((value) {
                                                          milestoneKeys.clear();
                                                          milestoneKeys =
                                                              (prospectiveController.allAppointmentListModel.value.allAppointmentList ?? [])
                                                                  .map(
                                                                    (m) => MilestoneKey(
                                                                      key: GlobalKey(),
                                                                      containerKey: GlobalKey(),
                                                                    ),
                                                                  )
                                                                  .toList();
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(msg: 'Something Wrong');
                                                      }
                                                    });
                                                  } else {
                                                    Fluttertoast.showToast(msg: 'Something Wrong');
                                                  }
                                                } else {
                                                  prospectiveController
                                                      .bookAppointment(
                                                          contact_id: widget.contectId,
                                                          start_date: startDateSelect,
                                                          start_time: startTimeSelect,
                                                          end_date: endDateSelect,
                                                          end_time: endTimeSelect,
                                                          language: buttonTextLanguage[_selectedLanguageValueIndex ?? 0],
                                                          medium: buttonTextMedium[_selectedMediumValueIndex ?? 0],
                                                          prospect_email: prospectEmailController.text)
                                                      .then((value) async {
                                                    if (value == "inactive") {
                                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      prefs.setBool(logInKey, true);
                                                      prefs.setString(userIdKey, '');
                                                      authController.hideNav.value = true;
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstHomeScreen()));
                                                      Fluttertoast.showToast(msg: 'You are Blocked From Admin');
                                                    } else {
                                                      Fluttertoast.showToast(msg: 'Book Appointment Successfully');
                                                      Navigator.pop(context);
                                                      appointmentStatus = 'Scheduled';
                                                      prospectiveController
                                                          .statusUpdate(contactId: widget.contectId, cStatus: 'Scheduled')
                                                          .then((value) {
                                                        appointmentStatus = 'Scheduled';
                                                      });
                                                      prospectiveController.getAppointmentList(contactId: widget.contectId).then((value) {
                                                        milestoneKeys.clear();
                                                        milestoneKeys = (prospectiveController.allAppointmentListModel.value.allAppointmentList ?? [])
                                                            .map(
                                                              (m) => MilestoneKey(
                                                                key: GlobalKey(),
                                                                containerKey: GlobalKey(),
                                                              ),
                                                            )
                                                            .toList();
                                                      });
                                                    }
                                                  });
                                                }
                                                // print(
                                                //"ContectId---${widget.contectId}");
                                                // print("userId---${userId}");
                                                // print(
                                                //     "start_date---${startDateSelect}");
                                                // print(
                                                //     "start_Time---${startTimeSelect}");
                                                // print("End_Time---${endTimeSelect}");
                                                // print("End_date---${endDateSelect}");
                                                // print(
                                                //     "medium---${buttonTextMedium[_selectedMediumValueIndex ?? 0]}");
                                                // print(
                                                //     "language---${buttonTextLanguage[_selectedLanguageValueIndex ?? 0]}");
                                                // print(
                                                //     "prospect_email---${prospectEmailController.text}");
                                              }

                                              // Navigator.pop(context);
                                              // prospectiveController.setStatsData(
                                              //     contectId: widget.contectId,
                                              //     married: selectedValueMarried,
                                              //     has_cutco: selectedHasSolarExValue,
                                              //     bought_from_me: selectedboughtValue,
                                              //     age: selectedAgeValue,
                                              //     homeowner: selectedHomeownerValue);
                                            });
                                          },
                                          child: Text('Save'.toUpperCase(), style: textStrBtn),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  Future showSetStatusDialog() {
    prospectiveController.getStatusList().then((value) {
      if (prospectiveController.statusListModel.value.statusList != null) {
        var findIndexofStatus =
            prospectiveController.statusListModel.value.statusList!.indexWhere((prod) => prod.status!.contains(appointmentStatus));

        if (findIndexofStatus != -1) {
          (prospectiveController.statusListModel.value.statusList ?? []).forEach((element) => element.isSelected = false);
          (prospectiveController.statusListModel.value.statusList ?? [])[findIndexofStatus].isSelected = true;
        }
      }
    });
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      width: ConstantClass.fullWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Status',
                            style: text18Black,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Selecting a new status will any existing task and create new task accordingly.',
                            style: text14Black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 350.0, // Change as per your requirement
                              width: 350.0, // Change as per your requirement
                              child: Obx(
                                () => prospectiveController.loadingStatusList.isTrue
                                    ? const Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: LoadingSpinner(),
                                        ))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: (prospectiveController.statusListModel.value.statusList ?? []).length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  (prospectiveController.statusListModel.value.statusList ?? [])
                                                      .forEach((element) => element.isSelected = false);
                                                  (prospectiveController.statusListModel.value.statusList ?? [])[index].isSelected = true;
                                                  appointmentStatus =
                                                      (prospectiveController.statusListModel.value.statusList ?? [])[index].status.toString();
                                                });
                                              },
                                              child: RadioItem((prospectiveController.statusListModel.value.statusList ?? [])[index]));
                                        },
                                      ),
                              )),
                          const SizedBox(
                            height: 20,
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
                                    textStyle: const TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      prospectiveController
                                          .statusUpdate(contactId: widget.contectId, cStatus: appointmentStatus)
                                          .then((value) => Navigator.pop(context));
                                    });
                                  },
                                  child: Text('Save'.toUpperCase(), style: textStrBtn),
                                ),
                              ),
                            ],
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

  Future textMessageDialog() {
    prospectiveController.getMessageList();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      width: ConstantClass.fullWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Choose Message Type',
                            style: text18Black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 310.0.h, // Change as per your requirement
                              width: 300.0.w, // Change as per your requirement
                              child: Obx(
                                () => prospectiveController.loadingMessageList.isTrue
                                    ? const Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: LoadingSpinner(),
                                        ))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: (prospectiveController.messageListModel.value.messageList ?? []).length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () {
                                                prospectiveController
                                                    .getMessageContain(
                                                        textId: prospectiveController.messageListModel.value.messageList![index].id ?? "0",
                                                        contectId: widget.contectId)
                                                    .then((value) {
                                                  if ((prospectiveController.messageContainModel.value.response ?? "").isNotEmpty) {
                                                    sendTextMessage(prospectiveController.messageContainModel.value.response ?? "");
                                                  }
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(14.0),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            // prospectiveController
                                                            //     .getMessageContain(
                                                            //         textId: prospectiveController
                                                            //                 .messageListModel
                                                            //                 .value
                                                            //                 .messageList![
                                                            //                     index]
                                                            //                 .id ??
                                                            //             "0",
                                                            //         contectId:
                                                            //             widget
                                                            //                 .contectId)
                                                            //     .then((value) {
                                                            //   if ((prospectiveController
                                                            //               .messageContainModel
                                                            //               .value
                                                            //               .response ??
                                                            //           "")
                                                            //       .isNotEmpty) {
                                                            //     sendTextMessage(
                                                            //         prospectiveController
                                                            //                 .messageContainModel
                                                            //                 .value
                                                            //                 .response ??
                                                            //             "");
                                                            //   }
                                                            // });
                                                          },
                                                          child: const Icon(
                                                            Icons.message,
                                                            color: drawertestColor,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Text(
                                                          prospectiveController.messageListModel.value.messageList![index].mesgType ?? "",
                                                          style: text14BlackBold.merge(const TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black,
                                                            overflow: TextOverflow.ellipsis,
                                                            fontSize: 14.0,
                                                          )),
                                                        ),
                                                        const Spacer(),
                                                        const Icon(
                                                          Icons.error_outline_sharp,
                                                          color: kPrimaryDarkColor,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(
                                                    color: colorGreyDark,
                                                    height: 1.5,
                                                  ),
                                                ],
                                              )
                                              // RadioItem(
                                              //     (prospectiveController
                                              //         .messageListModel
                                              //         .value
                                              //         .statusList ??
                                              //         [])[index])
                                              );
                                        },
                                      ),
                              )),
                          const SizedBox(
                            height: 20,
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
                            ],
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

  sendTextMessage(String messageContaint) async {
    if (Platform.isAndroid) {
      String uri = 'sms:${prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? ""}?body=$messageContaint';
      if (await launchUrl(Uri.parse(uri))) {
        // await launchUrl(Uri.parse(uri));
      }
    } else {
      String uri = 'sms:${prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? ""}&body=$messageContaint';
      if (await launchUrl(Uri.parse(uri))) {
        // await launchUrl(Uri.parse(uri));
      }
    }
  }

  DateTime dateTime = DateTime.now();
  var startDateSelect = "";
  var schdualeDate = "";
  var startTimeSelect = "";
  var schdualeTime = "";
  var endTimeSelect = "";
  var endDateSelect = "";

  Future<void> _selectDate1(TextEditingController controller, var isStartDate) async {
    var datePicked = await showDatePicker(
      // context,
      //itemTextStyle: kText16SemiBoldBlack,
      // textColor: colorAppMain,
      confirmText: 'Ok',
      // initialDate: DateTime(DateTime.now().year),
      // firstDate: DateTime.now(),
      // lastDate: DateTime(DateTime.now().year + 2),

      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      // dateFormat: "dd-MMMM-yyyy",
      // locale: DateTimePickerLocale.en_us,
      context: context,
    );
    if (datePicked != null) {
      dateTime = datePicked;
      print("Start Date====${datePicked.day}");
      print("Start Date====${datePicked.month}");
      print("Start Date====${datePicked.year}");
      if (isStartDate) {
        startDateSelect = "${datePicked.year}-${datePicked.month}-${datePicked.day}";
        schdualeDate = "${datePicked.year}-${datePicked.month}-${datePicked.day}";
      } else {
        endDateSelect = "${datePicked.year}-${datePicked.month}-${datePicked.day}";
      }

      _selectTime(context, controller, isStartDate);
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  Future _selectTime(BuildContext context, TextEditingController controller, var isStartDate) async {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: childWidget!,
          );
        }).then((dynamic value) {
      if (value != null && value != selectedTime) {
        setState(() {
          String formattedDate = DateFormat('MMM d yyyy').format(dateTime);
          if (isStartDate) {
            startTimeSelect = value.format(context).toString();
            schdualeTime = value.format(context).toString();
          } else {
            endTimeSelect = value.format(context).toString();
          }

          controller.text = formattedDate + ' ' + value.format(context).toString();
        });
      }
    });
  }

  void resetBookApponintmentData() {
    startDateController.text = "";
    endDateController.text = "";
    prospectEmailController.text = "";
    startDateSelect = "";
    startTimeSelect = "";
    endTimeSelect = "";
    endDateSelect = "";
    _selectedLanguageValueIndex = 0;
    _selectedMediumValueIndex = 0;
  }

  Future showCallDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            //this right here
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  width: ConstantClass.fullWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Record What Happened',
                        style: text18Black,
                      ),
                      // const Text(
                      //   'with Aaron Price',
                      //   style: text14grey,
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Column(children: [
                          _createListitem(
                              isAssetsIcon: false,
                              text: 'Booked Appointment',
                              onTap: () {
                                setState(() {
                                  resetBookApponintmentData();
                                  showBookAppointmentDialog(false, "");
                                });
                              },
                              icondata: Icons.calendar_today),
                          _createListitem(
                              isAssetsIcon: false,
                              text: 'Scheduled Callback',
                              onTap: () {
                                setState(() {
                                  prospectiveController.getSchedule(contectId: widget.contectId).then((value) {
                                    if (prospectiveController.getScheduleModel.value.message == "Found") {
                                      dateAndTimeController.text = DateFormat('MMM d yyyy')
                                              .format(DateTime.parse(((prospectiveController.getScheduleModel.value.scheduleData?.date ?? "")))) +
                                          " " +
                                          (prospectiveController.getScheduleModel.value.scheduleData?.time ?? "");
                                      schdualeDate = prospectiveController.getScheduleModel.value.scheduleData?.date ?? "";
                                      schdualeTime = prospectiveController.getScheduleModel.value.scheduleData?.time ?? "";
                                      bool notiFyme = prospectiveController.getScheduleModel.value.scheduleData?.notifyMe?.toLowerCase() == 'true';

                                      prospectiveController.notifyScheduleDate.value = notiFyme ? true : false;
                                    }
                                    showScheduleCallBackDialog();
                                  });
                                  // showScheduleCallBackDialog();
                                });
                              },
                              icondata: Icons.refresh),
                          _createListitem(
                              isAssetsIcon: false,
                              text: "Didn't Answer",
                              onTap: () {
                                Navigator.pop(context);
                              },
                              isAnswer: true,
                              icondata: Icons.phone_missed),
                          _createListitem(
                              isAssetsIcon: false,
                              text: 'Wrong Number',
                              onTap: () {
                                showWrongNumberDialog();
                              },
                              icondata: Icons.mobile_off),
                          _createListitem(
                              isAssetsIcon: false,
                              text: 'Declined to Meet',
                              onTap: () {
                                showDeclinedMeetDialog();
                              },
                              icondata: Icons.close),
                          _createListitem(
                              isAssetsIcon: false,
                              text: 'Something Else',
                              onTap: () {
                                Navigator.pop(context);
                              },
                              icondata: Icons.more_horiz),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "didn't make call".toUpperCase(),
                            style: textDialogbutton,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _createListitem(
      {required String text,
      GestureTapCallback? onTap,
      String? iconName,
      var isAssetsIcon = false,
      IconData? icondata,
      var isAnswer = false,
      var isColorBlue = false}) {
    return ListTile(
      title: !isAnswer
          ? Row(
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
                              : Icon(icondata, color: isColorBlue ? kPrimaryColor : Colors.black),
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
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      text,
                      style: text16BlackN,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right, color: Colors.black),
              ],
            )
          : Row(
              children: [
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
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            text,
                            style: text16BlackN,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Left a voicemail?",
                            style: text14grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDidAnswerDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kPrimaryDarkColor, //                   <--- border color
                        width: 2.0,
                      ),
                    ),
                    child: const Text('Yes', style: textDialogbutton),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showDidAnswerDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kPrimaryDarkColor, //                   <--- border color
                        width: 2.0,
                      ),
                    ),
                    child: const Text(' No ', style: textDialogbutton),
                  ),
                ),
                // const Icon(Icons.keyboard_arrow_right, color: Colors.black),
              ],
            ),
      onTap: onTap,
    );
  }

  Future showScheduleCallBackDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            //this right here
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  width: ConstantClass.fullWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Schedule a Callback',
                        style: text18Black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(children: [
                          GestureDetector(
                            onTap: () {
                              _selectDate1(dateAndTimeController, true);
                            },
                            child: TextFormField(
                              controller: dateAndTimeController,
                              style: kText14SemiBoldBlack,
                              enabled: false,
                              decoration: const InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  fillColor: Colors.white,
                                  labelText: "Select Date and Time",
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  counterText: "",
                                  hintText: "hintText",
                                  labelStyle: kText14SemiBoldGrey,
                                  errorStyle: kText12SemiBoldRed,
                                  hintStyle: kText14SemiBoldGrey),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          // CheckboxListTile(
                          //   title: const Text('Animate Slowly'),
                          //   value: notify,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       notify = !notify;
                          //     });
                          //   },
                          //   secondary: const Icon(Icons.hourglass_empty),
                          // ),
                          Obx(
                            () => SizedBox(
                              child: Checkbox(
                                  value: prospectiveController.notifyScheduleDate.value,
                                  onChanged: (value) {
                                    setState(() {
                                      prospectiveController.notifyScheduleDate.value = value ?? false;
                                    });
                                  }),

                              // CheckboxListTile(
                              //   title: Text("text"),
                              //   value: prospectiveController.notifyScheduleDate.value,
                              //   onChanged: (val) {
                              //     setState(() {
                              //       prospectiveController.notifyScheduleDate.value = val??false;
                              //     });
                              //   },
                              // ),
                            ),
                          ),
                          const Flexible(
                            child: Text(
                              "Notify me when this time passes",
                              style: text14Black,
                            ),
                          ),
                          // Checkbox(
                          //     value: notify?true:false,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         notify = value!;
                          //         print("VAl===$notify");
                          //       });
                          //     }),
                          // const Text(
                          //   "Notify me when this time passes",
                          //   style: text14Black,
                          // )
                        ],
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
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                prospectiveController
                                    .setScheduleCallBack(
                                        contectId: widget.contectId,
                                        notifyMe: prospectiveController.notifyScheduleDate.value.toString(),
                                        date: schdualeDate,
                                        time: schdualeTime)
                                    .then((value) async {
                                  if (value == "inactive") {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setBool(logInKey, true);
                                    prefs.setString(userIdKey, '');
                                    authController.hideNav.value = true;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstHomeScreen()));
                                    Fluttertoast.showToast(msg: 'You are Blocked From Admin');
                                  } else {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Text('Save'.toUpperCase(), style: textStrBtn),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future showDidAnswerDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            //this right here
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  width: ConstantClass.fullWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Now What?',
                        style: text18Black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          children: [
                            _createListitem(
                                isAssetsIcon: false,
                                text: 'Redial',
                                onTap: () {
                                  setState(() {
                                    if (prospectiveController.prospectiveDetails.value.data?.mobile.toString() != null) {
                                      print("Call RRRR 11");
                                      _makePhoneCall(prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? "0");
                                    }
                                  });
                                },
                                icondata: Icons.call,
                                isColorBlue: true),
                            const Divider(
                              color: colorGreyDark,
                              height: 2,
                            ),
                            _createListitem(
                                isAssetsIcon: false,
                                text: 'Text',
                                onTap: () {
                                  setState(() {
                                    sendTextMessage("Test Message");
                                  });
                                },
                                icondata: Icons.message,
                                isColorBlue: true),
                            const Divider(
                              color: colorGreyDark,
                              height: 2,
                            ),
                            _createListitem(
                                isAssetsIcon: false,
                                text: 'Return to Prospect',
                                onTap: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                icondata: Icons.arrow_back,
                                isColorBlue: true),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text('Nevermind'.toUpperCase(), style: textBtnBlue),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future showWrongNumberDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            //this right here
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  width: ConstantClass.fullWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Are you sure?',
                        style: text18Black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'This will remove this task and stash this phone number into a note for future reference.',
                        style: text14Black,
                      ),
                      const SizedBox(
                        height: 10,
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
                                "nevermind".toUpperCase(),
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
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Stash'.toUpperCase(), style: textStrBtn),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future showDeclinedMeetDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            //this right here
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  width: ConstantClass.fullWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Now What?',
                        style: text18Black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "If you think there's still a chance that they'll book an appointment with you. consider following up with them at a later date instead.",
                        style: text14Black.merge(const TextStyle(height: 1.5)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          children: [
                            _createListitem(
                                isAssetsIcon: false,
                                text: 'Mark "Decline"',
                                onTap: () {
                                  setState(() {});
                                },
                                icondata: Icons.block,
                                isColorBlue: true),
                            const Divider(
                              color: colorGreyDark,
                              height: 2,
                            ),
                            _createListitem(
                                isAssetsIcon: false,
                                text: 'Schedule Callback',
                                onTap: () {
                                  setState(() {});
                                },
                                icondata: Icons.refresh,
                                isColorBlue: true),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'.toUpperCase(), style: textBtnBlue),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // await launchUrl(launchUri);
    if (await launchUrl(launchUri)) {
      // await launchUrl(launchUri);
    } else {
      ConstantClass.toastMessage(toastMessage: "Could not launch $phoneNumber");
      // throw 'Could not launch ${Uri.parse("tel://987-987-4562")}';
    }
  }

  void callDetailsAPIS() {
    prospectiveController.getProspectiveDetails(contectId: widget.contectId).then(
      (value) {
        setState(() {
          selectedValueMarried = prospectiveController.prospectiveDetails.value.data?.married ?? 'No';
          selectedHomeownerValue = prospectiveController.prospectiveDetails.value.data?.homeowner ?? 'No';
          selectedHasSolarExValue = prospectiveController.prospectiveDetails.value.data?.hasCutco ?? 'No';
          selectedboughtValue = prospectiveController.prospectiveDetails.value.data?.boughtFromMe ?? 'Powur';
          selectedAgeValue = prospectiveController.prospectiveDetails.value.data?.age ?? '29-64';
          notesController.text = prospectiveController.prospectiveDetails.value.data?.note ?? "";
          appointmentStatus = prospectiveController.prospectiveDetails.value.data?.status ?? "Added";
          if ((prospectiveController.prospectiveDetails.value.data?.meetingCode ?? '').isNotEmpty) {
            prospectiveController.getRefferalUserList(
                userId: userId, meetingCode: prospectiveController.prospectiveDetails.value.data?.meetingCode ?? '0');
          }
          prospectiveController.getAppointmentList(contactId: widget.contectId).then((value) {
            milestoneKeys.clear();
            milestoneKeys = (prospectiveController.allAppointmentListModel.value.allAppointmentList ?? [])
                .map(
                  (m) => MilestoneKey(
                    key: GlobalKey(),
                    containerKey: GlobalKey(),
                  ),
                )
                .toList();
          });
          prospectiveController.getAllNotes(contectId: widget.contectId);
        });
      },
    );
  }
}

class PopUp extends StatefulWidget {
  PopUp({super.key, required this.mobileNumber, required this.onTapCall});

  String mobileNumber;
  VoidCallback onTapCall;

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
                    onPressed: widget.onTapCall,
                    //     () async {
                    //   showCallDialog();
                    // },
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(height: 24, width: 24, child: Image.asset(iconphone)),
                        ),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        Text(
                          widget.mobileNumber,
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RadioItem extends StatefulWidget {
  final ListItems _item;

  RadioItem(this._item);

  @override
  State<RadioItem> createState() => _RadioItemState();
}

class _RadioItemState extends State<RadioItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Text(widget._item.status.toString(),
                style: text14BlackBold.merge(TextStyle(color: widget._item.isSelected ?? false ? kPrimaryDarkColor : drawertestColor))),
          ),
          const Spacer(),
          Center(
              child: Icon(
            widget._item.isSelected ?? false ? Icons.done : Icons.done,
            color: widget._item.isSelected ?? false ? kPrimaryDarkColor : kPrimaryLightColor,
          )),
        ],
      ),
    );
  }
}
