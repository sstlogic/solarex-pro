
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:solarex/first_phase/Server/FeedbackAPI.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/dialog_widget.dart';
import 'package:solarex/utils/image_app.dart';
import '../../../../theme/style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/colors_app.dart';
import '../../profileScreen/profile_screen.dart';


class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  final List<String> items = [
    'English',
    'Espanol',
    'Francais',
  ];
  String? selectedValue;
  String initValue="¡Hola! Conozca a mi nuevo representante de Cutco.";
  final _controller = TextEditingController();
  bool isIntroducedBtn=true;

  @override
  Widget build(BuildContext context) {
    var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);

    _controller.text = 'Hey there! Meet my new cutco rep.';
    return SafeArea(
      child: Container(
        height: fullHeight,
        child: SingleChildScrollView(
          physics:const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
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

                      const SizedBox(
                        width: 20,
                      ),

                      Expanded(

                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "HARDIK",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const Text(
                                  "+91 8866388440",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Change".toUpperCase(),
                          style: textBtnLiteBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:fullHeight*0.01 ,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFeeeeee),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Language',
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
                                  'English',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                items: items
                                    .map((item) =>
                                    DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {

                                    selectedValue = value as String;
                                    print("selected Value===${selectedValue}");


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
                SizedBox(height:fullHeight*0.01 ,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFeeeeee),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Review and edit message',
                          style: textBtnLiteBlue,
                        ),
                      ),
                      TextFormField(
                        controller: _controller,
                        decoration:const InputDecoration(
                            fillColor: Colors.white,
                            counterText: "",
                            labelStyle: textNormal,
                        ),

                      ),
                    ],
                  ),
                ),
                SizedBox(height:fullHeight*0.01 ,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    color: Color(0xFFeeeeee),
                  ),
                  child: Center(child: Column(
                    children: [
                      const Icon(
                        Icons.camera_alt,
                                            ),
                      Text("TAKE A SELFIE",style: textBtnLiteBlue,),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
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

                        _textMe();

                      },
                      child: Text(
                        'create message'.toUpperCase(),
                        style: textBtn,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height:fullHeight*0.01 ,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'You${"'"}ll have another chance to review and edit the message before sending.',
                    style: text16,
                  ),
                ),
                Visibility(
                  visible:isIntroducedBtn,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
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
                          ConstantClass.toastMessage(toastMessage: "Coming soon");

                        },
                        child: Text(
                          'interoduced'.toUpperCase(),
                          style: textBtn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _textMe() async {
    // Android
    var uri = 'sms:${ConstantClass.repNumResponse!.repNumUserData!.mobile!.toString()}?body=${selectedValue.toString()}';
    if (await launchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      // iOS
      var uri = 'sms:${ConstantClass.repNumResponse!.repNumUserData!.mobile!.toString()}?body=${selectedValue.toString()}';
      if (await launchUrl(Uri.parse(uri))) {
        await launchUrl(Uri.parse(uri));
      } else {
        throw 'Could not launch $uri';
      }
    }
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
      Navigator.pushNamed(context, ProfileScreen.routeName);
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
