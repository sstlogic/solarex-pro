class AppointmentListbyDateModel {
  String? status;
  String? message;

  List<AppointmentListbyDate>? appointmentList;

  AppointmentListbyDateModel({this.status, this.message, this.appointmentList});

  AppointmentListbyDateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['Data'] != null) {
      appointmentList = <AppointmentListbyDate>[];
      json['Data'].forEach((v) {
        appointmentList!.add(AppointmentListbyDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;

    if (appointmentList != null) {
      data['Data'] = appointmentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppointmentListbyDate {
  String? id;
  String? salesUserid;
  String? contactId;
  String? name;
  String? meetingCode;
  String? prospectEmail;
  String? startDate;
  String? startTime;
  String? endDate;
  String? endTime;
  String? medium;
  String? language;
  String? mark;
  String? insertedBy;

  AppointmentListbyDate(
      {this.id,
      this.salesUserid,
      this.contactId,
      this.name,
      this.meetingCode,
      this.prospectEmail,
      this.startDate,
      this.startTime,
      this.endDate,
      this.endTime,
      this.medium,
      this.language,
      this.mark,
      this.insertedBy});

  AppointmentListbyDate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesUserid = json['sales_userid'];
    contactId = json['contact_id'];
    name = json['name'];
    meetingCode = json['meeting_code'];
    prospectEmail = json['prospect_email'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    medium = json['medium'];
    language = json['language'];
    mark = json['mark'];
    insertedBy = json['inserted_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sales_userid'] = salesUserid;
    data['contact_id'] = contactId;
    data['name'] = name;
    data['meeting_code'] = meetingCode;
    data['prospect_email'] = prospectEmail;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_date'] = endDate;
    data['end_time'] = endTime;
    data['medium'] = medium;
    data['language'] = language;
    data['mark'] = mark;
    data['inserted_by'] = insertedBy;
    return data;
  }
}
