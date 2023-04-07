import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarex/first_phase/FirstHomeScreen/firstHomeScreen.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/second_phase/controllers/prospective_controllers.dart';
import 'package:solarex/second_phase/controllers/schedule_controllers.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:solarex/utils/loading_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../../utils/constants.dart';

class PhoneDetailsScreen extends StatefulWidget {
  const PhoneDetailsScreen({Key? key, required this.contectId, required this.contectName, required this.contectNumber})
      : super(
          key: key,
        );
  final contectId;
  final contectName;
  final contectNumber;

  @override
  State<PhoneDetailsScreen> createState() => _PhoneDetailsScreenState();
}

class _PhoneDetailsScreenState extends State<PhoneDetailsScreen> {
  final scheduleController = Get.put(ScheduleController());
  final startDateController = TextEditingController(text: "Select Date");
  final endDateController = TextEditingController(text: "Select Date");
  final dateAndTimeController = TextEditingController(text: "Select Date");
  final notesController = TextEditingController(text: "");
  final prospectEmailController = TextEditingController(text: "");
  final prospectiveController = Get.put(ProspectiveController());
  int? _selectedMediumValueIndex = 0;
  int? _selectedLanguageValueIndex = 0;
  List<String> buttonTextMedium = ["VIRTUAL", "IN-PERSON"];
  List<String> buttonTextLanguage = ["ENGLISH", "ESPANOL", "FRANCAIS"];
  final authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            "Task",
            style: textHeading,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              width: ConstantClass.fullWidth(context),
              height: ConstantClass.fullHeight(context),
              child: Container(
                width: ConstantClass.fullWidth(context),
                // height: ConstantClass.fullHeight(context),
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 70),
                child: Column(children: [
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
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: ConstantClass.fullWidth(context) * 0.80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.contectName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  widget.contectNumber,
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
                        const Spacer(),

                        // SizedBox(
                        //   height: 25,
                        //   child: Checkbox(
                        //       value: originalitem[index].isCheck,
                        //       onChanged: (value) {
                        //         setState(() {
                        //           originalitem[index].isCheck = value!;
                        //           if (originalitem[index].isCheck == true) {
                        //             contactNo++;
                        //             ConstantClass.selectedContactList.add(originalitem[index]);
                        //           } else {
                        //             contactNo--;
                        //             ConstantClass.selectedContactList.remove(originalitem[index]);
                        //           }
                        //         });
                        //       }),
                        // )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => PopUp(
                                  mobileNumber: prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? "",
                                  onTapCall: () {
                                    showCallDialog();
                                  }),
                            );
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
                            textMessageDialog();
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
                  SizedBox(height: 10.h),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
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
                      Column(children: [
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
                                      // hintText: "Enter REP Number",

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
                              prospectiveController.addNotesAPI(contectId: widget.contectId, note: notesController.text).then((value) {
                                if (value) {
                                  notesController.text = "";
                                  prospectiveController.getAllNotes(contectId: widget.contectId);
                                  Fluttertoast.showToast(msg: 'Note Add Sucessfully');
                                }
                              });
                            },
                            child: Text('Add Notes'.toUpperCase(), style: textStrBtn),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "History",
                          style: text16Black,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Obx(() => scheduleController.loadingAppointmentList.isTrue
                            ? const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: LoadingSpinner(),
                                ))
                            : (scheduleController.appointmentListbyDateModel.value.appointmentList ?? []).isEmpty
                                ? SizedBox(
                                    height: 50.h,
                                    child: const Center(
                                      child: Text(
                                        "There are no appointments scheduled",
                                        style: text14Black,
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      // alignment: WrapAlignment.center,
                                      runSpacing: 5,
                                      children: (scheduleController.appointmentListbyDateModel.value.appointmentList ?? [])
                                          .asMap()
                                          .map((i, appointmentItem) => MapEntry(
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
                                                  const Icon(
                                                    Icons.calendar_month_sharp,
                                                    color: kPrimaryDarkColor,
                                                  ),
                                                  const SizedBox(width: 14.0),
                                                  Text(
                                                      "${DateFormat('EEE, MMM dd').format(DateTime.parse(appointmentItem.startDate ?? ''))} @ ${appointmentItem.startTime}",
                                                      // 'Tue, Sep 6th @ 8:15 PM',
                                                      style: text14BlackBold),
                                                  // const Spacer(),
                                                  // GestureDetector(
                                                  //   onTap: () {},
                                                  //   child: const Icon(
                                                  //     Icons.more_horiz,
                                                  //     color: kPrimaryDarkColor,
                                                  //   ),
                                                  // ),
                                                ]),
                                              )))
                                          .values
                                          .toList(),
                                    ),
                                  )),
                      ],
                    ),
                  ),
                  // Obx(
                  //   () {
                  //     return prospectiveController.loadingNoteList.isTrue
                  //         ? const Align(
                  //             alignment: Alignment.center,
                  //             child: Padding(
                  //               padding: EdgeInsets.all(10.0),
                  //               child: LoadingSpinner(),
                  //             ))
                  //         : (prospectiveController.allNotesModel.value.allNotesList ?? []).isNotEmpty
                  //             ? Container(
                  //                 margin: const EdgeInsets.all(10),
                  //                 padding: const EdgeInsets.all(10),
                  //                 width: double.infinity,
                  //                 decoration:
                  //                     BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(5))),
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     const Text('Notes', style: text16Black),
                  //                     SizedBox(
                  //                       height: 20.h,
                  //                     ),
                  //                     SingleChildScrollView(
                  //                       scrollDirection: Axis.vertical,
                  //                       child: Wrap(
                  //                         direction: Axis.horizontal,
                  //                         // alignment: WrapAlignment.center,
                  //                         runSpacing: 5,
                  //                         children: (prospectiveController.allNotesModel.value.allNotesList ?? [])
                  //                             .asMap()
                  //                             .map((i, notesItem) => MapEntry(
                  //                                 i,
                  //                                 Container(
                  //                                   padding: const EdgeInsets.all(10.0),
                  //                                   decoration: BoxDecoration(
                  //                                     border: Border.all(
                  //                                         color: colorBoxDarkBackground1,
                  //                                         // Set border color
                  //                                         width: 3.0), // Set border width
                  //                                     borderRadius: const BorderRadius.all(Radius.circular(2.0)), // Set rounded corner radius
                  //                                     // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                  //                                   ),
                  //                                   child: Row(children: [
                  //                                     const SizedBox(width: 14.0),
                  //                                     Text(notesItem.note ?? "",
                  //                                         style: text14BlackBold.merge(const TextStyle(
                  //                                           overflow: TextOverflow.ellipsis,
                  //                                         ))),
                  //                                     const Spacer(),
                  //                                     GestureDetector(
                  //                                       onTap: () {
                  //                                         prospectiveController.deleteNotes(noteId: notesItem.noteId).then((value) {
                  //                                           prospectiveController.getAllNotes(contectId: widget.contectId);
                  //                                         });
                  //                                       },
                  //                                       child: const Icon(
                  //                                         Icons.delete,
                  //                                         color: kPrimaryDarkColor,
                  //                                       ),
                  //                                     ),
                  //                                   ]),
                  //                                 )))
                  //                             .values
                  //                             .toList(),
                  //
                  //                         // prospectiveController
                  //                         //     .allAppointmentListModel
                  //                         //     .value
                  //                         //     .allAppointmentList!
                  //                         //     .map(
                  //                         //       (appointmentItem) => Container(
                  //                         //         // key: milestoneKeys[],
                  //                         //         // key: Key(appointmentItem.meetingId.toString()),
                  //                         //         padding:
                  //                         //             const EdgeInsets.all(10.0),
                  //                         //         decoration: BoxDecoration(
                  //                         //           border: Border.all(
                  //                         //               color:
                  //                         //                   colorBoxDarkBackground1,
                  //                         //               // Set border color
                  //                         //               width:
                  //                         //                   3.0), // Set border width
                  //                         //           borderRadius: const BorderRadius
                  //                         //                   .all(
                  //                         //               Radius.circular(
                  //                         //                   2.0)), // Set rounded corner radius
                  //                         //           // boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))] // Make rounded corner of border
                  //                         //         ),
                  //                         //         child: Row(children: [
                  //                         //           const Icon(
                  //                         //             Icons.calendar_month_sharp,
                  //                         //             color: kPrimaryDarkColor,
                  //                         //           ),
                  //                         //           const SizedBox(width: 14.0),
                  //                         //           const Text(
                  //                         //               // DateFormat('EEE, MMM, dd').format(DateTime.parse(appointmentItem.startDate??'')),
                  //                         //               'Tue, Sep 6th @ 8:15 PM',
                  //                         //               style: text14BlackBold),
                  //                         //           const Spacer(),
                  //                         //           GestureDetector(
                  //                         //             onTap: () {
                  //                         //               _showPopupMenu(0);
                  //                         //             },
                  //                         //             child: const Icon(
                  //                         //               Icons.more_horiz,
                  //                         //               color: kPrimaryDarkColor,
                  //                         //             ),
                  //                         //           ),
                  //                         //         ]),
                  //                         //       ),
                  //                         //     )
                  //                         //     .toList(),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               )
                  //             : const SizedBox();
                  //   },
                  // )
                ]),
              ),
            ),
          ),
        ));
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
                                // Navigator.pop(context);
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
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryDarkColor, //                   <--- border color
                      width: 2.0,
                    ),
                  ),
                  child: const Text(' No ', style: textDialogbutton),
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
                      Column(children: [
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Obx(
                            () => SizedBox(
                              child: Checkbox(
                                  value: prospectiveController.notifyScheduleDate.value,
                                  onChanged: (value) {
                                    setState(() {
                                      prospectiveController.notifyScheduleDate.value = value ?? false;
                                    });
                                  }),
                            ),
                          ),
                          const Flexible(
                            child: Text(
                              "Notify me when this time passes",
                              style: text14Black,
                            ),
                          ),
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

  Future showBookAppointmentDialog(var isEditAppointment, String appointmentId) {
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
                                                    print('call OnTap$index');
                                                    print('call OnTap$_selectedMediumValueIndex');
                                                    _selectedMediumValueIndex = index;
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(12),
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
                                                    print('call OnTap$index');
                                                    print('call OnTap$_selectedLanguageValueIndex');
                                                    _selectedLanguageValueIndex = index;
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(12),
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
                                                }
                                                // if (value) {
                                                //                                         Fluttertoast.showToast(msg: 'Book Appointment Successfully');
                                                //                                         Navigator.pop(context);
                                                //                                       } else {
                                                //                                         Fluttertoast.showToast(msg: 'Something Wrong');
                                                //                                       }
                                              });
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
                );
              },
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // await launchUrl(launchUri);
    if (await launchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ConstantClass.toastMessage(toastMessage: "Could not launch $phoneNumber");
      // throw 'Could not launch ${Uri.parse("tel://987-987-4562")}';
    }
  }

  sendTextMessage(String messageContaint) async {
    if (Platform.isAndroid) {
      String uri = 'sms:${prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? ""}?body=$messageContaint';
      if (await launchUrl(Uri.parse(uri))) {
        await launchUrl(Uri.parse(uri));
      }
    } else {
      String uri = 'sms:${prospectiveController.prospectiveDetails.value.data?.mobile.toString() ?? ""}&body=$messageContaint';
      if (await launchUrl(Uri.parse(uri))) {
        await launchUrl(Uri.parse(uri));
      }
    }
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
