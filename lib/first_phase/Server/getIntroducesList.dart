// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:solarex/first_phase/screenUI/viewShareScreen/model/getIntroducesResponse.dart';
// import 'package:solarex/utils/constants.dart';
//
// getIntroducesList(
//     String meetingNumber,
//     String repNumber,
//     Function(String? message, String? status, List<getIntroducesContectList>? mGetIntroducesContectList) callback,
//     Function(String) callbackError) async {
//   try {
//     var url = "${ConstantClass.baseURL}get_introduce?meeting_number=$meetingNumber&rep_number=$repNumber";
//     print("url=====$url");
//     var response = await http.Client().get(Uri.parse(url)).timeout(const Duration(minutes: 1));
//
//     var jsonResult = json.decode(response.body);
//     ConstantClass.getIntroducesResponse = GetIntroducesResponse.fromJson(jsonResult);
//
//     var msg = ConstantClass.getIntroducesResponse?.message;
//     print("RESPONSE====");
//     print(ConstantClass.getIntroducesResponse!.mGetIntroducesContectList);
//     if (msg != null && msg.isNotEmpty && msg == 'Valid') {
//       if (ConstantClass.getIntroducesResponse?.message != null) {
//         callback(ConstantClass.getIntroducesResponse?.message, ConstantClass.getIntroducesResponse?.status,
//             ConstantClass.getIntroducesResponse?.mGetIntroducesContectList);
//       } else {
//         callbackError("Please Enter Valid REP Number");
//       }
//     } else {
//       callbackError("${ConstantClass.getIntroducesResponse?.message}");
//     }
//   } catch (ex) {
//     callbackError(ex.toString());
//   }
// }
