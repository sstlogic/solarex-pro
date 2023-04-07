class BookAppointmentModel {
  String? status;
  String? message;
  Data? data;

  BookAppointmentModel({this.status, this.message, this.data});

  BookAppointmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? meetingCode;
  String? prospectEmail;
  String? startDate;
  String? startTime;
  String? endDate;
  String? endTime;
  String? medium;
  String? language;

  Data(
      {this.meetingCode,
        this.prospectEmail,
        this.startDate,
        this.startTime,
        this.endDate,
        this.endTime,
        this.medium,
        this.language});

  Data.fromJson(Map<String, dynamic> json) {
    meetingCode = json['meeting_code'];
    prospectEmail = json['prospect_email'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    medium = json['medium'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meeting_code'] = meetingCode;
    data['prospect_email'] = prospectEmail;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_date'] = endDate;
    data['end_time'] = endTime;
    data['medium'] = medium;
    data['language'] = language;
    return data;
  }
}