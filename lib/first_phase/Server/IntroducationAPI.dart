import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:solarex/utils/constants.dart';
import 'package:solarex/first_phase/apiModel/meetingNumResponseModel.dart';
import 'package:solarex/first_phase/apiModel/meetingTimeResponseModel.dart';

introduceAPI(
    String meetingNumber,String username,String mobileNumber,String message, String repNumber,
    Function(String? message, String? status) callback,
    Function(String) callbackError) async {


  try {
    ConstantClass.PrintMessage("meetingNumber perameters => ${meetingNumber.toString()}");
    ConstantClass.PrintMessage("username perameters => ${username.toString()}");
    ConstantClass.PrintMessage("mobileNumber perameters => ${mobileNumber.toString()}");
    ConstantClass.PrintMessage("message perameters => ${message.toString()}");
    ConstantClass.PrintMessage("image perameters => ${repNumber.toString()}");

    var requestBody = {
      'meeting_number': meetingNumber,
      'username': username,
      'mob_number': mobileNumber,
      'message': message,
      'rep_number': repNumber,
    };
    ConstantClass.PrintMessage("requestBody => $requestBody");
    var url = "${ConstantClass.baseURL}introduce";
    ConstantClass.PrintMessage("url=====$url");
    var response = await http.Client()
        .post(Uri.parse(url),body:requestBody ,)
        .timeout(const Duration(minutes: 1));

    var jsonResult = json.decode(response.body);
    MeetingTimeResponseModel meetingTimeResponseModel= MeetingTimeResponseModel.fromJson(jsonResult);

    var msg = meetingTimeResponseModel.message;
    var status = meetingTimeResponseModel.status;
    if (msg != null && msg.isNotEmpty && status == '200') {
      if (meetingTimeResponseModel.message != null) {
        callback(meetingTimeResponseModel.message,
            meetingTimeResponseModel.status);
      } else {
        ConstantClass.PrintMessage("ERROR=== $msg");
        callbackError("${meetingTimeResponseModel.message}");
      }
    } else {
      ConstantClass.PrintMessage("ERROR=== $msg");
      callbackError("${meetingTimeResponseModel.message}");
    }
  } catch (ex) {
    ConstantClass.PrintMessage("ERROR=== ${
        ex
    }");
    callbackError(ex.toString());
  }
}
