import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/second_phase/controllers/prospective_controllers.dart';
import 'package:solarex/second_phase/controllers/schedule_controllers.dart';
import 'package:solarex/second_phase/models/milestoneKey.dart';
import 'package:solarex/second_phase/models/selectedTeamMemberModel.dart';
import 'package:solarex/second_phase/screens/Prospects/prospects_details.screen.dart';
import 'package:solarex/second_phase/screens/Schedule/goalset_screen.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/loading_spinner.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../first_phase/FirstHomeScreen/firstHomeScreen.dart';
import '../../../theme/colors.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MobileLoginScreen();
  }
}

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final scheduleController = Get.put(ScheduleController());
  final prospectiveController = Get.put(ProspectiveController());
  DateTime selectedDate = DateTime.now(); // TO tracking date
  int currentDateSelectedIndex = 0; //For Horizontal Date
  ScrollController scrollController = ScrollController(); //To Track Scroll of ListView
  List<String> listOfMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  // final prospectiveController = Get.put(ProspectiveController());
  var selectedDateforAPI = "";
  List<MilestoneKey> milestoneKeys = [];
  final startDateController = TextEditingController(text: "Select Date");
  final endDateController = TextEditingController(text: "Select Date");
  final prospectEmailController = TextEditingController(text: "");
  final authController = Get.put(AuthController());
  DateTime dateTime = DateTime.now();
  var startDateSelect = "";
  var schdualeDate = "";
  var startTimeSelect = "";
  var schdualeTime = "";
  var endTimeSelect = "";
  var endDateSelect = "";
  List<String> buttonTextMedium = ["VIRTUAL", "IN-PERSON"];
  List<String> buttonTextLanguage = ["ENGLISH", "ESPANOL", "FRANCAIS"];
  var _selectedLanguageValueIndex = 0;

  var _selectedMediumValueIndex = 0;
  final lastKey = GlobalKey();

  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  var startDate = '';
  var endDate = '';
  final kFirstDay = DateTime(DateTime.now().year, DateTime.now().month - 11, DateTime.now().day);
  final kLastDay = DateTime(DateTime.now().year, DateTime.now().month + 11, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    // checkContacts();

    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    scheduleController.getScheduleCounter();
    selectedDateforAPI = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    scheduleController.getAppointmentByDate(selectedDate: selectedDateforAPI).then((value) {
      milestoneKeys.clear();

      milestoneKeys = (scheduleController.appointmentListbyDateModel.value.appointmentList ?? [])
          .map(
            (m) => MilestoneKey(
              key: GlobalKey(),
              containerKey: GlobalKey(),
            ),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;

        setState(() {
          selectedDateforAPI = '${focusedDay.year}-${focusedDay.month}-${focusedDay.day}';

          scheduleController.getAppointmentByDate(selectedDate: selectedDateforAPI).then((value) {
            milestoneKeys.clear();

            milestoneKeys = (scheduleController.appointmentListbyDateModel.value.appointmentList ?? [])
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

      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const FirstHomeScreen()));
            // Navigator.canPop(context);
          },
        ),
        centerTitle: false,
        title: const Text(
          "Schedule",
          style: textHeading2,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: itemSchedule(
                                      icon: Icons.add,
                                      records:
                                          // "${scheduleController.appointmentListbyDateModel.value.appointmentList?.length.toString() ?? "0"}/${scheduleController.goal}",
                                          "${scheduleController.appointments.toString()}/${scheduleController.goal}",
                                      hint: "Booked/Goal")),
                              Expanded(
                                  child: itemSchedule(
                                      icon: Icons.call,
                                      records: scheduleController.scheduleCounterModel.value.scheduleData?.callCount.toString() ?? "0",
                                      hint: "Calls")),
                              Expanded(
                                  child: itemSchedule(
                                      icon: Icons.message,
                                      records: scheduleController.scheduleCounterModel.value.scheduleData?.textCount.toString() ?? "0",
                                      hint: "Texts")),
                              Expanded(
                                  child: itemSchedule(
                                      icon: Icons.person,
                                      records: scheduleController.scheduleCounterModel.value.scheduleData?.referralCount.toString() ?? "0",
                                      hint: "Referrals")),
                            ],
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      const Expanded(
                          child: Text("Breakdown", style: text16Black
                              // TextStyle(
                              //     color: Colors.white,
                              //     fontWeight: FontWeight.w600),
                              )),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return GoalSetScreen(
                                  startDate: startDate,
                                  endDate: endDate,
                                );
                              },
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                TableCalendar<Event>(
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                  shouldFillViewport: false,
                  availableGestures: AvailableGestures.none,
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      if (day.weekday == DateTime.monday) {
                        startDate = DateFormat('yyyy-MM-dd').format(day).toString();
                      }
                      if (day.weekday == DateTime.sunday) {
                        endDate = DateFormat('yyyy-MM-dd').format(day).toString();

                        final text = DateFormat.E().format(day);
                        return Center(
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      return Center(
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                  daysOfWeekHeight: 30.h,
                  rowHeight: 54.h,
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: _onDaySelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),

                // Container(
                //     height: 100.h,
                //     margin: const EdgeInsets.all(10),
                //     padding: const EdgeInsets.all(10),
                //     decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(5))),
                //     child: Container(
                //         child: ListView.separated(
                //       separatorBuilder: (BuildContext context, int index) {
                //         return const SizedBox(width: 10);
                //       },
                //       itemCount: 730,
                //       controller: scrollController,
                //       scrollDirection: Axis.horizontal,
                //       itemBuilder: (BuildContext context, int index) {
                //         return InkWell(
                //           onTap: () {
                //             setState(() {
                //               currentDateSelectedIndex = index;
                //               selectedDate = DateTime.now().add(Duration(days: index));
                //               selectedDateforAPI = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                //
                //               scheduleController.getAppointmentByDate(selectedDate: selectedDateforAPI).then((value) {
                //                 milestoneKeys.clear();
                //                 milestoneKeys = (scheduleController.appointmentListbyDateModel.value.appointmentList ?? [])
                //                     .map(
                //                       (m) => MilestoneKey(
                //                         key: GlobalKey(),
                //                         containerKey: GlobalKey(),
                //                       ),
                //                     )
                //                     .toList();
                //               });
                //             });
                //           },
                //           child: Container(
                //             // height: 100.h,
                //             width: 50.w,
                //             alignment: Alignment.center,
                //             decoration: BoxDecoration(
                //               border: Border.all(color: currentDateSelectedIndex == index ? Colors.blueAccent : Colors.white),
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   listOfMonths[DateTime.now().add(Duration(days: index)).month - 1].toString(),
                //                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey),
                //                 ),
                //                 Text(
                //                   listOfDays[DateTime.now().add(Duration(days: index)).weekday - 1].toString(),
                //                   style: const TextStyle(fontSize: 16, color: Colors.grey),
                //                 ),
                //                 const SizedBox(
                //                   height: 5,
                //                 ),
                //                 Text(
                //                   DateTime.now().add(Duration(days: index)).day.toString(),
                //                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.grey),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //     ))),

                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Appointments",
                        style: text16Black,
                      ),
                      SizedBox(
                        height: 30.h,
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return ProspectsDetailsScreen(
                                                            contectId: appointmentItem.contactId,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Row(children: [
                                                  const Icon(
                                                    Icons.calendar_month_sharp,
                                                    color: kPrimaryDarkColor,
                                                  ),
                                                  const SizedBox(width: 14.0),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(appointmentItem.name ?? "",
                                                          // 'Tue, Sep 6th @ 8:15 PM',
                                                          style: text14BlackBold),
                                                      SizedBox(height: 4.h),
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
                                                  // Text(
                                                  //     "${DateFormat('EEE, MMM dd').format(DateTime.parse(appointmentItem.startDate ?? ''))} @ ${appointmentItem.startTime}",
                                                  //     // 'Tue, Sep 6th @ 8:15 PM',
                                                  //     style: text14BlackBold),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showPopupMenu(appointmentItem.id ?? "", milestoneKeys[i].containerKey,
                                                          ((appointmentItem.mark) ?? []).toString());
                                                    },
                                                    child: const Icon(
                                                      Icons.more_horiz,
                                                      color: kPrimaryDarkColor,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            )))
                                        .values
                                        .toList(),
                                  ),
                                )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            setState(() {
              if (scheduleController.appointmentListbyDateModel.value.appointmentList != null) {
                var findIndexofStatus =
                    (scheduleController.appointmentListbyDateModel.value.appointmentList ?? []).indexWhere((prod) => (prod.id ?? "").contains(id));

                if (findIndexofStatus != -1) {
                  startDateController.text =
                      "${DateFormat('MMM d yyyy').format(DateTime.parse(((scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].startDate ?? ""))))} ${(scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].startTime ?? "")}";

                  endDateController.text = DateFormat('MMM d yyyy').format(
                          DateTime.parse((scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].endDate ?? ""))) +
                      " " +
                      (scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].endTime ?? "");

                  prospectEmailController.text =
                      scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].prospectEmail ?? "";
                  startDateSelect = scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].startDate ?? "";
                  startTimeSelect = scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].startTime ?? "";
                  endTimeSelect = scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].endTime ?? "";
                  endDateSelect = scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].endDate ?? "";
                  if (scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].language == "ENGLISH") {
                    _selectedLanguageValueIndex = 0;
                  } else if (scheduleController.appointmentListbyDateModel.value.appointmentList?[findIndexofStatus].language == "ESPANOL") {
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
                  scheduleController.getAppointmentByDate(selectedDate: selectedDateforAPI).then((value) {
                    milestoneKeys.clear();

                    milestoneKeys = (scheduleController.appointmentListbyDateModel.value.appointmentList ?? [])
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
                  scheduleController.getAppointmentByDate(selectedDate: selectedDateforAPI).then((value) {
                    milestoneKeys.clear();

                    milestoneKeys = (scheduleController.appointmentListbyDateModel.value.appointmentList ?? [])
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

  Widget itemSchedule({required IconData icon, required String records, required String hint}) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.black,
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(records, style: text30Black
            // const TextStyle(color: Colors.white, fontSize: 28),
            ),
        SizedBox(
          height: 10.h,
        ),
        Text(hint, style: text14Black
            // const TextStyle(color: Colors.white),
            ),
      ],
    );
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
                                              print(startDateSelect);
                                              print(startTimeSelect);

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
                                                    scheduleController.getAppointmentByDate(selectedDate: selectedDateforAPI).then((value) {
                                                      milestoneKeys.clear();

                                                      milestoneKeys = (scheduleController.appointmentListbyDateModel.value.appointmentList ?? [])
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
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}
