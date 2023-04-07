// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarex/first_phase/FirstHomeScreen/firstHomeScreen.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/second_phase/controllers/profile_controllers.dart';
import 'package:solarex/theme/style.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/loading_spinner.dart';

import '../../../theme/colors.dart';
import '../../Widgets/customtextfields.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker imagePicker = ImagePicker();
  final repNumberController = TextEditingController();
  final engBioController = TextEditingController();
  final esBioController = TextEditingController();
  final frBioController = TextEditingController();
  final refNumberController = TextEditingController();
  final firstNameNumberController = TextEditingController();
  final lastNameNumberController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  XFile pickedImageFile = XFile("");
  final profileController = Get.put(ProfileController());
  final authController = Get.put(AuthController());

  @override
  void initState() {
    profileController.getUserProfile(userId: userId).then((value) async {
      if (value == "inactive") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(logInKey, true);
        prefs.setString(userIdKey, '');
        authController.hideNav.value = true;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FirstHomeScreen()));
        Fluttertoast.showToast(msg: 'You are Blocked From Admin');
      } else {
        repNumberController.text = profileController.userProfileData.value.data?.repNumber ?? "";
        firstNameNumberController.text = profileController.userProfileData.value.data?.firstName ?? "";
        lastNameNumberController.text = profileController.userProfileData.value.data?.lastName ?? "";
        mobileController.text = profileController.userProfileData.value.data?.mobile ?? "";
        emailController.text = profileController.userProfileData.value.data?.email ?? "";
        engBioController.text = profileController.userProfileData.value.data?.intro_en ?? "";
        esBioController.text = profileController.userProfileData.value.data?.intro_es ?? "";
        frBioController.text = profileController.userProfileData.value.data?.intro_fr ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              width: ConstantClass.fullWidth(context),
              height: ConstantClass.fullHeight(context),
              color: Colors.white,
              margin: const EdgeInsets.fromLTRB(6, 6, 6, 50),
              child: Obx(
                () => profileController.loading.isTrue
                    ? const Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: LoadingSpinner(),
                        ))
                    : Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                  child: Text(
                                'Profile',
                                style: textHeading,
                              )),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text('Cancel', style: kTextbuttonStyleColorAppMain),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle: const TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  var bytes;
                                  setState(() {
                                    if (pickedImageFile.path.isNotEmpty) {
                                      bytes = File(pickedImageFile.path).readAsBytesSync();
                                    }
                                    profileController
                                        .updateProfile(
                                            userId: userId,
                                            email: emailController.text,
                                            firstName: firstNameNumberController.text,
                                            lastName: lastNameNumberController.text,
                                            mobile: mobileController.text,
                                            imageString: bytes == null ? '' : base64Encode(bytes),
                                            introEng: engBioController.text,
                                            introEs: esBioController.text,
                                            introFr: frBioController.text)
                                        .then((value) => Navigator.pop(context));
                                    // Navigator.pop(context);
                                  });
                                },
                                child: const Text('Save', style: textStrBtn),
                              )
                            ],
                          ),
                          SizedBox(
                              height: 160,
                              width: 140,
                              child: CircleAvatar(
                                backgroundColor: colorAppMain,
                                radius: 120,
                                child: pickedImageFile.path.isEmpty
                                    ? profileController.userProfileData.value.data?.userPic != null &&
                                            profileController.userProfileData.value.data?.userPic != ''
                                        ? CircleAvatar(
                                            radius: 120 - 5,
                                            backgroundImage: Image.network(profileController.userProfileData.value.data?.userPic ?? '').image,
                                          )
                                        : pickedImageFile.path.isNotEmpty
                                            ? CircleAvatar(
                                                radius: 120 - 5,
                                                backgroundImage: Image.file(
                                                  File(pickedImageFile?.path ?? ""),
                                                  height: 100,
                                                  width: 100,
                                                ).image,
                                              )
                                            : Image.asset(
                                                'assets/images/profile_user_placeholder.png',
                                                color: Colors.white,
                                                height: 60,
                                                width: 60,
                                              )
                                    : CircleAvatar(
                                        radius: 120 - 5,
                                        backgroundImage: Image.file(
                                          File(pickedImageFile?.path ?? ""),
                                          height: 100,
                                          width: 100,
                                        ).image,
                                      ),
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      textStyle: const TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        initImagePickUp(ImageSource.camera);
                                      });
                                    },
                                    child: Text('Take Selfie'.toUpperCase(), style: const TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      textStyle: const TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        initImagePickUp(ImageSource.gallery);
                                      });
                                    },
                                    child: Text('Select Photo'.toUpperCase(), style: const TextStyle(color: Colors.white)),
                                  ),
                                ),
                              )
                            ],
                          ),
                          CustomTextFields(
                            width: 375.w,
                            lable: "Rep Number : ${profileController.userProfileData.value.data?.repNumber ?? "0"}",
                            controllers: repNumberController,
                            enable: false,
                            hintText: "Rep Number",
                            keyboardType: TextInputType.text,
                            fieldValidator: (value) {
                              // if (value!.isEmpty) {
                              //   return 'Please Enter Family Name';
                              // }
                            },
                            onPress: () {},
                          ),
                          CustomTextFields(
                            width: 375.w,
                            lable: "Lifetime Referrals : ${profileController.userProfileData.value.data?.lifetimeReferral ?? "0"}",
                            controllers: refNumberController,
                            enable: false,
                            hintText: "Lifetime Referrals",
                            keyboardType: TextInputType.text,
                            fieldValidator: (value) {
                              // if (value!.isEmpty) {
                              //   return 'Please Enter Family Name';
                              // }
                            },
                            onPress: () {},
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFields(
                                  width: 175.w,
                                  lable: "First Name",
                                  controllers: firstNameNumberController,
                                  enable: true,
                                  hintText: "First Name",
                                  keyboardType: TextInputType.text,
                                  fieldValidator: (value) {
                                    // if (value!.isEmpty) {
                                    //   return 'Please Enter Family Name';
                                    // }
                                  },
                                  onPress: () {},
                                ),
                              ),
                              Expanded(
                                child: CustomTextFields(
                                  width: 175.w,
                                  lable: "Last Name",
                                  controllers: lastNameNumberController,
                                  enable: true,
                                  hintText: "Last Name",
                                  keyboardType: TextInputType.text,
                                  fieldValidator: (value) {
                                    // if (value!.isEmpty) {
                                    //   return 'Please Enter Family Name';
                                    // }
                                  },
                                  onPress: () {},
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFields(
                                  width: 175.w,
                                  lable: "Mobile",
                                  controllers: mobileController,
                                  enable: true,
                                  hintText: "Mobile",
                                  keyboardType: TextInputType.text,
                                  fieldValidator: (value) {
                                    // if (value!.isEmpty) {
                                    //   return 'Please Enter Family Name';
                                    // }
                                  },
                                  onPress: () {},
                                ),
                              ),
                              Expanded(
                                child: CustomTextFields(
                                  width: 175.w,
                                  lable: "Email",
                                  hintText: "Email",
                                  controllers: emailController,
                                  enable: true,
                                  keyboardType: TextInputType.text,
                                  fieldValidator: (value) {
                                    // if (value!.isEmpty) {
                                    //   return 'Please Enter Family Name';
                                    // }
                                  },
                                  onPress: () {},
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              children: [
                                DefaultTabController(
                                    length: 3, // length of tabs
                                    initialIndex: 0,
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                                      const TabBar(
                                        labelColor: kPrimaryColor,
                                        unselectedLabelColor: Colors.black,
                                        tabs: [
                                          Tab(text: 'English'),
                                          Tab(text: 'Espanol'),
                                          Tab(text: 'Francais'),
                                        ],
                                      ),
                                      SizedBox(height: 16.h),
                                      Container(
                                          height: 100, //height of TabBarView
                                          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
                                          child: TabBarView(children: <Widget>[
                                            Container(
                                              child: Center(
                                                child:
                                                    // TextFormField(
                                                    //   // maxLength: maxlength,
                                                    //   controller: engBioController,
                                                    //
                                                    //   style: kText14SemiBoldBlack,
                                                    //   decoration: InputDecoration(
                                                    //       errorBorder: const OutlineInputBorder(
                                                    //         borderSide: BorderSide(color: Colors.red),
                                                    //       ),
                                                    //       isDense: true,
                                                    //       filled: true,
                                                    //       enabledBorder: OutlineInputBorder(
                                                    //         borderSide: BorderSide(color: colorAppMain),
                                                    //       ),
                                                    //       focusedBorder: OutlineInputBorder(
                                                    //         borderSide: BorderSide(color: colorAppMain),
                                                    //       ),
                                                    //       fillColor: Colors.white,
                                                    //       // disabledBorder: OutlineInputBorder(
                                                    //       //   borderSide: BorderSide(color: colorAppMain),
                                                    //       // ),
                                                    //       // border: const OutlineInputBorder(),
                                                    //
                                                    //
                                                    //       focusedErrorBorder: OutlineInputBorder(
                                                    //         borderSide: BorderSide(color: colorAppMain),
                                                    //       ),
                                                    //       counterText: "",
                                                    //       hintText: "hintText",
                                                    //       labelStyle: kText14SemiBoldGrey,
                                                    //       errorStyle: kText12SemiBoldRed,
                                                    //       hintStyle: kText14SemiBoldGrey),
                                                    //
                                                    // ),
                                                    TextFormField(
                                                        keyboardType: TextInputType.emailAddress,
                                                        textInputAction: TextInputAction.next,
                                                        cursorColor: kPrimaryColor,
                                                        onSaved: (email) {},
                                                        maxLines: 5,
                                                        controller: engBioController,
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
                                                            hintText: "Enter Bio",
                                                            labelStyle: kText14SemiBoldGrey,
                                                            errorStyle: kText12SemiBoldRed,
                                                            hintStyle: kText14SemiBoldGrey)),
                                                // CustomTextFields(
                                                //   width: 360.w,
                                                //   lable:'',
                                                //   controllers: engBioController,
                                                //   enable: true,
                                                //   hintText: "Enter Bio",
                                                //   keyboardType: TextInputType.text,
                                                //   fieldValidator: (value) {
                                                //     // if (value!.isEmpty) {
                                                //     //   return 'Please Enter Family Name';
                                                //     // }
                                                //   },
                                                //   onPress: () {},
                                                // ),
                                                // Text(profileController.userProfileData.value.data?.intro_en??"",
                                                //     style: const TextStyle(
                                                //         fontSize: 22,
                                                //         fontWeight:
                                                //             FontWeight
                                                //                 .bold)),
                                              ),
                                            ),
                                            Container(
                                              child: Center(
                                                child: TextFormField(
                                                    keyboardType: TextInputType.emailAddress,
                                                    textInputAction: TextInputAction.next,
                                                    cursorColor: kPrimaryColor,
                                                    onSaved: (email) {},
                                                    maxLines: 5,
                                                    controller: esBioController,
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
                                                        hintText: "Enter Bio",
                                                        labelStyle: kText14SemiBoldGrey,
                                                        errorStyle: kText12SemiBoldRed,
                                                        hintStyle: kText14SemiBoldGrey)),
                                                // CustomTextFields(
                                                //   width: 350.w,
                                                //   lable:'',
                                                //   controllers: esBioController,
                                                //   enable: true,
                                                //   hintText: "Enter Bio",
                                                //   keyboardType: TextInputType.text,
                                                //   fieldValidator: (value) {
                                                //     // if (value!.isEmpty) {
                                                //     //   return 'Please Enter Family Name';
                                                //     // }
                                                //   },
                                                //   onPress: () {},
                                                // ),
                                                // Text(profileController.userProfileData.value.data?.intro_es??"",
                                                //     style: const TextStyle(
                                                //         fontSize: 22,
                                                //         fontWeight:
                                                //             FontWeight
                                                //                 .bold)),
                                              ),
                                            ),
                                            Container(
                                              child: Center(
                                                child: TextFormField(
                                                    keyboardType: TextInputType.emailAddress,
                                                    textInputAction: TextInputAction.next,
                                                    cursorColor: kPrimaryColor,
                                                    onSaved: (email) {},
                                                    maxLines: 5,
                                                    controller: frBioController,
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
                                                        hintText: "Enter Bio",
                                                        labelStyle: kText14SemiBoldGrey,
                                                        errorStyle: kText12SemiBoldRed,
                                                        hintStyle: kText14SemiBoldGrey)),
                                                // CustomTextFields(
                                                //   width: 350.w,
                                                //   lable:'',
                                                //   controllers: frBioController,
                                                //   enable: true,
                                                //   hintText: "Enter Bio",
                                                //   keyboardType: TextInputType.text,
                                                //   fieldValidator: (value) {
                                                //     // if (value!.isEmpty) {
                                                //     //   return 'Please Enter Family Name';
                                                //     // }
                                                //   },
                                                //   onPress: () {},
                                                // ),
                                                // Text(profileController.userProfileData.value.data?.intro_fr??"",
                                                //     style: const TextStyle(
                                                //         fontSize: 22,
                                                //         fontWeight:
                                                //             FontWeight
                                                //                 .bold)),
                                              ),
                                            ),
                                          ])),
                                    ])),
                              ],
                            ),
                          ),
                        ],
                      ),
              )),
        ),
      ),
    );
  }

  initImagePickUp(ImageSource source) async {
    final XFile? pickedFile = await imagePicker.pickImage(
      source: source,
      maxWidth: 400.0,
      maxHeight: 400.0,
      imageQuality: 100,
    );
    setState(() {
      pickedImageFile = pickedFile!;
      if (pickedImageFile.path.isNotEmpty) {
        var bytes = File(pickedImageFile.path).readAsBytesSync();
      }
    });
  }

// Future<void> getids() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.getString(userIdKey);
// }
}
