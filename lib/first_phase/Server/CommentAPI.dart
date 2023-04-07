import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:solarex/utils/constants.dart';
import 'package:solarex/first_phase/apiModel/meetingTimeResponseModel.dart';

commentAPI(
    String meetingNumber,String comment,
    Function(String? message, String? status) callback,
    Function(String) callbackError) async {
  try {
    var requestBody = {
      'meeting_number': meetingNumber,
      'comment': comment,

    };

    var url = "${ConstantClass.baseURL}comment";
    print("url=====$url");
    var response = await http.Client()
        .post(Uri.parse(url),body:requestBody )
        .timeout(const Duration(minutes: 1));

    var jsonResult = json.decode(response.body);
    MeetingTimeResponseModel meetingTimeResponseModel = MeetingTimeResponseModel.fromJson(jsonResult);

    var msg = meetingTimeResponseModel.message;
    var status = meetingTimeResponseModel.status;
    if (msg != null && msg.isNotEmpty && status == '200') {
      if (meetingTimeResponseModel.message != null) {
        callback(meetingTimeResponseModel.message,
            meetingTimeResponseModel.status);
      } else {
        callbackError("${meetingTimeResponseModel.message}");
      }
    } else {
      callbackError("${meetingTimeResponseModel.message}");
    }
  } catch (ex) {
    callbackError(ex.toString());
  }
}
