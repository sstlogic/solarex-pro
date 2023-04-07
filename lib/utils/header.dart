import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/controllers/auth_controllers.dart';
import 'package:solarex/theme/style.dart';

import '../theme/colors.dart';


class HeaderHandler {
  // HeaderController headerController = Get.put(HeaderController());
  final AuthController _authController = Get.put(AuthController());

  dynamic getHeaders() async {
    return {
      'Content-Type': 'application/json',
    };
  }



  void handleHeaders(response) async {
    dio.Headers resHeader = response.headers;

    if (resHeader['SESSION_EXPIRED'] != null &&
        resHeader['SESSION_EXPIRED']![0] == 'YES') {
      Fluttertoast.showToast(
        msg: 'Session Expired! Login Again',
      );
      // _authController.logout(fromMenu: true);
    }

    if (resHeader['APP_NAME_REQUIRED']?[0] == 'YES') {
      Fluttertoast.showToast(msg: 'App name is required');
    } else if (resHeader['UNKNOWN_APP']?[0] == 'YES') {
      Fluttertoast.showToast(msg: 'App name is unknown');
    } else if (resHeader['VERSION_REQUIRED']?[0] == 'YES') {
      Fluttertoast.showToast(msg: 'App version is required');
    } else if (resHeader['MAINTENANCE']?[0] == 'YES') {
      handleMaintenance(resHeader);
    } else if (resHeader['VERSION_EXPIRED']?[0] == 'YES') {
      // handleVersionExpired(resHeader);
    } else if (resHeader['UPDATE_AVAILABLE']?[0] == 'YES') {
      // handleUpdateAvalable(resHeader);
    } else if (resHeader['RENEW-USER']?[0] == 'YES') {
      handleRenewUser(resHeader);
    }
  }

  void handleRenewUser(header) {
    // _authController.renewUser();
  }

  void handleMaintenance(header) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: '',
      titlePadding: EdgeInsets.zero,
      content: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: kPrimaryDarkColor,
                ),
              ),
              child: const Icon(
                Icons.settings_suggest,
                size: 30,
                color: kPrimaryDarkColor,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "App Under Maintenance",
              style: textHeader.merge(
                TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Platform.isAndroid
                ? GestureDetector(
                    onTap: (){},
                    child: Container(
                      alignment: AlignmentDirectional.topStart,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: kPrimaryDarkColor,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        child: Center(
                          child: Text(
                            "Exit App",
                            style: textHeader.merge(
                              const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 0.w,
                  )
          ],
        ),
      ),
    );
  }

  // void handleUpdateAvalable(header) async {
  //   dio.Headers headers = header;
  //
  //   String currentVersion = await getAppCurrentVersion();
  //   String newVersion = '';
  //   String whatsNewMessage = '';
  //
  //   if (headers['new_version'] != null && headers['new_version']!.isNotEmpty) {
  //     newVersion = headers['new_version']![0];
  //   }
  //   if (headers['new_version_desc'] != null &&
  //       headers['new_version_desc']!.isNotEmpty) {
  //     whatsNewMessage = headers['new_version_desc']![0];
  //   }
  //
  //   if (headerController.showUpdatePopUp.isTrue) {
  //     Get.defaultDialog(
  //       barrierDismissible: false,
  //       title: '',
  //       titlePadding: EdgeInsets.zero,
  //       content: Column(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(18.w),
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               border: Border.all(
  //                 width: 1,
  //                 color: colorBlueDark,
  //               ),
  //             ),
  //             child: const Icon(
  //               Icons.system_update_alt,
  //               size: 30,
  //               color: colorBlueDark,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10.h,
  //           ),
  //           Text(
  //             "New Update Available",
  //             style: textTitle14BoldStyle.merge(
  //               TextStyle(fontSize: 16.sp, color: Colors.black),
  //             ),
  //           ),
  //           Text.rich(
  //             TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: "Current Version : ",
  //                   style: textTitle12BoldStyle.merge(
  //                     TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14.sp,
  //                       fontWeight: FontWeight.normal,
  //                     ),
  //                   ),
  //                 ),
  //                 TextSpan(
  //                   text: currentVersion,
  //                   style: textTitle12BoldStyle.merge(
  //                     TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Text.rich(
  //             TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: "New Version : ",
  //                   style: textTitle12BoldStyle.merge(
  //                     TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14.sp,
  //                       fontWeight: FontWeight.normal,
  //                     ),
  //                   ),
  //                 ),
  //                 TextSpan(
  //                   text: newVersion,
  //                   style: textTitle12BoldStyle.merge(
  //                     TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           whatsNewMessage.isNotEmpty
  //               ? Text("What's New : $whatsNewMessage")
  //               : Container(),
  //           SizedBox(
  //             height: 20.h,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               GestureDetector(
  //                 onTap: () {
  //                   Get.back();
  //                   headerController.changeStatus();
  //                 },
  //                 child: Container(
  //                   alignment: AlignmentDirectional.topStart,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(6)),
  //                       border: Border.all(width: 1, color: colorBlue),
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                         horizontal: 15.w, vertical: 10.h),
  //                     child: Center(
  //                       child: Text(
  //                         "Skip Update",
  //                         style: textFormSmallerTitleStyle.merge(
  //                           const TextStyle(
  //                             color: colorBlueDark,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10.w,
  //               ),
  //               GestureDetector(
  //                 onTap: openPlayStoreAppStore,
  //                 child: Container(
  //                   alignment: AlignmentDirectional.topStart,
  //                   child: Container(
  //                     decoration: const BoxDecoration(
  //                       borderRadius: BorderRadius.all(Radius.circular(6)),
  //                       color: colorBlue,
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                         horizontal: 15.w, vertical: 10.h),
  //                     child: Center(
  //                       child: Text(
  //                         "Update Now",
  //                         style: textFormSmallerTitleStyle.merge(
  //                           const TextStyle(
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  // void handleVersionExpired(header) async {
  //   dio.Headers headers = header;
  //   String currentVersion = await getAppCurrentVersion();
  //   String newVersion = '';
  //   String whatsNewMessage = '';
  //
  //   if (headers['new_version'] != null && headers['new_version']!.isNotEmpty) {
  //     newVersion = headers['new_version']![0];
  //   }
  //   if (headers['new_version_desc'] != null &&
  //       headers['new_version_desc']!.isNotEmpty) {
  //     whatsNewMessage = headers['new_version_desc']![0];
  //   }
  //
  //   Get.defaultDialog(
  //     barrierDismissible: false,
  //     title: '',
  //     titlePadding: EdgeInsets.zero,
  //     content: WillPopScope(
  //       onWillPop: () async => false,
  //       child: Column(
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(18.w),
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               border: Border.all(
  //                 width: 1,
  //                 color: colorBlueDark,
  //               ),
  //             ),
  //             child: const Icon(
  //               Icons.system_update_alt,
  //               size: 30,
  //               color: colorBlueDark,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10.h,
  //           ),
  //           Text(
  //             "New Update Available",
  //             style: textTitle14BoldStyle.merge(
  //               TextStyle(fontSize: 16.sp, color: Colors.black),
  //             ),
  //           ),
  //           Text.rich(
  //             TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: "Current Version : ",
  //                   style: textTitle12BoldStyle.merge(
  //                     TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14.sp,
  //                       fontWeight: FontWeight.normal,
  //                     ),
  //                   ),
  //                 ),
  //                 TextSpan(
  //                   text: currentVersion,
  //                   style: textTitle12BoldStyle.merge(
  //                     TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Text.rich(
  //             TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: "New Version : ",
  //                   style: textTitle12BoldStyle.merge(
  //                     TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14.sp,
  //                       fontWeight: FontWeight.normal,
  //                     ),
  //                   ),
  //                 ),
  //                 TextSpan(
  //                   text: newVersion,
  //                   style: textTitle12BoldStyle.merge(
  //                     TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           whatsNewMessage.isNotEmpty
  //               ? Text("What's New : $whatsNewMessage")
  //               : Container(),
  //           SizedBox(
  //             height: 20.h,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Platform.isAndroid
  //                   ? GestureDetector(
  //                       onTap: forceClosedApp,
  //                       child: Container(
  //                         alignment: AlignmentDirectional.topStart,
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             borderRadius:
  //                                 const BorderRadius.all(Radius.circular(6)),
  //                             border: Border.all(width: 1, color: colorBlue),
  //                           ),
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal: 15.w, vertical: 10.h),
  //                           child: Center(
  //                             child: Text(
  //                               "Exit App ",
  //                               style: textFormSmallerTitleStyle.merge(
  //                                 const TextStyle(
  //                                   color: colorBlueDark,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   : SizedBox(
  //                       width: 0.w,
  //                     ),
  //               Platform.isAndroid
  //                   ? SizedBox(
  //                       width: 10.w,
  //                     )
  //                   : SizedBox(
  //                       width: 0.w,
  //                     ),
  //               GestureDetector(
  //                 onTap: openPlayStoreAppStore,
  //                 child: Container(
  //                   alignment: AlignmentDirectional.topStart,
  //                   child: Container(
  //                     decoration: const BoxDecoration(
  //                       borderRadius: BorderRadius.all(Radius.circular(6)),
  //                       color: colorBlue,
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                         horizontal: 15.w, vertical: 10.h),
  //                     child: Center(
  //                       child: Text(
  //                         "Update Now",
  //                         style: textFormSmallerTitleStyle.merge(
  //                           const TextStyle(
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
