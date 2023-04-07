class AllAppointmentListModel {
  String? status;
  String? message;
  List<AllAppointmentList>? allAppointmentList;

  AllAppointmentListModel({this.status, this.message, this.allAppointmentList});

  AllAppointmentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Data'] != null) {
      allAppointmentList = <AllAppointmentList>[];
      json['Data'].forEach((v) {
        allAppointmentList!.add(AllAppointmentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (allAppointmentList != null) {
      data['Data'] = allAppointmentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllAppointmentList {
  String? appointmentId;
  String? prospectEmail;
  String? startDate;
  String? startTime;
  String? endDate;
  String? endTime;
  String? language;
  String? mark;

  AllAppointmentList(
      {this.appointmentId,
        this.prospectEmail,
        this.startDate,
        this.startTime,
        this.endDate,
        this.endTime,
        this.language,
        this.mark
      });

  AllAppointmentList.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    prospectEmail = json['prospect_email'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    language = json['language'];
    mark = json['mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointment_id'] = appointmentId;
    data['prospect_email'] = prospectEmail;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_date'] = endDate;
    data['end_time'] = endTime;
    data['language'] = language;
    data['mark'] = mark;
    return data;
  }
}