import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/teambuilder_four_screen.dart';
import 'package:solarex/second_phase/screens/More/TeamBuilder/teambuilder_second_screen.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/constants.dart';

import 'teambuilder_intro_second_screen.dart';

class TeamBuilderIntrofristScreen extends StatefulWidget {
  const TeamBuilderIntrofristScreen({Key? key, required this.memberId, required this.isCompleteIntro}) : super(key: key);

  final String memberId;
  final bool isCompleteIntro;

  @override
  State<TeamBuilderIntrofristScreen> createState() => _TeamBuilderIntrofristScreenState();
}

class _TeamBuilderIntrofristScreenState extends State<TeamBuilderIntrofristScreen> {
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
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          centerTitle: false,
          title: const Text(
            "Introduction Summary",
            style: textHeading,
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            width: ConstantClass.fullWidth(context),
            height: ConstantClass.fullHeight(context),
            child: Container(
              width: ConstantClass.fullWidth(context),
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 70),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Thanks!",
                        style: textBtnBlue.merge(TextStyle(fontSize: 20)),
                      )),
                ),
                SizedBox(height: 30.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "You selected 1 people for special introductions.",
                        style: text16Black,
                      )),
                ),
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "This is 50% of you total introductions.",
                        style: text16Black,
                      )),
                ),
                SizedBox(height: 10.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Your manager will contact these people personally.",
                        style: text16Black,
                      )),
                ),
                SizedBox(height: 10.h),
                widget.isCompleteIntro
                    ? TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(color: Colors.white),
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
                        },
                        child: Text('select more friends'.toUpperCase(), style: textStrBtn),
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TeamBuilderIntroSecondScreen(
                                    memberId: widget.memberId,
                                  );
                                },
                              ),
                            );
                          });
                        },
                        child: Text('Go to final step!'.toUpperCase(), style: textStrBtn),
                      ),
              ]),
            ),
          ),
        ));
  }
}
