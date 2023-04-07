import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solarex/first_phase/screenUI/viewShareScreen/model/getIntroducesResponse.dart';
import 'package:solarex/second_phase/models/loginModel.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/network.dart';

class GetListController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;

  Future<bool> getList({
    required String? meetingNumber,
    required String? repNumber,
  }) async {
    loading.value = true;
    print('call API');
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}get_introduce?meeting_number=$meetingNumber&rep_number=$repNumber', data: dio.FormData.fromMap({}));

      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.data);
        ConstantClass.getIntroducesResponse = GetIntroducesResponse.fromJson(jsonResult);
        // for (int i = 0; i < ConstantClass.selectedContactList.length; i++) {
        //   var matchElements = findElementsUsingLoop(
        //       ConstantClass.getIntroducesResponse?.mGetIntroducesContectList ?? [], ConstantClass.selectedContactList[i].numbar);
        //   if (matchElements.isNotEmpty) {
        //     ConstantClass.selectedContactList[i].isIntroduced = true;
        //   }
        // }
        // Fluttertoast.showToast(msg: 'Registration Sucessfully');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error');
      return false;
    } finally {
      loading.value = false;
    }
  }
}

String findElementsUsingLoop(List<getIntroducesContectList> people, String personName) {
  for (var i = 0; i < people.length; i++) {
    if (people[i].mobNumber == personName) {
      return people[i].mobNumber.toString();
    }
  }
  return "";
}
