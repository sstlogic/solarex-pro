import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/models/allTaskModel.dart';
import 'package:solarex/second_phase/models/getProfileModel.dart';
import 'package:solarex/second_phase/models/getschedulebyappointment.dart';
import 'package:solarex/second_phase/models/selectedTeamMemberModel.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/network.dart';

import '../models/MemberDetailsModel.dart';
import '../models/teamFriendListModel.dart';

class ProfileController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  RxBool loadingAllTask = false.obs;
  RxBool loadinggetScheduleData = false.obs;
  RxBool loadingformData = false.obs;
  RxBool loadinggetFriendsList = false.obs;
  RxBool loadingEditMember = false.obs;
  RxBool loadingMemberDetails = false.obs;
  RxBool loadingSubmitMemberList = false.obs;
  final userProfileData = GetProfileModel().obs;
  final allTaskListModel = AllTaskModel().obs;
  final getschedulebyappointment = Getschedulebyappointment().obs;
  final teamFriendListModel = TeamFriendListModel().obs;

  final memberDetailsModel = MemberDetailsModel().obs;
  final notSubmitedTeamMemList = NotSubmitedMemberList().obs;
  RxList<SelectedContactMember> selectedTeamMemberList = [SelectedContactMember()].obs;
  RxList<TeamFriendsItem> selectedTeamFriendList = [TeamFriendsItem()].obs;

  // RxList<SelectedContactMember> notSubmitedTeamMemList = [SelectedContactMember()].obs;

  Future<String> getUserProfile({
    required String? userId,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_profile?id=$userId',
      );

      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["status"] == "302") {
          return "inactive";
        } else {
          if (jsonData["Data"] != null) {
            userProfileData.value = GetProfileModel.fromJson(jsonData);
          }
          return "active";
        }
      }
      return "";
    } catch (e) {
      return "";
    } finally {
      loading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String? userId,
    required String? firstName,
    required String? lastName,
    required String? mobile,
    required String? email,
    required String? imageString,
    required String? introEng,
    required String? introEs,
    required String? introFr,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}update_profile',
          data: dio.FormData.fromMap({
            'id': userId,
            'first_name': firstName,
            'last_name': lastName,
            'mobile': mobile,
            'email': email,
            'user_pic': imageString,
            'intro_en': introEng,
            'intro_es': introEs,
            'intro_fr': introFr,
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Profile Update Sucessfully');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loading.value = false;
    }
  }

  getAllTask() async {
    loadingAllTask.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}all_tasks?sales_userid=$userId',
      );
      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);

        if (jsonData["Data"] != null) {
          allTaskListModel.value = AllTaskModel.fromJson(jsonData);
        }
      }
    } catch (e) {
      return false;
    } finally {
      loadingAllTask.value = false;
    }
  }

  Future<bool> getScheduleByAppointment({required String contectId, required String appointmentId}) async {
    loadinggetScheduleData.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_schedule_callback_appointment?contact_id=$contectId&sales_userid=$userId&appointment_id=$appointmentId',
      );
      print("URL===${response.realUri}");
      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["Data"] != null) {
          getschedulebyappointment.value = Getschedulebyappointment.fromJson(jsonData);
        }
        return true;
      }
      return false;
    } catch (e) {
      // Fluttertoast.showToast(msg: "");
      return false;
    } finally {
      loadinggetScheduleData.value = false;
    }
  }

  Future<bool> setScheduleCallBack({
    required String? contectId,
    required String? notifyMe,
    required String? date,
    required String? time,
    required String? appointmentId,
  }) async {
    loadinggetScheduleData.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}schedule_callback_appointment',
          data: dio.FormData.fromMap(
              {'contact_id': contectId, 'sales_userid': userId, 'notify_me': notifyMe, 'date': date, 'time': time, 'appointment_id': appointmentId}));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadinggetScheduleData.value = false;
    }
  }

  Future<bool> addSubmitedTeamMember({
    required RxList<SelectedContactMember> teamMemberList,
  }) async {
    loadingSubmitMemberList.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}add_team_member',
          data: dio.FormData.fromMap({
            'sales_userid': userId,
            'membar_data': jsonEncode(teamMemberList),
          }));

      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["message"] != null) {
          Fluttertoast.showToast(msg: jsonData["message"]);
        }
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadingSubmitMemberList.value = false;
    }
  }

  Future<bool> getSubmittedFriendList() async {
    loadinggetFriendsList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}all_team_member?sales_userid=$userId',
      );

      if (response.statusCode == 200) {
        teamFriendListModel.value.teamFriendsList?.clear();
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["Data"] != null) {
          teamFriendListModel.value = TeamFriendListModel.fromJson(jsonData);
        }
        return true;
      }
      return false;
    } catch (e) {
      // Fluttertoast.showToast(msg: "");
      return false;
    } finally {
      loadinggetFriendsList.value = false;
    }
  }

  Future<bool> editTeamMember({
    required String memberId,
    required String firstName,
    required String lastName,
    required String refName,
  }) async {
    loadingEditMember.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}edit_team_member',
          data: dio.FormData.fromMap(
              {'sales_userid': userId, 'first_name': firstName, 'last_name': lastName, 'member_id': memberId, 'referred_by': refName}));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Edit Successfully');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadingEditMember.value = false;
    }
  }

  Future<bool> getMemberDetails({required String memberId}) async {
    loadingMemberDetails.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_member_detail?member_id=$memberId&sales_userid=$userId',
      );

      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["Data"] != null) {
          memberDetailsModel.value = MemberDetailsModel.fromJson(jsonData);
        }
        return true;
      }
      return false;
    } catch (e) {
      // Fluttertoast.showToast(msg: "");
      return false;
    } finally {
      loadingMemberDetails.value = false;
    }
  }

  Future<bool> getNotSubmitedTeamMemberList() async {
    loadingSubmitMemberList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}all_notsubmit_contact?sales_userid=$userId',
      );

      if (response.statusCode == 200) {
        notSubmitedTeamMemList.value.notSubmitedList?.clear();
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["Data"] != null) {
          notSubmitedTeamMemList.value = NotSubmitedMemberList.fromJson(jsonData);
        }
        return true;
      }
      return false;
    } catch (e) {
      // Fluttertoast.showToast(msg: "");
      return false;
    } finally {
      loadingSubmitMemberList.value = false;
    }
  }

  Future<bool> introducedFormAPI({required var memberData, String? doYouKnow, String? activities, String? doYouThink, String? otherField}) async {
    loadingformData.value = true;

    try {
      print('userId===${userId}');
      print('datadata===${memberData}');
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}add_member_introduce',
          data: dio.FormData.fromMap({
            'sales_userid': userId,
            'membar_data': jsonEncode(memberData),
            'do_you_know': doYouKnow,
            'what_activities': activities,
            'do_you_think': doYouThink,
            'do_you_know_other': otherField
            // 'sales_userid': userId,
            // 'membar_data': jsonEncode(data),
            // 'do_you_know': 'doYouKnow',
            // 'what_activities': 'activities',
            // 'do_you_think': 'doYouThink'
          }));
      print('response.statusCode===${response.statusCode}');
      print('datadata===${response}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: '$error');
      return false;
    } finally {
      loadingformData.value = false;
    }
  }
}
