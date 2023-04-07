import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/controllers/schedule_controllers.dart';
import 'package:solarex/second_phase/models/goalSetModel.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/loading_spinner.dart';

import '../../../theme/colors.dart';

class GoalSetScreen extends StatefulWidget {
  GoalSetScreen({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);
  String startDate;
  String endDate;

  @override
  State<GoalSetScreen> createState() => _GoalSetScreenState();
}

class _GoalSetScreenState extends State<GoalSetScreen> {
  final scheduleController = Get.put(ScheduleController());
  var value1 = 0.0;
  var value2 = 0.0;
  var value3 = 0.0;
  var value4 = 0.0;
  var value5 = 0.0;
  var value6 = 0.0;
  var value7 = 0.0;
  var Data1 = '';
  var Data2 = '';
  var Data3 = '';
  var Data4 = '';
  var Data5 = '';
  var Data6 = '';
  var Data7 = '';

  List<GoalSetModel> goalSetDay1 = [];
  List<GoalSetModel> goalSetDay2 = [];
  List<GoalSetModel> goalSetDay3 = [];
  List<GoalSetModel> goalSetDay4 = [];
  List<GoalSetModel> goalSetDay5 = [];
  List<GoalSetModel> goalSetDay6 = [];
  List<GoalSetModel> goalSetDay7 = [];

  @override
  void initState() {
    super.initState();
    scheduleController.getGoalData(startDate: widget.startDate, endDate: widget.endDate).then((value) {
      setState(() {
        value1 = double.parse((scheduleController.getGoalsDataModel.value.allGoalList ?? [])[0].goal.toString());
        value2 = double.parse((scheduleController.getGoalsDataModel.value.allGoalList ?? [])[1].goal.toString());
        value3 = double.parse((scheduleController.getGoalsDataModel.value.allGoalList ?? [])[2].goal.toString());
        value4 = double.parse((scheduleController.getGoalsDataModel.value.allGoalList ?? [])[3].goal.toString());
        value5 = double.parse((scheduleController.getGoalsDataModel.value.allGoalList ?? [])[4].goal.toString());
        value6 = double.parse((scheduleController.getGoalsDataModel.value.allGoalList ?? [])[5].goal.toString());
        value7 = double.parse((scheduleController.getGoalsDataModel.value.allGoalList ?? [])[6].goal.toString());

        Data1 = (scheduleController.getGoalsDataModel.value.allGoalList ?? [])[0].date.toString();
        Data2 = (scheduleController.getGoalsDataModel.value.allGoalList ?? [])[1].date.toString();
        Data3 = (scheduleController.getGoalsDataModel.value.allGoalList ?? [])[2].date.toString();
        Data4 = (scheduleController.getGoalsDataModel.value.allGoalList ?? [])[3].date.toString();
        Data5 = (scheduleController.getGoalsDataModel.value.allGoalList ?? [])[4].date.toString();
        Data6 = (scheduleController.getGoalsDataModel.value.allGoalList ?? [])[5].date.toString();
        Data7 = (scheduleController.getGoalsDataModel.value.allGoalList ?? [])[6].date.toString();
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
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        title: const Text(
          "Update Goals",
          style: textHeading,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
                alignment: Alignment.centerRight,
                child: Obx(
                  () {
                    return scheduleController.loadingSetGoals.isTrue
                        ? const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: LoadingSpinner(),
                            ))
                        : TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              goalSetDay1.clear();
                              goalSetDay2.clear();
                              goalSetDay3.clear();
                              goalSetDay4.clear();
                              goalSetDay5.clear();
                              goalSetDay6.clear();
                              goalSetDay7.clear();
                              goalSetDay1.add(GoalSetModel(date: Data1, goal: value1.toString()));
                              goalSetDay2.add(GoalSetModel(date: Data2, goal: value2.toString()));
                              goalSetDay3.add(GoalSetModel(date: Data3, goal: value3.toString()));
                              goalSetDay4.add(GoalSetModel(date: Data4, goal: value4.toString()));
                              goalSetDay5.add(GoalSetModel(date: Data5, goal: value5.toString()));
                              goalSetDay6.add(GoalSetModel(date: Data6, goal: value6.toString()));
                              goalSetDay7.add(GoalSetModel(date: Data7, goal: value7.toString()));

                              scheduleController
                                  .setGoals(
                                      dateDay1: goalSetDay1,
                                      dateDay2: goalSetDay2,
                                      dateDay3: goalSetDay3,
                                      dateDay4: goalSetDay4,
                                      dateDay5: goalSetDay5,
                                      dateDay6: goalSetDay6,
                                      dateDay7: goalSetDay7)
                                  .then((value) {
                                if (value) {
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Text('Save'.toUpperCase(), style: textStrBtn),
                          );
                  },
                )
                // loadingSetGoals

                ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () {
            return scheduleController.loadingGetGoals.isTrue
                ? const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: LoadingSpinner(),
                    ))
                : SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          //1
                          Container(
                            decoration: const BoxDecoration(color: colorBlueTransperent),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            child: Row(
                              children: [
                                Text(
                                  Data1,
                                  style: text16,
                                ),
                                const Spacer(),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: kPrimaryColor,
                                    inactiveTrackColor: kPrimaryLightDarkColor,
                                    trackShape: const RoundedRectSliderTrackShape(),
                                    trackHeight: 4.0,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                    thumbColor: kPrimaryColor,
                                    overlayColor: Colors.red.withAlpha(32),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                                    tickMarkShape: const RoundSliderTickMarkShape(),
                                    activeTickMarkColor: kPrimaryColor,
                                    inactiveTickMarkColor: kPrimaryLightDarkColor,
                                    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: kPrimaryColor,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Slider(
                                    value: value1,
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    label: '$value1',
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          value1 = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  value1.toString(),
                                  style: text16,
                                ),
                              ],
                            ),
                          ),
                          //2
                          Container(
                            decoration: const BoxDecoration(color: colorBlueTransperent),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            child: Row(
                              children: [
                                Text(
                                  Data2,
                                  style: text16,
                                ),
                                const Spacer(),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: kPrimaryColor,
                                    inactiveTrackColor: kPrimaryLightDarkColor,
                                    trackShape: const RoundedRectSliderTrackShape(),
                                    trackHeight: 4.0,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                    thumbColor: kPrimaryColor,
                                    overlayColor: Colors.red.withAlpha(32),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                                    tickMarkShape: const RoundSliderTickMarkShape(),
                                    activeTickMarkColor: kPrimaryColor,
                                    inactiveTickMarkColor: kPrimaryLightDarkColor,
                                    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: kPrimaryColor,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Slider(
                                    value: value2,
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    label: '$value2',
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          value2 = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  value2.toString(),
                                  style: text16,
                                ),
                              ],
                            ),
                          ),
                          //3
                          Container(
                            decoration: const BoxDecoration(color: colorBlueTransperent),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            child: Row(
                              children: [
                                Text(
                                  Data3,
                                  style: text16,
                                ),
                                const Spacer(),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: kPrimaryColor,
                                    inactiveTrackColor: kPrimaryLightDarkColor,
                                    trackShape: const RoundedRectSliderTrackShape(),
                                    trackHeight: 4.0,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                    thumbColor: kPrimaryColor,
                                    overlayColor: Colors.red.withAlpha(32),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                                    tickMarkShape: const RoundSliderTickMarkShape(),
                                    activeTickMarkColor: kPrimaryColor,
                                    inactiveTickMarkColor: kPrimaryLightDarkColor,
                                    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: kPrimaryColor,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Slider(
                                    value: value3,
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    label: '$value3',
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          value3 = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  value3.toString(),
                                  style: text16,
                                ),
                              ],
                            ),
                          ),
                          //4
                          Container(
                            decoration: const BoxDecoration(color: colorBlueTransperent),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            child: Row(
                              children: [
                                Text(
                                  Data4,
                                  style: text16,
                                ),
                                const Spacer(),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: kPrimaryColor,
                                    inactiveTrackColor: kPrimaryLightDarkColor,
                                    trackShape: const RoundedRectSliderTrackShape(),
                                    trackHeight: 4.0,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                    thumbColor: kPrimaryColor,
                                    overlayColor: Colors.red.withAlpha(32),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                                    tickMarkShape: const RoundSliderTickMarkShape(),
                                    activeTickMarkColor: kPrimaryColor,
                                    inactiveTickMarkColor: kPrimaryLightDarkColor,
                                    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: kPrimaryColor,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Slider(
                                    value: value4,
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    label: '$value4',
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          value4 = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  value4.toString(),
                                  style: text16,
                                ),
                              ],
                            ),
                          ),
                          //5
                          Container(
                            decoration: const BoxDecoration(color: colorBlueTransperent),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            child: Row(
                              children: [
                                Text(
                                  Data5,
                                  style: text16,
                                ),
                                const Spacer(),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: kPrimaryColor,
                                    inactiveTrackColor: kPrimaryLightDarkColor,
                                    trackShape: const RoundedRectSliderTrackShape(),
                                    trackHeight: 4.0,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                    thumbColor: kPrimaryColor,
                                    overlayColor: Colors.red.withAlpha(32),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                                    tickMarkShape: const RoundSliderTickMarkShape(),
                                    activeTickMarkColor: kPrimaryColor,
                                    inactiveTickMarkColor: kPrimaryLightDarkColor,
                                    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: kPrimaryColor,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Slider(
                                    value: value5,
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    label: '$value5',
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          value5 = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  value5.toString(),
                                  style: text16,
                                ),
                              ],
                            ),
                          ),
                          //6
                          Container(
                            decoration: const BoxDecoration(color: colorBlueTransperent),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            child: Row(
                              children: [
                                Text(
                                  Data6,
                                  style: text16,
                                ),
                                const Spacer(),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: kPrimaryColor,
                                    inactiveTrackColor: kPrimaryLightDarkColor,
                                    trackShape: const RoundedRectSliderTrackShape(),
                                    trackHeight: 4.0,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                    thumbColor: kPrimaryColor,
                                    overlayColor: Colors.red.withAlpha(32),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                                    tickMarkShape: const RoundSliderTickMarkShape(),
                                    activeTickMarkColor: kPrimaryColor,
                                    inactiveTickMarkColor: kPrimaryLightDarkColor,
                                    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: kPrimaryColor,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Slider(
                                    value: value6,
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    label: '$value6',
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          value6 = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  value6.toString(),
                                  style: text16,
                                ),
                              ],
                            ),
                          ),
                          //7
                          Container(
                            decoration: const BoxDecoration(color: colorBlueTransperent),
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            child: Row(
                              children: [
                                Text(
                                  Data7,
                                  style: text16,
                                ),
                                const Spacer(),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: kPrimaryColor,
                                    inactiveTrackColor: kPrimaryLightDarkColor,
                                    trackShape: const RoundedRectSliderTrackShape(),
                                    trackHeight: 4.0,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                    thumbColor: kPrimaryColor,
                                    overlayColor: Colors.red.withAlpha(32),
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                                    tickMarkShape: const RoundSliderTickMarkShape(),
                                    activeTickMarkColor: kPrimaryColor,
                                    inactiveTickMarkColor: kPrimaryLightDarkColor,
                                    valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: kPrimaryColor,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Slider(
                                    value: value7,
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    label: '$value7',
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          value7 = value;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  value7.toString(),
                                  style: text16,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
