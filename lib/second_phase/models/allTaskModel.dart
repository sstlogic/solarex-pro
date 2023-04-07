class AllTaskModel {
  String? status;
  String? message;
  List<AllTaskList>? allTaskList;

  AllTaskModel({this.status, this.message, this.allTaskList});

  AllTaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Data'] != null) {
      allTaskList = <AllTaskList>[];
      json['Data'].forEach((v) {
        allTaskList!.add(AllTaskList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.allTaskList != null) {
      data['Data'] = this.allTaskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllTaskList {
  String? appointmentId;
  String? name;
  String? prospectEmail;
  String? startDate;
  String? startTime;
  String? endDate;
  String? endTime;
  String? contactId;

  AllTaskList(
      {this.appointmentId,
        this.name,
        this.prospectEmail,
        this.startDate,
        this.startTime,
        this.endDate,
        this.endTime,
        this.contactId
      });

  AllTaskList.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    name = json['name'];
    prospectEmail = json['prospect_email'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    contactId = json['contact_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointment_id'] = appointmentId;
    data['name'] = name;
    data['prospect_email'] = prospectEmail;
    data['start_date'] = startDate;
    data['start_time'] = startTime;
    data['end_date'] = endDate;
    data['end_time'] = endTime;
    data['contact_id'] = contactId;
    return data;
  }
}