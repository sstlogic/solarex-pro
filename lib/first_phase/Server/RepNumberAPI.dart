import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:solarex/utils/constants.dart';
import 'package:solarex/first_phase/apiModel/repNumResponseModel.dart';

repNumberAPI(String repNumber, Function(String? message,String? status) callback,
    Function(String) callbackError) async {
  try {

    var url = "${ConstantClass.baseURL}get_user?rep=$repNumber";
    print("url=====$url");
    var response = await http.Client()
        .get(Uri.parse(url))
        .timeout(const Duration(minutes: 1));

    var jsonResult = json.decode(response.body);
    ConstantClass.repNumResponse = RepNumResponse.fromJson(jsonResult);

    var msg = ConstantClass.repNumResponse?.message;

    if (msg != null && msg.isNotEmpty && msg == 'Valid') {
      if (ConstantClass.repNumResponse?.message != null) {
        ConstantClass.repNumber=ConstantClass.repNumResponse!.repNumUserData!.repNumber!;
        callback(ConstantClass.repNumResponse?.message,ConstantClass.repNumResponse?.status);
      } else {
        callbackError("Please Enter Valid REP Number");
      }
    } else {
      callbackError("${ConstantClass.repNumResponse?.message}");
    }
  } catch (ex) {

    callbackError(ex.toString());
  }
}
