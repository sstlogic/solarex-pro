import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:solarex/utils/constants.dart';
import 'package:solarex/first_phase/apiModel/meetingNumResponseModel.dart';

meetingNumberAPI(
    String meetingNumber,
    Function(String? message, String? status) callback,
    Function(String) callbackError) async {
  try {
    var url =
        "${ConstantClass.baseURL}check_meeting_number?meeting_number=$meetingNumber";
    print("url=====$url");
    var response = await http.Client()
        .get(Uri.parse(url))
        .timeout(const Duration(minutes: 1));

    var jsonResult = json.decode(response.body);
    ConstantClass.meetingNumResponseModel =
        MeetingNumResponseModel.fromJson(jsonResult);

    var msg = ConstantClass.meetingNumResponseModel?.message;
    if (msg != null && msg.isNotEmpty && msg == 'Valid') {
      if (ConstantClass.meetingNumResponseModel?.message != null) {
        ConstantClass.meetingNumber=meetingNumber;
        callback(ConstantClass.meetingNumResponseModel?.message,
            ConstantClass.meetingNumResponseModel?.status);
      } else {
        callbackError("${ConstantClass.meetingNumResponseModel?.message}");
      }
    } else {
      callbackError("${ConstantClass.meetingNumResponseModel?.message}");
    }
  } catch (ex) {
    callbackError(ex.toString());
  }
}
