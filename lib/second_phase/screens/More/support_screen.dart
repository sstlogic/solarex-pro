import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/controllers/schedule_controllers.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/teambuilder_second_screen.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/style.dart';
import '../../../../utils/constants.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final notesController = TextEditingController(text: "");
  final scheduleController = Get.put(ScheduleController());

  @override
  void initState() {
    super.initState();
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
          centerTitle: false,
          title: const Text(
            "TeamBuilder",
            style: textHeading,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const TeamBuilderSecondScreen();
                        },
                      ),
                    );
                  },
                  child: Text('Begin'.toUpperCase(), style: textStrBtn),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SizedBox(
            width: ConstantClass.fullWidth(context),
            height: ConstantClass.fullHeight(context),
            child: Container(
              width: ConstantClass.fullWidth(context),
              // height: ConstantClass.fullHeight(context),
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 70),
              child: Column(children: [
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Thanks for helping our team!",
                        style: textHeading,
                      )),
                ),
                SizedBox(height: 30.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Our staff will:",
                        style: text14BlackBold,
                      )),
                ),
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.done,
                        color: kPrimaryDarkColor,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Introduce themselves with a text",
                        style: text14Black,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.done,
                        color: kPrimaryDarkColor,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Offer each friend a chance to interview",
                        style: text14Black,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.done,
                        color: kPrimaryDarkColor,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Treat each friend with 100% respect.",
                        style: text14Black,
                      )
                    ],
                  ),
                ),
//----------Section 2-----------
                SizedBox(height: 30.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Our staff won't:",
                        style: text14BlackBold,
                      )),
                ),
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.done,
                        color: kPrimaryDarkColor,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Bug your friends.",
                        style: text14Black,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.done,
                        color: kPrimaryDarkColor,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Get offended if any friend ignores us.",
                        style: text14Black,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.done,
                        color: kPrimaryDarkColor,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Hold against you anything your friends say or do.",
                        style: text14Black,
                      )
                    ],
                  ),
                ),

                //---------Section 2 End-----
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Once your trainer is ready, select "Begin"! ',
                        style: text14BlackBold,
                      )),
                ),
              ]),
            ),
          ),
        ));
  }
}
