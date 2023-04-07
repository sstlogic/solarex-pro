class MeetingNumResponseModel {
  String? status;
  String? message;
  // Response? response;

  // MeetingNumResponseModel({this.status, this.message, this.response});
  MeetingNumResponseModel({this.status, this.message, });

  MeetingNumResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status '];
    message = json['message'];
    // response =
    //     json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status '] = status;
    data['message'] = message;
    // if (response != null) {
    //   data['response'] = response!.toJson();
    // }
    return data;
  }
}

class Response {
  String? firstName;
  String? lastName;

  Response({this.firstName, this.lastName});

  Response.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
