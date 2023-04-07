//=========
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solarex/second_phase/controllers/profile_controllers.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/loading_spinner.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import '../../controllers/prospective_controllers.dart';

class AllTaskScreen extends StatefulWidget {
  const AllTaskScreen({super.key});

  @override
  _AllTaskScreenState createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends State<AllTaskScreen> {
  final profileController = Get.put(ProfileController());
  final prospectiveController = Get.put(ProspectiveController());
  final dateAndTimeController = TextEditingController(text: "Select Date");
  var schdualeDate = "";
  var schdualeTime = "";
  DateTime dateTime = DateTime.now();
  final startDateController = TextEditingController(text: "Select Date");
  final endDateController = TextEditingController(text: "Select Date");
  final prospectEmailController = TextEditingController(text: "");
  var startDateSelect = "";
  var startTimeSelect = "";
  var endTimeSelect = "";
  var endDateSelect = "";
  int? _selectedMediumValueIndex = 0;
  int? _selectedLanguageValueIndex = 0;
  List<String> buttonTextMedium = ["VIRTUAL", "IN-PERSON"];
  List<String> buttonTextLanguage = ["ENGLISH", "ESPANOL", "FRANCAIS"];

  @override
  void initState() {
    super.initState();
    profileController.getAllTask();
  }

  @override
  void dispose() {
    super.dispose();
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
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     // setState(() {
            //     resetBookApponintmentData();
            //     showBookAppointmentDialog(false, "");
            //     // });
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20.w),
            //     child: const Icon(
            //       Icons.add,
            //       color: kPrimaryDarkColor,
            //     ),
            //   ),
            // )
          ],
          centerTitle: false,
          title: const Text(
            "Tasks",
            style: textHeading,
          ),
        ),
        body: SafeArea(
            child: Obx(
          () => profileController.loadingAllTask.isTrue || prospectiveController.loadingDeleteAppointment.isTrue
              ? const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: LoadingSpinner(),
                  ))
              : (profileController.allTaskListModel.value.allTaskList ?? []).isEmpty
                  ? const Center(
                      child: Text(
                      'List is Empty',
                      style: text18Black,
                    ))
                  : taskList(),
        )
            // Container(
            //   width: ConstantClass.fullWidth(context),
            //   height: ConstantClass.fullHeight(context),
            //   margin: EdgeInsets.symmetric(horizontal: 10.w),
            //   child: Column(
            //     children: [
            //
            //     ],
            //   ),
            // ),
            ));
  }

  Widget taskList() {
    return Container(
      margin: EdgeInsets.only(bottom: 50.h, right: 10.w, left: 10.w, top: 10.h),
      child: RefreshIndicator(
          color: Colors.white,
          onRefresh: () async {
            setState(() {
              profileController.getAllTask();
            });
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: profileController.allTaskListModel.value.allTaskList?.length,
            itemBuilder: (context, index) {
              var item = (profileController.allTaskListModel.value.allTaskList ?? [])[index];
              return Container(
                padding: EdgeInsets.all(10.w),
                margin: EdgeInsets.all(2.w),
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
                    Icons.calendar_today_outlined,
                    color: drawertestColor,
                  ),
                  const SizedBox(width: 14.0),
                  // Text("${DateFormat('EEE, MMM dd').format(DateTime.parse(appointmentItem.startDate ?? ''))} @ ${appointmentItem.startTime}",
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Book Appointment", style: text14BlackBold),
                      Text(item.name ?? "", style: text14Black),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        resetScheduleData();
                        if (item.contactId != null) {
                          profileController
                              .getScheduleByAppointment(contectId: item.contactId ?? "0", appointmentId: item.appointmentId ?? "0")
                              .then((value) {
                            showScheduleCallBackDialog(item.contactId ?? "0", item.appointmentId ?? "0");
                            if (profileController.getschedulebyappointment.value.message == "Found") {
                              dateAndTimeController.text = DateFormat('MMM d yyyy')
                                      .format(DateTime.parse(((profileController.getschedulebyappointment.value.scheduleData?.date ?? "")))) +
                                  " " +
                                  (profileController.getschedulebyappointment.value.scheduleData?.time ?? "");
                              schdualeDate = profileController.getschedulebyappointment.value.scheduleData?.date ?? "";
                              schdualeTime = profileController.getschedulebyappointment.value.scheduleData?.time ?? "";
                              bool notiFyme = profileController.getschedulebyappointment.value.scheduleData?.notifyMe?.toLowerCase() == 'true';

                              prospectiveController.notifyScheduleDate.value = notiFyme ? true : false;
                            }
                          });
                        }
                      });
                    },
                    child: const Icon(
                      Icons.edit_calendar,
                      color: drawertestColor,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (item.appointmentId != '') {
                          prospectiveController.deleteAppointment(appointmentId: item.appointmentId).then((value) {
                            profileController.allTaskListModel.value.allTaskList?.clear();
                            profileController.getAllTask();
                          });
                        }

                        // if (item.contactId != null) {
                        //   profileController
                        //       .getScheduleByAppointment(contectId: item.contactId ?? "0", appointmentId: item.appointmentId ?? "0")
                        //       .then((value) {
                        //     showScheduleCallBackDialog(item.contactId ?? "0", item.appointmentId ?? "0");
                        //     if (profileController.getschedulebyappointment.value.message == "Found") {
                        //       dateAndTimeController.text = DateFormat('MMM d yyyy')
                        //               .format(DateTime.parse(((profileController.getschedulebyappointment.value.scheduleData?.date ?? "")))) +
                        //           " " +
                        //           (profileController.getschedulebyappointment.value.scheduleData?.time ?? "");
                        //       schdualeDate = profileController.getschedulebyappointment.value.scheduleData?.date ?? "";
                        //       schdualeTime = profileController.getschedulebyappointment.value.scheduleData?.time ?? "";
                        //       bool notiFyme = profileController.getschedulebyappointment.value.scheduleData?.notifyMe?.toLowerCase() == 'true';
                        //
                        //       prospectiveController.notifyScheduleDate.value = notiFyme ? true : false;
                        //     }
                        //   });
                        // }
                      });
                    },
                    child: const Icon(
                      Icons.delete,
                      color: drawertestColor,
                    ),
                  ),
                ]),
              );
            },
          )),
    );
  }

  void resetScheduleData() {
    dateAndTimeController.text = "";
  }

  Future showScheduleCallBackDialog(String contectId, String appointmentId) {
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
                      Obx(() => profileController.loadinggetScheduleData.isTrue
                          ? const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: LoadingSpinner(),
                              ))
                          : Column(
                              children: [
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
                                          print("Save");
                                          profileController
                                              .setScheduleCallBack(
                                                  contectId: contectId,
                                                  notifyMe: prospectiveController.notifyScheduleDate.value.toString(),
                                                  date: schdualeDate,
                                                  time: schdualeTime,
                                                  appointmentId: appointmentId)
                                              .then((value) => Navigator.pop(context));
                                        },
                                        child: Text('Save'.toUpperCase(), style: textStrBtn),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _selectDate1(TextEditingController controller, var isStartDate) async {
    var datePicked = await showDatePicker(
      confirmText: 'Ok',
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
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
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
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
                                              } else {}
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
}
