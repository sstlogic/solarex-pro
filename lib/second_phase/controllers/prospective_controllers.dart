import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:solarex/second_phase/models/allAppointmentListModel.dart';
import 'package:solarex/second_phase/models/allnotesModel.dart';
import 'package:solarex/second_phase/models/bookAppointmentModel.dart';
import 'package:solarex/second_phase/models/commonmodel.dart';
import 'package:solarex/second_phase/models/getScheduleModel.dart';
import 'package:solarex/second_phase/models/messageListModel.dart';
import 'package:solarex/second_phase/models/prospective_details.dart';
import 'package:solarex/second_phase/models/prospective_listmodel.dart';
import 'package:solarex/second_phase/models/referralUserListModel.dart';
import 'package:solarex/second_phase/models/statusListModel.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/network.dart';

class ProspectiveController extends GetxController {
  APIClient apiClient = APIClient();
  RxBool loading = false.obs;
  RxBool loadingProspectiveList = false.obs;
  RxBool loadingRefferalList = false.obs;
  RxBool loadingStatusList = false.obs;
  RxBool loadingstatsData = false.obs;
  RxBool loadingProspectDetailsData = false.obs;

  // RxBool loadingAppointment = false.obs;
  RxBool loadingBookAppointment = false.obs;
  RxBool loadingAppointmentList = false.obs;
  RxBool loadingDeleteAppointment = false.obs;
  RxBool loadingcontectUpdateStatus = false.obs;
  RxBool loadingNoteList = false.obs;
  RxBool loadingMessageList = false.obs;
  RxBool loadingAddedNotes = false.obs;
  final prospectiveListModel = ProspectiveListModel().obs;
  final referralUserListModel = ReferralUserListModel().obs;
  final prospectiveDetails = ProspectiveDetailsModel().obs;
  final bookAppointmentModel = BookAppointmentModel().obs;
  final allAppointmentListModel = AllAppointmentListModel().obs;
  final statusListModel = StatusListModel().obs;
  final messageListModel = MessageListModel().obs;
  final messageContainModel = MessageContainModel().obs;
  final getScheduleModel = GetScheduleModel().obs;
  final allNotesModel = AllNotesModel().obs;
  final commonModel = CommonModel().obs;
  RxBool notifyScheduleDate = false.obs;
  RxString contectIdforRef = ''.obs;
  Future<bool> addProspective({
    required String? id,
    required String? name,
    required String? mobile,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}contact_add',
          data: dio.FormData.fromMap({
            'id': id,
            'name': name,
            'mobile': mobile,
          }));
      print("DATA=====${response.statusCode}");
      print("DATA=====${response.data}");
      print("DATA=====${response.data}");

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Add Prospect Successfully');
        // contectIdforRef
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        commonModel.value = CommonModel.fromJson(jsonData);
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

  Future getProspectiveList({
    required String? userId,
  }) async {
    loadingProspectiveList.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}prospective_contact?id=$userId',
      );
      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        prospectiveListModel.value.prospectiveContectList?.clear();
        if (jsonData["response"] != null) {
          prospectiveListModel.value = ProspectiveListModel.fromJson(jsonData);
        }
      }
    } catch (e) {
      return false;
    } finally {
      loadingProspectiveList.value = false;
    }
  }

  Future getRefferalUserList({
    required String? userId,
    required String? meetingCode,
  }) async {
    loadingRefferalList.value = true;

    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_total_referred_by?sales_userid=$userId&meeting_number=$meetingCode',
      );
      print('response---->${response.realUri}');
      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        referralUserListModel.value.referralUserList?.clear();
        if (jsonData["Data"] != null) {
          referralUserListModel.value = ReferralUserListModel.fromJson(jsonData);
        }
      }
    } catch (e) {
      return false;
    } finally {
      loadingRefferalList.value = false;
    }
  }

  Future getProspectiveDetails({
    required String? contectId,
  }) async {
    loadingProspectDetailsData.value = true;
    print('CID===$contectId');
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_contact?contact_id=$contectId',
      );

      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        prospectiveDetails.value = ProspectiveDetailsModel.fromJson(jsonData);
      }
    } catch (e) {
      return false;
    } finally {
      loadingProspectDetailsData.value = false;
    }
  }

  Future<bool> setStatsData({
    required String? contectId,
    required String? married,
    required String? has_cutco,
    required String? bought_from_me,
    required String? age,
    required String? homeowner,
  }) async {
    loadingstatsData.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}contact_update',
          data: dio.FormData.fromMap({
            'contact_id': contectId,
            'married': married,
            'has_cutco': has_cutco,
            'bought_from_me': bought_from_me,
            'age': age,
            'homeowner': homeowner,
          }));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Save Successfully');
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadingstatsData.value = false;
    }
  }

  // Future getAppointMentList({
  //   required String? contectId,
  //   required String? meetingId,
  // }) async {
  //   loadingAppointment.value = true;
  //   print("contectID===${contectId}");
  //   print("userId===${userId}");
  //   try {
  //     dio.Response response = await apiClient.getData(
  //       url:
  //           '${ConstantClass.baseURL}get_appointment?contact_id=$contectId&sales_userid=${userId}&meeting_id=${meetingId}',
  //     );
  //     // get_appointment?contact_id=1&sales_userid=8&meeting_id=5
  //     if (response.statusCode == 200) {
  //       print(response.data);
  //       String jsonsDataString = response.data;
  //       final jsonData = jsonDecode(jsonsDataString);
  //       bookAppointmentModel.value = BookAppointmentModel.fromJson(jsonData);
  //     }
  //   } catch (e) {
  //
  //     return false;
  //   } finally {
  //     loadingAppointment.value = false;
  //   }
  // }

  Future<String> bookAppointment({
    required String? contact_id,
    required String? start_date,
    required String? start_time,
    required String? end_date,
    required String? end_time,
    required String? medium,
    required String? language,
    required String? prospect_email,
  }) async {
    loadingBookAppointment.value = true;
    print('C ID====>$contact_id');
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}book_appointment',
          data: dio.FormData.fromMap({
            'contact_id': contact_id,
            'sales_userid': userId,
            'start_date': start_date,
            'start_time': start_time,
            'end_date': end_date,
            'end_time': end_time,
            'medium': medium,
            'language': language,
            'prospect_email': prospect_email,
          }));

      // if (response.statusCode == 200) {
      //   return "";
      // } else {
      //   return "";
      // }

      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);

        if (jsonData["status"] == "302") {
          return "inactive";
        } else {
          return "active";
        }
      }
      return "";
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return "";
    } finally {
      loadingBookAppointment.value = false;
    }
  }

  Future<bool> editAppointment({
    required String? appointMentId,
    required String? startDate,
    required String? startTime,
    required String? endDate,
    required String? endTime,
    required String? medium,
    required String? language,
  }) async {
    loadingBookAppointment.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}edit_appointment',
          data: dio.FormData.fromMap({
            'appointment_id': appointMentId,
            'start_date': startDate,
            'start_time': startTime,
            'end_date': endDate,
            'end_time': endTime,
            'medium': medium,
            'language': language,
          }));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadingBookAppointment.value = false;
    }
  }

  Future getAppointmentList({
    required String? contactId,
  }) async {
    loadingAppointmentList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_all_appointment?contact_id=$contactId&sales_userid=$userId',
      );
      print("USER ID===$userId");
      if (response.statusCode == 200) {
        allAppointmentListModel.value.allAppointmentList?.clear();
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);

        if (jsonData["Data"] != null) {
          allAppointmentListModel.value = AllAppointmentListModel.fromJson(jsonData);
        }
      }
    } catch (e) {
      return false;
    } finally {
      loadingAppointmentList.value = false;
    }
  }

  Future getStatusList() async {
    loadingStatusList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}contact_status_list',
      );
      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["response"] != null) {
          statusListModel.value = StatusListModel.fromJson(jsonData);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "List Not Found");
      return false;
    } finally {
      loadingStatusList.value = false;
    }
  }

  Future<bool> deleteAppointment({
    required String? appointmentId,
  }) async {
    loadingDeleteAppointment.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}delete_appointment?appointment_id=$appointmentId',
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Unable to Delete");
      return false;
    } finally {
      loadingDeleteAppointment.value = false;
    }
  }

  Future<bool> statusUpdate({
    required String? contactId,
    required String? cStatus,
  }) async {
    loadingStatusList.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}contact_status_update',
          data: dio.FormData.fromMap({
            'contact_id': contactId,
            'status': cStatus,
          }));
      print('call status===${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadingStatusList.value = false;
    }
  }

  Future<bool> getMessageList() async {
    loadingMessageList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}contact_msg_list',
      );

      if (response.statusCode == 200) {
        // messageListModel
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["response"] != null) {
          messageListModel.value = MessageListModel.fromJson(jsonData);
        }
        return true;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Unable to Delete");
      return false;
    } finally {
      loadingMessageList.value = false;
    }
  }

  Future<bool> getMessageContain({required String textId, required String contectId}) async {
    loadingMessageList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_smstext?sales_userid=$userId&text_id=$textId&contact_id=$contectId',
      );

      if (response.statusCode == 200) {
        // messageListModel
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["response"] != null) {
          messageContainModel.value = MessageContainModel.fromJson(jsonData);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      loadingMessageList.value = false;
    }
  }

  Future<bool> addCallCount({
    required String? contectId,
  }) async {
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}contact_call_count_update', data: dio.FormData.fromMap({'contact_id': contectId, 'call_count': 1}));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    } finally {}
  }

  Future<bool> addTextCount({
    required String? contectId,
  }) async {
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}contact_text_count_update', data: dio.FormData.fromMap({'contact_id': contectId, 'text_count': 1}));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    } finally {}
  }

  Future<String> setScheduleCallBack({
    required String? contectId,
    required String? notifyMe,
    required String? date,
    required String? time,
  }) async {
    // loadingBookAppointment.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}schedule_callback',
          data: dio.FormData.fromMap({'contact_id': contectId, 'sales_userid': userId, 'notify_me': notifyMe, 'date': date, 'time': time}));

      // if (response.statusCode == 200) {
      //   return true;
      // } else {
      //   return false;
      // }
      print("Call JSON DATA===${response}");
      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);

        if (jsonData["status"] == "302") {
          return "inactive";
        } else {
          return "active";
        }
      }
      return "";
    } catch (error) {
      // Fluttertoast.showToast(msg: 'Unauthorized');
      return "";
    } finally {
      // loadingBookAppointment.value = false;
    }
  }

  Future<bool> getSchedule({required String contectId}) async {
    // loadingMessageList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}get_schedule_callback?contact_id=$contectId&sales_userid=$userId',
      );
      print("REAL GET URL====${response.realUri}");
      if (response.statusCode == 200) {
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["Data"] != null) {
          getScheduleModel.value = GetScheduleModel.fromJson(jsonData);
        }
        return true;
      }
      return false;
    } catch (e) {
      // Fluttertoast.showToast(msg: "");
      return false;
    } finally {
      // loadingMessageList.value = false;
    }
  }

  Future<bool> addNotesAPI({
    required String? contectId,
    required String? note,
  }) async {
    loadingAddedNotes.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}add_note', data: dio.FormData.fromMap({'contact_id': contectId, 'sales_userid': userId, 'note': note}));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadingAddedNotes.value = false;
    }
  }

  Future<bool> getAllNotes({required String contectId}) async {
    loadingNoteList.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}note_list?contact_id=$contectId&sales_userid=$userId',
      );
      if (response.statusCode == 200) {
        allNotesModel.value.allNotesList?.clear();
        String jsonsDataString = response.data;
        final jsonData = jsonDecode(jsonsDataString);
        if (jsonData["Data"] != null) {
          allNotesModel.value = AllNotesModel.fromJson(jsonData);
        }
        return true;
      }
      return false;
    } catch (e) {
      // Fluttertoast.showToast(msg: "");
      return false;
    } finally {
      loadingNoteList.value = false;
    }
  }

  Future<bool> deleteNotes({
    required String? noteId,
  }) async {
    // loadingDeleteAppointment.value = true;
    try {
      dio.Response response = await apiClient.getData(
        url: '${ConstantClass.baseURL}delete_note?note_id=$noteId',
      );
      print("URLLL===${response.realUri}");
      print("RESPONSE===${response.data}");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Unable to Delete");
      return false;
    } finally {
      // loadingDeleteAppointment.value = false;
    }
  }

  Future<bool> markCompleteAPI({
    required String? appointMentId,
    required String? markMessage,
  }) async {
    loadingStatusList.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}appointment_mark_complete',
          data: dio.FormData.fromMap({
            'appointment_id': appointMentId,
            'mark': markMessage,
          }));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Unauthorized');
      return false;
    } finally {
      loadingStatusList.value = false;
    }
  }

  Future<bool> uploadImage({
    required String? contactId,
    required String? imageFile,
  }) async {
    loading.value = true;
    try {
      dio.Response response = await apiClient.postData(
          url: '${ConstantClass.baseURL}add_contact_file', data: dio.FormData.fromMap({'contact_id': contactId, 'file': imageFile}));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Bill Upload Successfully');
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
}
