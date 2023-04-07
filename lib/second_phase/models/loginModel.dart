class loginModel {
  String? status;
  String? message;
  String? log;
  String? userId;

  loginModel({this.status, this.message, this.log, this.userId});

  loginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    log = json['log'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['log'] = log;
    data['user_id'] = userId;
    return data;
  }
}