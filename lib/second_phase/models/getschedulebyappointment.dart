class Getschedulebyappointment {
  String? status;
  String? message;
  ScheduleData? scheduleData;

  Getschedulebyappointment({this.status, this.message, this.scheduleData});

  Getschedulebyappointment.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    scheduleData = json['Data'] != null ? ScheduleData.fromJson(json['Data']) : null;
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

class ScheduleData {
  String? id;
  String? salesUserid;
  String? contactId;
  String? appointmentId;
  String? date;
  String? time;
  String? notifyMe;
  String? insertBy;

  ScheduleData(
      {this.id,
        this.salesUserid,
        this.contactId,
        this.appointmentId,
        this.date,
        this.time,
        this.notifyMe,
        this.insertBy});

  ScheduleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesUserid = json['sales_userid'];
    contactId = json['contact_id'];
    appointmentId = json['appointment_id'];
    date = json['date'];
    time = json['time'];
    notifyMe = json['notify_me'];
    insertBy = json['insert_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sales_userid'] = salesUserid;
    data['contact_id'] = contactId;
    data['appointment_id'] = appointmentId;
    data['date'] = date;
    data['time'] = time;
    data['notify_me'] = notifyMe;
    data['insert_by'] = insertBy;
    return data;
  }
}