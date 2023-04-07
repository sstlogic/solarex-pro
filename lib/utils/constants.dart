import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:solarex/first_phase/apiModel/meetingNumResponseModel.dart';
import 'package:solarex/first_phase/apiModel/repNumResponseModel.dart';
import 'package:solarex/first_phase/screenUI/model/beanDumpContacts.dart';
import 'package:solarex/first_phase/screenUI/shareScreen/model/beanContacts.dart';
import 'package:solarex/first_phase/screenUI/viewShareScreen/model/getIntroducesResponse.dart';
import 'package:solarex/utils/colors_app.dart';

// default values...
const defaultPadding = 16.0;
const defaultbuttonSpace = 8.0;
const userIdKey = "userIdKey";
const logInKey = "LoginKey";
const conTectUploadKey = "conTectUploadKey";
var userId = "0";
var isNavBar = false;

class ConstantClass {
  static var isEnableLog = true;
  static RepNumResponse? repNumResponse;
  static GetIntroducesResponse? getIntroducesResponse;
  static MeetingNumResponseModel? meetingNumResponseModel;
  static String baseURL = "http://www.app.solarexpro.com/admin/api/";
  static String meetingNumber = "";
  static String repNumber = "";
  static bool isViewContacts = false;
  static String ShareScreenHeadingMenu = "view shared";
  static List<beanContacts> selectedContactList = [];
  static beanDumpContacts? beanDumpContacts12;

  static PrintMessage(String message) {
    if (isEnableLog) {
      print(message);
    }
  }

  // used to get full height..
  static fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // used to get full height..
  static fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static OutlineInputBorder outlineInputBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: kSecondaryColor));

  static toastMessage({required String toastMessage}) {
    Fluttertoast.showToast(
        msg: toastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //Center Row contents horizontally,
      crossAxisAlignment: CrossAxisAlignment.center,
      //Center Row contents vertically,
      children: const [
        SizedBox(
          height: 60,
          width: 60,
          child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: [kPrimaryDarkColor],
            strokeWidth: 3.0,
            pathBackgroundColor: Colors.white,
          ),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
