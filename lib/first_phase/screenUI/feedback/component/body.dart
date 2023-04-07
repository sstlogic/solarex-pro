import 'package:flutter/material.dart';
import 'package:solarex/first_phase/Server/CommentAPI.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/dialog_widget.dart';
import 'package:solarex/utils/image_app.dart';

import '../../../../theme/style.dart';
import '../../../../utils/colors_app.dart';
import '../../../../utils/theme.dart';
import '../../secondFeedback/second_feedback_screen.dart';
import '../feedback_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _commentBoxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);

    return SafeArea(
      child: Container(
        height: fullHeight,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.only(top: fullWidth * .08),
                    child: (ConstantClass.repNumResponse!.repNumUserData!.userPic != null &&
                            ConstantClass.repNumResponse!.repNumUserData!.userPic.toString().startsWith('http'))
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(300)),
                            child: CircleAvatar(
                              radius: 40,
                              child: Image.network(
                                ConstantClass.repNumResponse!.repNumUserData!.userPic!,
                                height: 135,
                                width: 135,
                              ),
                            ))
                        : ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(300)),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(imguser),
                            ))

                    // Image.asset(imguser)
                    ),

                SizedBox(
                  height: fullWidth * .03,
                ),
                // const Text("John Brown",style: textProfileName,
                Text(
                  "${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}",
                  style: textProfileName,
                ),

                SizedBox(
                  height: fullHeight * 0.05,
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'What Feedback do you have that can help ${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()} improve their presentation skill?',
                    textAlign: TextAlign.center,
                    style: textNormal,
                  ),
                ),

                SizedBox(
                  height: fullHeight * 0.08,
                ),

                Container(
                  height: fullWidth * .30,
                  margin: const EdgeInsets.only(left: defaultPadding, right: defaultPadding),
                  child: buildFirstStepFormField(),
                ),

                const SizedBox(
                  height: defaultPadding,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(defaultPadding, 4, defaultPadding, 10),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: const Size.fromHeight(40), // NEW
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _waits(true);
                          commentAPI(ConstantClass.meetingNumber, _commentBoxController.text, _sucessAPI, _error);
                        }
                      },
                      child: Text(
                        "continue".toUpperCase(),
                        style: textBtn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _waits(bool value) {
    if (value) {
      showLoaderDialog(context);
    } else {
      Navigator.pop(context);
    }
  }

  _sucessAPI(String? message, String? status) {
    _waits(false);
    setState(() {
      Navigator.pushNamed(context, SecondFeedbackScreen.routeName);
    });
  }

  _error(String error) {
    _waits(false);
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (_) => DialogWidget(
              title: "" + error,
              button1: 'Ok',
              onButton1Clicked: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              height: 150,
            ));
  }

  TextFormField buildFirstStepFormField() {
    return TextFormField(
      maxLines: 15,
      controller: _commentBoxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please write feedback';
        }
        return null;
      },
      textAlign: TextAlign.start,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffeeeeee)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffeeeeee)),
        ),
        fillColor: Color(0xffeeeeee),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffeeeeee)),
        ),
        counterText: "",
        hintText: "Comment",
        hintStyle: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
        isDense: true,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.fromLTRB(10, 10, 20, 10),
      ),
    );
    //   TextFormField(
    //   autovalidateMode: AutovalidateMode.always,
    //   // onSaved: (newValue) => strReg = newValue,
    //   onChanged: (value) {
    //     if (value.isNotEmpty) {
    //
    //     } else if (value.length >= 8) {
    //
    //     }
    //     return null;
    //   },
    //   validator: (value) {
    //     return null;
    //   },
    //   decoration: InputDecoration(
    //     enabledBorder: ConstantClass.outlineInputBorder,
    //     border: ConstantClass.outlineInputBorder,
    //     errorBorder: ConstantClass.outlineInputBorder,
    //     hintText: "Good",
    //     hintStyle: const TextStyle(color: kTextColor, fontWeight: FontWeight.w400),
    //     floatingLabelBehavior: FloatingLabelBehavior.always,
    //   ),
    // );
  }
}
