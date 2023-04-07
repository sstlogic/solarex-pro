import 'package:flutter/material.dart';
import 'package:solarex/first_phase/Server/MeetingNumberAPI.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/dialog_widget.dart';
import 'package:solarex/utils/image_app.dart';
import 'package:solarex/first_phase/screenUI/findMeeting/meeting_screen.dart';
import '../../../../theme/style.dart';
import '../../../../theme/style.dart';
import '../../../../utils/colors_app.dart';
import '../../../../utils/theme.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _meetingNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);

    return SafeArea(
      child: Form(
        key: _formKey,
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  flex: 1,

                  child: Center(
                    // child: _centerNoProfileText(),
                    child: SingleChildScrollView(
                      child: Column(children: [

                        Container(
                            height: 70,
                            width: 70,
                            margin: EdgeInsets.only(
                                top: fullWidth * .10, bottom: fullWidth * .10),
                            child: Image.asset(iconCalender)),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text(
                              'Next, please enter your four-digit meeting\nnumber for confirmation.  ',
                              textAlign: TextAlign.center,
                              style: textDescription),
                        ),
                      ]),
                    ),
                  ),
                ),
                // SizedBox(height: fullHeight*.2),
                Container(
                  margin: EdgeInsets.only(top:defaultPadding ),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: buildFirstStepFormField()),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
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
                        if (_formKey.currentState!.validate()) {
                          _waits(true);
                          meetingNumberAPI(_meetingNumberController.text,
                              _sucessAPI, _error);
                        }
                      },
                      child: Text(
                        'confirm meeting'.toUpperCase(),
                        style: textBtn,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFirstStepFormField() {
    return Container(
      // height: fullWidth * .20,
      margin: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, top: defaultPadding),
      child: TextFormField(
        maxLength: 4,
        controller: _meetingNumberController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Meeting number empty';
          } else if (value.toString().length != 4) {
            return 'Invalid Meeting number';
          }
          return null;
        },
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
          hintText: "Enter meeting number",
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        ),
        keyboardType: TextInputType.number,
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
      Navigator.pushNamed(context, MeetingScreen.routeName);
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
}
