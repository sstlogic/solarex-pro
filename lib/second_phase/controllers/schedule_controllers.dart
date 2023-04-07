import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/models/appointmentListbyDateModel.dart';
import 'package:solarex/second_phase/models/getgoalsdatamodel.dart';
import 'package:solarex/second_phase/models/scheduleCounterModel.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/network.dart';

class ScheduleController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loadingCounter = false.obs;
  RxBool loadingAppointmentList = true.obs;
  RxBool loadingSetGoals = false.obs;
  RxBool loadingGetGoals = false.obs;
  RxString goal = '0'.obs;
  RxInt appointments = 0.obs;
  final scheduleCounterModel = ScheduleCounterModel().obs;
  final appointmentListbyDateModel = AppointmentListbyDateModel().obs;
  final getGoalsDataModel = GetGoalsDataModel().obs;

  Future<bool> getScheduleCounter() async {
    loadingCounter.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}rep_schedules?sales_userid=$userId',
      );
      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["Data"] != null) {
          scheduleCounterModel.value = ScheduleCounterModel.fromJson(jsonData);
        }
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      return false;
    } finally {
      loadingCounter.value = false;
    }
  }

  Future<bool> getAppointmentByDate({required String selectedDate}) async {
    loadingAppointmentList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_appointment_by_date?start_date=$selectedDate&sales_userid=$userId',
      );
      print("url====${response.realUri}");
      if (response.statusCode == 200) {
        appointmentListbyDateModel.value.appointmentList?.clear();
        String jsonsDataString = response.data;

        final jsonData = jsonDecode(jsonsDataString);
        goal.value = jsonData["Goal"];
        appointments.value = jsonData["appointments"];
        if (jsonData["Data"] != null) {
          appointmentListbyDateModel.value = AppointmentListbyDateModel.fromJson(jsonData);
        }
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // print("ERROR===${error.toString()}");
      // Fluttertoast.showToast(msg: error.toString());
      return false;
    } finally {
      loadingAppointmentList.value = false;
    }
  }

  Future<bool> setGoals({
    required var dateDay1,
    required var dateDay2,
    required var dateDay3,
    required var dateDay4,
    required var dateDay5,
    required var dateDay6,
    required var dateDay7,
  }) async {
    loadingSetGoals.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}edit_goals',
          data: dio.FormData.fromMap({
            'sales_userid': userId,
            // 'sales_userid': '48',
            'date1': jsonEncode(dateDay1),
            'date2': jsonEncode(dateDay2),
            'date3': jsonEncode(dateDay3),
            'date4': jsonEncode(dateDay4),
            'date5': jsonEncode(dateDay5),
            'date6': jsonEncode(dateDay6),
            'date7': jsonEncode(dateDay7),
          }));
      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: 'Save Successfully');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadingSetGoals.value = false;
    }
  }

  Future<bool> getGoalData({required String startDate, required String endDate}) async {
    loadingGetGoals.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_goals?sales_userid=$userId&start_date=$startDate&end_date=$endDate',
        // url: '${ConstantClass.baseURL}get_goals?sales_userid=48&start_date=$startDate&end_date=$endDate',
      );

      if (response.statusCode == 200) {
        getGoalsDataModel.value.allGoalList?.clear();
        String jsonsDataString = response.data;

        final jsonData = jsonDecode(jsonsDataString);
        print('call RESP===>${jsonData["Data"]}');
        if (jsonData["Data"] != null) {
          getGoalsDataModel.value = GetGoalsDataModel.fromJson(jsonData);
        }
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // print("ERROR===${error.toString()}");
      Fluttertoast.showToast(msg: error.toString());
      return false;
    } finally {
      loadingGetGoals.value = false;
    }
  }
}
