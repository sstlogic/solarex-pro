class MeetingTimeResponseModel {
  String? status;
  String? message;
  String? response;

  MeetingTimeResponseModel({this.status, this.message, this.response});

  MeetingTimeResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status '] = status;
    data['message'] = message;
    data['response'] = response;
    return data;
  }
}