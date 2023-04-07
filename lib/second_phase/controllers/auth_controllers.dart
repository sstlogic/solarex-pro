import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/models/commonmodel.dart';
import 'package:solarex/second_phase/models/loginModel.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/network.dart';

class AuthController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  RxString loginMessage = "".obs;
  RxString loginstatus = "".obs;
  RxString loginuserId = "".obs;
  RxBool hideNav = false.obs;
  final commonModel = CommonModel().obs;
  Future<bool> registrationWithEmail({
    required String? firstName,
    required String? lastName,
    required String? email,
    required String? phoneNumber,
    required String? password,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}register',
          data: dio.FormData.fromMap({
            'fname': firstName,
            'lname': lastName,
            'email': email,
            'mobile': phoneNumber,
            'password': password,
          }));

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: 'Registration Sucessfully');
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        commonModel.value = CommonModel.fromJson(jsonData);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Something wrong');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> loginuser({
    required String? email,
    required String? password,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}login?email=$email&password=$password',
      );
      if (response.statusCode == 200) {
        var jsonResult = json.decode(response.data);
        loginModel loginmodeldata = loginModel.fromJson(jsonResult);
        loginMessage.value = loginmodeldata.message ?? '';
        loginstatus.value = loginmodeldata.log ?? '';
        loginuserId.value = loginmodeldata.userId ?? '';
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> sendContectToServer({
    required String? userId,
    required String? contectData,
  }) async {
    // loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}add_device_contacts',
          data: dio.FormData.fromMap({
            'sales_userid': userId,
            'contact_data': contectData,
          }));
      // Fluttertoast.showToast(msg: response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // Fluttertoast.showToast(msg: 'Incorrect Credentials');
      return false;
    } finally {
      // loading.value = false;
    }
  }
}
