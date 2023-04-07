import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/dialog_widget.dart';
import 'package:solarex/utils/loading_spinner.dart';
import 'package:solarex/utils/utils.dart';

import '../../../../first_phase/FirstHomeScreen/firstHomeScreen.dart';
import '../../../../theme/colors.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _phoneController = TextEditingController(text: '');
  final TextEditingController _passwordController = TextEditingController(text: '');
  final TextEditingController _confirmPasswordController = TextEditingController(text: '');
  final TextEditingController _firstNameController = TextEditingController(text: '');
  final TextEditingController _lastNameController = TextEditingController(text: '');
  bool _passwordVisible = false;
  bool _passwordConfirmVisible = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: const AlwaysScrollableScrollPhysics(),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              controller: _firstNameController,
              decoration: const InputDecoration(
                hintText: "First Name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: "Last Name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              controller: _emailController,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            TextFormField(
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              controller: _phoneController,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                controller: _passwordController,
                obscureText: !_passwordVisible,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      })
                    },
                    color: kPrimaryColor,
                    iconSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                controller: _confirmPasswordController,
                obscureText: !_passwordConfirmVisible,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  hintText: "Confirm password",
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordConfirmVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => {
                      setState(() {
                        _passwordConfirmVisible = !_passwordConfirmVisible;
                      })
                    },
                    color: kPrimaryColor,
                    iconSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Obx(() => authController.loading.isTrue
                ? const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: LoadingSpinner(),
                    ))
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        submitForm(context);
                      });
                    },
                    child: Text("Sign Up".toUpperCase()),
                  )),
            const SizedBox(height: defaultPadding),
            // Obx(
            //   () => authController.loading.isTrue
            //       ? const LoadingSpinner()
            //       : AlreadyHaveAnAccountCheck(
            //           login: false,
            //           press: () {
            //             Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) {
            //                   return const LoginScreen();
            //                 },
            //               ),
            //             );
            //           },
            //         ),
            // )
          ],
        ),
      ),
    );
  }

  submitForm(BuildContext context) {
    FocusScope.of(context).unfocus();
    String emailval = emailValidator(_emailController.text);
    String passwordVal = emptyValidator(_passwordController.text, "Password Required");
    String firstNameVal = emptyValidator(_firstNameController.text, "First Name Required");
    String lastNameVal = emptyValidator(_lastNameController.text, "Last Name Required");
    String phoneVal = emptyValidator(_phoneController.text, "Phone Number Required");

    if (firstNameVal != "") {
      Fluttertoast.showToast(msg: firstNameVal);
    } else if (lastNameVal != "") {
      Fluttertoast.showToast(msg: lastNameVal);
    } else if (emailval != "") {
      Fluttertoast.showToast(msg: emailval);
    } else if (phoneVal != "") {
      Fluttertoast.showToast(msg: emailval);
    }
    // else if (passwordVal != "") {
    //   Fluttertoast.showToast(msg: passwordVal);
    // }
    else {
      if (checkPasswordvalidation(password: _passwordController.text.trim(), confirmPassword: _confirmPasswordController.text.trim())) {
        authController
            .registrationWithEmail(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                email: _emailController.text,
                phoneNumber: _phoneController.text,
                password: _passwordController.text)
            .then((v) {
          if (v) {
            showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.8),
                builder: (_) => DialogWidget(
                      title: authController.commonModel.value.message,
                      button1: 'Ok',
                      onButton1Clicked: () {
                        // Navigator.of(context, rootNavigator: true).pop();
                        // Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   PageTransition(
                        //     type: PageTransitionType.rightToLeft,
                        //     duration: Duration(milliseconds: 700),
                        //     child: FirstHomeScreen(),
                        //   ),
                        // );
                        if (authController.commonModel.value.message.toString() == 'Email already register') {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                            builder: (context) {
                              return const FirstHomeScreen();
                            },
                          ), (route) => false);
                        }
                      },
                      height: 150,
                    ));

            // Fluttertoast.showToast(msg: loginUserData.first.message.toString());
            // print("log====${authController.loginUserData.value.log}");
            // if (authController.loginUserData.value.log != null) {
            //   if (authController.loginUserData.value.log?.contains('true')??false) {

            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return const LoginScreen();
            //     },
            //   ),
            // );
            // } else {
            //   Fluttertoast.showToast(
            //       msg: authController.loginUserData.value.message
            //           .toString());
            // }
            // }
          }
        });
      }
    }
  }
}
