class ScheduleCounterModel {
  String? status;
  String? message;
  ScheduleDate? scheduleData;

  ScheduleCounterModel({this.status, this.message, this.scheduleData});

  ScheduleCounterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    scheduleData = json['Data'] != null ? ScheduleDate.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (scheduleData != null) {
      data['Data'] = scheduleData!.toJson();
    }
    return data;
  }
}

class ScheduleDate {
  int? callCount;
  int? textCount;
  int? appointmentCount;
  String? referralCount;

  ScheduleDate(
      {this.callCount,
        this.textCount,
        this.appointmentCount,
        this.referralCount});

  ScheduleDate.fromJson(Map<String, dynamic> json) {
    callCount = json['call_count'];
    textCount = json['text_count'];
    appointmentCount = json['appointment_count'];
    referralCount = json['referral_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['call_count'] = callCount;
    data['text_count'] = textCount;
    data['appointment_count'] = appointmentCount;
    data['referral_count'] = referralCount;
    return data;
  }
}