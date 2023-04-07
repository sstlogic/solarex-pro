class RepNumResponse {
  String? status;
  String? message;
  RepNumUserData? repNumUserData;

  RepNumResponse({this.status, this.message, this.repNumUserData});

  RepNumResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    repNumUserData = json['Data'] != null ? RepNumUserData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (repNumUserData != null) {
      data['Data'] = repNumUserData!.toJson();
    }
    return data;
  }
}

class RepNumUserData {
  String? firstName;
  String? lastName;
  String? phone;
  String? mobile;
  String? email;
  String? repNumber;
  String? userPic;
  String? bio;
  String? contractDate;
  String? authCode;

  RepNumUserData(
      {this.firstName, this.lastName, this.phone, this.mobile, this.email, this.repNumber, this.userPic, this.bio, this.contractDate, this.authCode});

  RepNumUserData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    mobile = json['mobile'];
    email = json['email'];
    repNumber = json['rep_number'];
    userPic = json['user_pic'];
    bio = json['bio'];
    contractDate = json['contract_date'];
    authCode = json['auth_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['mobile'] = mobile;
    data['email'] = email;
    data['rep_number'] = repNumber;
    data['user_pic'] = userPic;
    data['bio'] = bio;
    data['contract_date'] = contractDate;
    data['auth_code'] = authCode;
    return data;
  }
}
