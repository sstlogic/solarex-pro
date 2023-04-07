import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/controllers/profile_controllers.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/Intro/teambuilder_intro_first_screen.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/constants.dart';

import '../../../../../theme/colors.dart';

class TeamBuilderIntroSecondScreen extends StatefulWidget {
  const TeamBuilderIntroSecondScreen({Key? key, required this.memberId}) : super(key: key);

  final String memberId;

  @override
  State<TeamBuilderIntroSecondScreen> createState() => _TeamBuilderIntroSecondScreenState();
}

class _TeamBuilderIntroSecondScreenState extends State<TeamBuilderIntroSecondScreen> {
  final profileController = Get.put(ProfileController());
  int _groupValue = -1;
  final activitiesController = TextEditingController();
  final thinkSolarExController = TextEditingController();
  // final schoolController = TextEditingController();
  // final collageController = TextEditingController();
  final otherController = TextEditingController();
  String doYouKnow = 'From High School';

  @override
  void initState() {
    super.initState();
    profileController.getMemberDetails(memberId: widget.memberId);
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
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          centerTitle: false,
          title: Obx(
            () => Text(
              "History: ${profileController.memberDetailsModel.value.data?.firstName ?? ""}" +
                  (profileController.memberDetailsModel.value.data?.lastName ?? ""),
              style: textHeading,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: ConstantClass.fullWidth(context),
              height: ConstantClass.fullHeight(context),
              child: Container(
                width: ConstantClass.fullWidth(context),
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 70),
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(height: 10.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "How do you know them?",
                          style: textBtnBlue.merge(const TextStyle(color: Colors.black)),
                        )),
                  ),
                  SizedBox(
                    height: 30.h,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 0,
                      groupValue: _groupValue,
                      onChanged: (newValue) => setState(() {
                        _groupValue = newValue ?? 0;
                        doYouKnow = 'From High School';
                        otherController.text = '';
                      }),
                      title: const Text(
                        "From High School",
                        style: text14Black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 1,
                      groupValue: _groupValue,
                      // onChanged: (newValue) => setState(() => _groupValue = newValue ?? 1),
                      onChanged: (newValue) => setState(() {
                        _groupValue = newValue ?? 1;
                        doYouKnow = 'From Collage';
                        otherController.text = '';
                      }),
                      title: const Text(
                        "From Collage",
                        style: text14Black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 2,
                      groupValue: _groupValue,
                      // onChanged: (newValue) => setState(() => _groupValue = newValue ?? 2),
                      onChanged: (newValue) => setState(() {
                        _groupValue = newValue ?? 2;
                        doYouKnow = 'Long-time friend';
                      }),
                      title: const Text(
                        "Long-time friend",
                        style: text14Black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 3,
                      groupValue: _groupValue,
                      // onChanged: (newValue) => setState(() => _groupValue = newValue ?? 3),
                      onChanged: (newValue) => setState(() {
                        _groupValue = newValue ?? 3;
                        doYouKnow = 'Previous Job';
                      }),
                      title: const Text(
                        "Previous Job",
                        style: text14Black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 4,
                      groupValue: _groupValue,
                      // onChanged: (newValue) => setState(() => _groupValue = newValue ?? 4),
                      onChanged: (newValue) => setState(() {
                        _groupValue = newValue ?? 4;
                        doYouKnow = 'Other';
                        otherController.text = '';
                      }),
                      title: const Text(
                        "Other",
                        style: text14Black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _groupValue == 0
                      ? Center(
                          child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: kPrimaryColor,
                              onSaved: (email) {},
                              maxLines: 1,
                              controller: otherController,
                              decoration: const InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  fillColor: Colors.white,
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  labelText: "What High School?",
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  counterText: "",
                                  hintText: "What High School?",
                                  labelStyle: kText14SemiBoldGrey,
                                  errorStyle: kText12SemiBoldRed,
                                  hintStyle: kText14SemiBoldGrey)),
                        )
                      : const SizedBox(),
                  _groupValue == 1
                      ? Center(
                          child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: kPrimaryColor,
                              onSaved: (email) {},
                              maxLines: 1,
                              controller: otherController,
                              decoration: const InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  fillColor: Colors.white,
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  labelText: "What Collage?",
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: colorAppMain),
                                  ),
                                  counterText: "",
                                  hintText: "What Collage?",
                                  labelStyle: kText14SemiBoldGrey,
                                  errorStyle: kText12SemiBoldRed,
                                  hintStyle: kText14SemiBoldGrey)),
                        )
                      : const SizedBox(),
                  _groupValue == 4
                      ? Container(
                          child: Center(
                            child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                cursorColor: kPrimaryColor,
                                onSaved: (email) {},
                                maxLines: 1,
                                controller: otherController,
                                decoration: const InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: colorAppMain),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: colorAppMain),
                                    ),
                                    fillColor: Colors.white,
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: colorAppMain),
                                    ),
                                    labelText: "Please Enter Other",
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: colorAppMain),
                                    ),
                                    counterText: "",
                                    hintText: "Please Enter Other",
                                    labelStyle: kText14SemiBoldGrey,
                                    errorStyle: kText12SemiBoldRed,
                                    hintStyle: kText14SemiBoldGrey)),
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "What activities have you done together?",
                          style: textBtnBlue.merge(const TextStyle(color: Colors.black)),
                        )),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    child: Center(
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (email) {},
                          maxLines: 3,
                          controller: activitiesController,
                          decoration: const InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorAppMain),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorAppMain),
                              ),
                              fillColor: Colors.white,
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorAppMain),
                              ),
                              labelText: "",
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorAppMain),
                              ),
                              counterText: "",
                              hintText: "Optional",
                              labelStyle: kText14SemiBoldGrey,
                              errorStyle: kText12SemiBoldRed,
                              hintStyle: kText14SemiBoldGrey)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Why do you think they'd do well at SolarEx?",
                          style: textBtnBlue.merge(const TextStyle(color: Colors.black)),
                        )),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    child: Center(
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          onSaved: (email) {},
                          maxLines: 3,
                          controller: thinkSolarExController,
                          decoration: const InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorAppMain),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorAppMain),
                              ),
                              fillColor: Colors.white,
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorAppMain),
                              ),
                              labelText: "",
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorAppMain),
                              ),
                              counterText: "",
                              hintText: "Optional",
                              labelStyle: kText14SemiBoldGrey,
                              errorStyle: kText12SemiBoldRed,
                              hintStyle: kText14SemiBoldGrey)),
                    ),
                  ),
                  SizedBox(height: 20.h),
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
                              var memberData = [
                                {
                                  "first_name": profileController.memberDetailsModel.value.data?.firstName,
                                  "last_name": profileController.memberDetailsModel.value.data?.lastName,
                                  "mobile": profileController.memberDetailsModel.value.data?.mobile,
                                  "referred_by": profileController.memberDetailsModel.value.data?.referredBy
                                }
                              ];
                              profileController
                                  .introducedFormAPI(
                                      memberData: memberData,
                                      activities: activitiesController.text,
                                      doYouKnow: doYouKnow,
                                      doYouThink: thinkSolarExController.text,
                                      otherField: otherController.text)
                                  .then((value) {
                                SavedDialog();
                                Future.delayed(const Duration(milliseconds: 300), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return TeamBuilderIntrofristScreen(
                                          memberId: widget.memberId,
                                          isCompleteIntro: true,
                                        );
                                      },
                                    ),
                                  );
                                });
                              });
                            });
                          },
                          child: Text('Submit'.toUpperCase(), style: textStrBtn),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ));
  }

  Future SavedDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      width: ConstantClass.fullWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.file_download_done_rounded,
                            color: kPrimaryDarkColor,
                            size: 60,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Saved!',
                            style: text18Black,
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
