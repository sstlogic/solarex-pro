
class beanData {
  String? status;
  String? message;
  Data? data;

  beanData({this.status, this.message, this.data});

  beanData.fromJson(Map<String, dynamic> json) {
    status = json['status '];
    message = json['message'];
    data = json['Data'] != null ?  Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status '] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? firstName;
  String? lastName;
  String? phone;
  String? mobile;
  String? email;
  String? repNumber;
  String? video;
  String? contractDate;
  Null? authCode;

  Data(
      {this.firstName,
        this.lastName,
        this.phone,
        this.mobile,
        this.email,
        this.repNumber,
        this.video,
        this.contractDate,
        this.authCode});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    mobile = json['mobile'];
    email = json['email '];
    repNumber = json['rep_number'];
    video = json['video'];
    contractDate = json['contract_date'];
    authCode = json['auth_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['mobile'] = this.mobile;
    data['email '] = this.email;
    data['rep_number'] = this.repNumber;
    data['video'] = this.video;
    data['contract_date'] = this.contractDate;
    data['auth_code'] = this.authCode;
    return data;
  }
}