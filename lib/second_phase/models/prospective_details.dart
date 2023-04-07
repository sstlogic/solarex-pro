class ProspectiveDetailsModel {
  String? status;
  String? message;
  Data? data;

  ProspectiveDetailsModel({this.status, this.message, this.data});

  ProspectiveDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? mobile;
  String? married;
  String? hasCutco;
  String? boughtFromMe;
  String? age;
  String? homeowner;
  String? note;
  String? call_count;
  String? text_count;
  String? status;
  String? call_answer;
  String? meetingCode;
  String? file;

  Data(
      {this.name,
      this.mobile,
      this.married,
      this.hasCutco,
      this.boughtFromMe,
      this.age,
      this.homeowner,
      this.note,
      this.call_count,
      this.text_count,
      this.status,
      this.call_answer,
      this.meetingCode,
      this.file});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    married = json['married'];
    hasCutco = json['has_cutco'];
    boughtFromMe = json['bought_from_me'];
    age = json['age'];
    homeowner = json['homeowner'];
    note = json['note'];
    call_count = json['call_count'];
    text_count = json['text_count'];
    status = json['status'];
    call_answer = json['call_answer'];
    meetingCode = json['meeting_code'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobile'] = mobile;
    data['married'] = married;
    data['has_cutco'] = hasCutco;
    data['bought_from_me'] = boughtFromMe;
    data['age'] = age;
    data['homeowner'] = homeowner;
    data['note'] = note;
    data['call_count'] = call_count;
    data['text_count'] = text_count;
    data['call_answer'] = call_answer;
    data['meeting_code'] = meetingCode;
    data['file'] = file;
    return data;
  }
}
