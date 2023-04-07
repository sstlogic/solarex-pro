import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/second_phase/models/selectedTeamMemberModel.dart';
import 'package:solarex/second_phase/screens/BottomNavigation/bottom_navigationbar_screen.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/loading_spinner.dart';
import 'package:solarex/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: MobileLoginScreen(),
      ),
    );
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
  final authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                const SizedBox(height: defaultPadding * 2),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                        flex: 8,
                        child: Image.asset(
                          "assets/image_logo1.png",
                          width: 120,
                        )),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: defaultPadding * 2),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          controller: _emailController,
                          onSaved: (email) {},
                          decoration: const InputDecoration(
                            hintText: "Email or REP ID",
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.email),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            cursorColor: kPrimaryColor,
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.lock),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              _launchUrl("http://www.app.solarexpro.com/auth/forgot_password");
                            },
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        Obx(
                          () => authController.loading.isTrue
                              ? const LoadingSpinner()
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      submitForm(context);
                                    });
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const DefaultBottomNavigationBar()));
                                  },
                                  child: Text(
                                    "Login".toUpperCase(),
                                  ),
                                ),
                        ),

                        // const SizedBox(height: defaultPadding),
                        // AlreadyHaveAnAccountCheck(
                        //   press: () {
                        //     Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) {
                        //           return const SignUpScreen();
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

  void check_if_already_login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var newuser = (prefs.getBool(logInKey) ?? true);
    print(newuser);
    if (newuser == false) {
      getids();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BottomNavigationBarScreen(
                    menuScreenContext: context,
                  )));
    }
  }

  Future<void> getids() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(userIdKey) ?? '';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  submitForm(BuildContext context) {
    FocusScope.of(context).unfocus();
    // String emailval = emailValidator(_emailController.text);
    String emailval = _emailController.text;
    String passwordVal = emptyValidator(_passwordController.text, "Password Required");
    if (emailval.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Email or REP ID");
    } else if (passwordVal != "") {
      Fluttertoast.showToast(msg: passwordVal);
    } else {
      authController.loginuser(email: _emailController.text, password: _passwordController.text).then((v) async {
        if (v) {
          if (authController.loginstatus.contains("true")) {
            authController.hideNav.value = false;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(logInKey, false);
            prefs.setString(userIdKey, authController.loginuserId.value);
            userId = authController.loginuserId.value;
            prefs.setBool(conTectUploadKey, true);
            // getAllContects(userId).then((value) {
            //   if (value.isNotEmpty) {
            //     authController.sendContectToServer(userId: userId, contectData: jsonEncode(value)).then((value) {
            //       prefs.setBool(conTectUploadKey, false);
            //       // Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(
            //       //     builder: (context) => BottomNavigationBarScreen(
            //       //           menuScreenContext: context,
            //       //           pageIndex: 0,
            //       //         )));
            //       /**/
            //     });
            //   } else {
            //     prefs.setBool(conTectUploadKey, true);
            //     // Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(
            //     //     builder: (context) => BottomNavigationBarScreen(
            //     //           menuScreenContext: context,
            //     //           pageIndex: 0,
            //     //         )));
            //   }
            //
            //   Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(
            //       builder: (context) => BottomNavigationBarScreen(
            //             menuScreenContext: context,
            //             pageIndex: 0,
            //           )));
            // });
            Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(
                builder: (context) => BottomNavigationBarScreen(
                      menuScreenContext: context,
                      pageIndex: 0,
                    )));
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return BottomNavigationBarScreen(
            //         menuScreenContext: context,pageIndex: 0,
            //       );
            //     },
            //   ),
            // );
          } else {
            Fluttertoast.showToast(msg: authController.loginMessage.toString());
          }
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
}
