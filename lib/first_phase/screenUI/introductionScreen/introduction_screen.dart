import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solarex/first_phase/screenUI/viewShareScreen/model/beanContacts.dart';
import 'package:solarex/utils/colors_app.dart';
import 'package:solarex/first_phase/screenUI/introductionScreen/component/body.dart';
import 'package:solarex/first_phase/screenUI/shareScreen/share_screen.dart';
import 'package:solarex/first_phase/screenUI/viewShareScreen/view_share_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/style.dart';
import '../../Server/IntroducationAPI.dart';
import '../../../utils/constants.dart';
import '../../../utils/dialog_widget.dart';
import '../../../utils/theme.dart';

class IntroductionScreen extends StatefulWidget {
  static String routeName = "/introduction";
  // List<String> allSelectedList = [];
  const IntroductionScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> items = [
    'English',
    'Espanol',
    'Francais',
  ];

  String? selectedValue;
  // String initValue =
  //     "Hi! Just wanted to introduce to Daniel, my SolarEx rep. Who will be giving you a call. Daniel does a short and fun presentation showing a product called SolarEx. You don’t have to buy anything. Just listen and Daniel will get credit. Thought you would be nice enough to help!";
  final _controller = TextEditingController();
  String selectedHint = '';

  // bool isIntroducedBtn = false;
  var imagePicker;
  var cameraImageFile;

  @override
  void initState() {
    _controller.addListener(() {
      setState(
        () {},
      );
    });

    // ConstantClass.beanDumpContacts12!.name

    selectedHint =
        "Hi! Just wanted to introduce you to ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}, my Solarex rep, who will be giving you a call. ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} does a short and a fun presentation showing the Solarex program. You do not have to buy anything, Just listen and ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} will get credit. Thought you would be nice enough to help!";
    _controller.text =
        "Hi! Just wanted to introduce you to ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}, my Solarex rep, who will be giving you a call. ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} does a short and a fun presentation showing the Solarex program. You do not have to buy anything, Just listen and ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} will get credit. Thought you would be nice enough to help!";
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = ConstantClass.fullHeight(context);
    var fullWidth = ConstantClass.fullWidth(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            //Navigator.pop(context);
            // Navigator.pushNamed(context, ViewShareScreen.routeName);

            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } //return data along with pop
            setState(() {});
          },
        ),
        title: const Text(
          "Introduction",
          style: textHeader,
        ),
      ),
      body: SafeArea(
        child: Container(
          height: fullHeight,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                                  Text(
                                    ConstantClass.beanDumpContacts12!.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    ConstantClass.beanDumpContacts12!.numbrt.toString(),
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
                          onTap: () {
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
                  SizedBox(
                    height: fullHeight * 0.01,
                  ),
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
                                      .map((item) => DropdownMenuItem<String>(
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
                                    setState(
                                      () {
                                        selectedValue = value as String;
                                        if (selectedValue == "English") {
                                          selectedHint =
                                              "Hi! Just wanted to introduce you to ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}, my Solarex rep, who will be giving you a call. ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} does a short and a fun presentation showing the Solarex program. You don't have to buy anything. Just listen and ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} will get credit. Thought you would be nice enough to help!";
                                          _controller.text =
                                              "Hi! Just wanted to introduce you to ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}, my Solarex rep, who will be giving you a call. ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} does a short and a fun presentation showing the Solarex program. You don't have to buy anything. Just listen and ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} will get credit. Thought you would be nice enough to help!";
                                        }
                                        if (selectedValue == "Espanol") {
                                          selectedHint =
                                              '¡Hola! Solo quería presentarles a ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}, mi representante de Solarex . quién le llamará ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} hace un breve y una divertida presentación que muestra el programa Solarex. Tienes que comprar cualquier cosa. Solo escuche y ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} obtendrá crédito lo suficientemente bueno para ayudar!';
                                          _controller.text =
                                              '¡Hola! Solo quería presentarles a ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}, mi representante de Solarex . quién le llamará ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} hace un breve y una divertida presentación que muestra el programa Solarex. Tienes que comprar cualquier cosa. Solo escuche y ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} obtendrá crédito lo suficientemente bueno para ayudar!';
                                        }
                                        if (selectedValue == "Francais") {
                                          selectedHint =
                                              "Salut! Je voulais juste vous présenter ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}, mon représentant Solarex . qui vous appellera ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} fait un court et une présentation amusante montrant le programme Solarex. Vous n'avez rien à acheter. Écoutez simplement et ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} sera crédité assez gentil pour aider!";
                                          _controller.text =
                                              "Salut! Je voulais juste vous présenter ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()}, mon représentant Solarex . qui vous appellera ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} fait un court et une présentation amusante montrant le programme Solarex. Vous n'avez rien à acheter. Écoutez simplement et ${ConstantClass.repNumResponse?.repNumUserData?.firstName.toString().capitalize()} ${ConstantClass.repNumResponse?.repNumUserData?.lastName.toString().capitalize()} sera crédité assez gentil pour aider!";
                                        }
                                        print("selected Value===${selectedValue}");
                                        print("selected Value===${selectedHint.toString()}");
                                      },
                                    );
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
                  SizedBox(
                    height: fullHeight * 0.01,
                  ),
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
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          enabled: true,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            counterText: "",
                            hintText: selectedHint.toString(),
                            labelStyle: textNormal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: fullHeight * 0.01,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(40),
                    decoration: const BoxDecoration(
                      color: Color(0xFFeeeeee),
                    ),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        setState(() {
                          imgFromCamera();
                        });
                      },
                      child: Column(
                        children: [
                          cameraImageFile != null
                              ? Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(cameraImageFile.path)))))
                              : Icon(
                                  Icons.camera_alt,
                                ),
                          SizedBox(height: 14),
                          Text(
                            "TAKE A SELFIE",
                            style: textBtnLiteBlue,
                          ),
                        ],
                      ),
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
                          // _textMe();
                          _sendSMS([
                            ConstantClass.beanDumpContacts12!.numbrt.toString(),
                            '${ConstantClass.repNumResponse?.repNumUserData?.mobile.toString()}'
                          ]);
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
                    visible: false, // isIntroducedBtn,
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

                            // var bytes;
                            // if (cameraImageFile != null) {
                            //   bytes =
                            //       File(cameraImageFile.path).readAsBytesSync();
                            // } else {
                            //   bytes = "";
                            // }
                            // print("BASE 64 Image path==");
                            // print(base64Encode(bytes));
                            // print("END BASE 64 Image path==");
                            // _waits(true);
                            // introduceAPI(
                            //     ConstantClass.meetingNumber,
                            //     "${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}",
                            //     "91${ConstantClass.beanDumpContacts12!.numbrt.toString()}",
                            //     _controller.text.toString() != ""
                            //         ? _controller.text
                            //         : selectedHint.toString(),
                            //     ConstantClass.repNumResponse!.repNumUserData!
                            //                 .repNumber !=
                            //             null
                            //         ? ConstantClass.repNumResponse!
                            //             .repNumUserData!.repNumber!
                            //         : "",
                            //     _sucessAPI,
                            //     _error);
                          },
                          child: Text(
                            'introduced'.toUpperCase(),
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
      ),
    );
  }

  // _textMe() async {
  //   // Android
  //   if (Platform.isAndroid) {
  //     var uri = 'sms:${ConstantClass.beanDumpContacts12!.numbrt.toString()}?body=${_controller.text.toString()}';
  //     if (await launchUrl(Uri.parse(uri))) {
  //       // await launchUrl(Uri.parse(uri));
  //     } else {
  //       throw 'Could not launch $uri';
  //     }
  //   } else {
  //     // iOS
  //     var uri = 'sms:${ConstantClass.beanDumpContacts12!.numbrt.toString()}&body=${_controller.text.toString()}';
  //     if (await launchUrl(Uri.parse(uri))) {
  //       // await launchUrl(Uri.parse(uri));
  //     } else {
  //       throw 'Could not launch $uri';
  //     }
  //   }
  //
  //   // if (ConstantClass.beanDumpContacts12!.numbrt.toString().startsWith("+")) {
  //   //   ConstantClass.beanDumpContacts12!.numbrt = ConstantClass.beanDumpContacts12!.numbrt.toString().substring(1).replaceAll(' ', '');
  //   // } else if (!ConstantClass.beanDumpContacts12!.numbrt.toString().startsWith("91")) {
  //   //   ConstantClass.beanDumpContacts12!.numbrt = "91" + ConstantClass.beanDumpContacts12!.numbrt.toString().replaceAll(' ', '');
  //   // }
  //   // "${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}",
  //
  //   _waits(true);
  //   introduceAPI(
  //       ConstantClass.meetingNumber,
  //       ConstantClass.beanDumpContacts12!.name.toString(),
  //       ConstantClass.beanDumpContacts12!.numbrt.toString(),
  //       _controller.text.toString() != "" ? _controller.text : selectedHint.toString(),
  //       ConstantClass.repNumResponse!.repNumUserData!.repNumber != null ? ConstantClass.repNumResponse!.repNumUserData!.repNumber! : "",
  //       _sucessAPI,
  //       _error);
  // }
  String? _message;

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: _controller.text,
        recipients: recipients,
        sendDirect: false,
      );
      setState(() {
        _message = _result;
        // _waits(true);
        // introduceAPI(
        //     ConstantClass.meetingNumber,
        //     ConstantClass.beanDumpContacts12!.name.toString(),
        //     ConstantClass.beanDumpContacts12!.numbrt.toString(),
        //     _controller.text.toString() != "" ? _controller.text : selectedHint.toString(),
        //     ConstantClass.repNumResponse!.repNumUserData!.repNumber != null ? ConstantClass.repNumResponse!.repNumUserData!.repNumber! : "",
        //     _sucessAPI,
        //     _error);
      });
    } catch (error) {
      setState(() => _message = error.toString());
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
      //ConstantClass.selectedContactList.clear();
      //Navigator.pushNamed(context, ShareScreen.routeName);
    });
  }

  _error(String error) {
    _waits(false);
    print("API ERROR==$error");
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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _controller.dispose();
    super.dispose();
  }

  imgFromCamera() async {
    XFile image = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 100, preferredCameraDevice: CameraDevice.front);
    setState(() {
      cameraImageFile = image;
    });
  }
}
